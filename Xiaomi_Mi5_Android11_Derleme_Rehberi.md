# Xiaomi Mi 5 (gemini) Android 11 Derleme Rehberi: PixelGemini OS

Bu doküman, Windows 11 üzerinde WSL2 (Ubuntu 22.04) kullanarak Xiaomi Mi 5 (gemini) için optimize edilmiş, özel markalanmış (PixelGemini OS), reklamsız, yerleşik Google servislerine sahip (GApps built-in) ve saf Pixel deneyimi sunan Android 11 derleme adımlarını içerir.

---

### 1. Donanım ve Sistem Mimarisi
* **Proje Adı:** PixelGemini OS (Android 11)
* **Hedef Cihaz:** Xiaomi Mi 5 (Kod Adı: gemini)
* **Yonga Seti / Bellek:** Qualcomm Snapdragon 820 (MSM8996), 3 GB LPDDR4 RAM, 32 GB UFS 2.0 Depolama
* **Host Makine:** Windows 11, WSL2 (Ubuntu 22.04)
* **WSL Kaynak Ayarı:** 12 GB RAM + 13 GB Swap tahsisi.
* **Sanal Disk Stratejisi:** DrvFS dosya izin sorunlarını ve Windows disk I/O darboğazını aşmak için `E:\mi5-rom\mi5_build.vhdx` (170 GB ext4) kullanıldı.

---

### 2. Disk & Mount ve Swap Adımları

#### A. Windows PowerShell Tarafı
```powershell
# Dinamik VHDX oluşturma (diskpart)
create vdisk file="E:\mi5-rom\mi5_build.vhdx" maximum=174080 type=expandable

# WSL sanal makine erişim izinleri (E_ACCESSDENIED çözümü)
icacls "E:\mi5-rom" /grant "*S-1-5-83-0:(OI)(CI)(F)" /t
icacls "E:\mi5-rom\mi5_build.vhdx" /grant "Everyone:(F)"

# WSL2'ye ham blok aygıt olarak bağlama
wsl --mount "E:\mi5-rom\mi5_build.vhdx" --vhd --bare
```

#### B. WSL2 (Ubuntu) Tarafı: ext4 Format, Mount ve 12GB Swap
```bash
sudo mkfs.ext4 -F /dev/sdd
mkdir -p /mnt/e/mi5-rom/workspace
sudo mount /dev/sdd /mnt/e/mi5-rom/workspace
sudo chown -R $USER:$USER /mnt/e/mi5-rom/workspace
cd /mnt/e/mi5-rom/workspace

# 12 GB Swap dosyasını devreye alma (Soong/Ninja OOM koruması)
sudo fallocate -l 12G /mnt/e/mi5-rom/workspace/swapfile
sudo chmod 600 /mnt/e/mi5-rom/workspace/swapfile
sudo mkswap /mnt/e/mi5-rom/workspace/swapfile
sudo swapon /mnt/e/mi5-rom/workspace/swapfile
```

---

### 3. Derleme Bağımlılıkları ve Araçlar
```bash
sudo apt update && sudo apt install -y \
    bc bison build-essential ccache curl flex g++-multilib gcc-multilib git \
    git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev \
    lib32z1-dev libelf-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev \
    libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools \
    xsltproc zip zlib1g-dev python3 python-is-python3 openjdk-11-jdk libncurses6

# repo kurulumu
mkdir -p ~/bin
curl -s https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
export PATH=~/bin:$PATH

# Git kimliği
git config --global user.name "cicerali"
git config --global user.email "ali.cicerali@orioninc.com"
```

---

### 4. Kaynak Kod Tabanı ve Ağaç Yapılandırması
LineageOS 18.1 (Android 11) tabanı kullanılmıştır.

```bash
cd /mnt/e/mi5-rom/workspace
mkdir -p android11 && cd android11
repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --depth=1
```

#### A. Local Manifest (`.repo/local_manifests/gemini.xml`)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
    <!-- Xiaomi Mi 5 (gemini) Cihaz Agaci -->
    <project name="LineageOS/android_device_xiaomi_gemini" path="device/xiaomi/gemini" remote="github" revision="lineage-18.1" clone-depth="1" />
    
    <!-- MSM8996 Ortak Agaci -->
    <project name="LineageOS/android_device_xiaomi_msm8996-common" path="device/xiaomi/msm8996-common" remote="github" revision="lineage-18.1" clone-depth="1" />
    
    <!-- MSM8996 Linux Kernel 3.18 Agaci -->
    <project name="LineageOS/android_kernel_xiaomi_msm8996" path="kernel/xiaomi/msm8996" remote="github" revision="lineage-18.1" clone-depth="1" />
</manifest>
```

#### B. Senkronizasyon ve Donanım Tescilli İkili Sürücüleri (Vendor Blobs)
```bash
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags

# TheMuppets tescilli Qualcomm HAL / Kamera / Parmak İzi sürücüleri:
git clone --depth=1 -b lineage-17.1 https://gitlab.com/the-muppets/proprietary_vendor_xiaomi.git vendor/xiaomi
```

---

### 5. Donanım & Performans Optimizasyonları (3 GB RAM)
1. **ZRAM Yapılandırması:** 3 GB RAM'e sahip Mi 5 için ZRAM boyutu 1.5 GB LZ4 olarak ayarlandı.
```bash
find device/xiaomi/gemini -name "*.rc" -exec sed -i 's/write \/sys\/block\/zram0\/disksize .*/write \/sys\/block\/zram0\/disksize 1610612736/g' {} +
find device/xiaomi/msm8996-common -name "*.rc" -exec sed -i 's/write \/sys\/block\/zram0\/disksize .*/write \/sys\/block\/zram0\/disksize 1610612736/g' {} +
```

2. **Ccache (Derleme Önbelleği):**
```bash
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR=/mnt/e/mi5-rom/workspace/.ccache
ccache -M 50G
```

---

### 6. ROM Markalama & Saf Pixel Entegrasyonu (PixelGemini)
1. **Sistem Sürümü ve Zip Adı (`vendor/lineage/config/common.mk`):**
   * `LINEAGE_VERSION := PixelGemini-11.0-$(shell date -u +%Y%m%d)-gemini`
2. **Cihaz Modeli (`device/xiaomi/gemini/lineage_gemini.mk`):**
   * `PRODUCT_MODEL := Mi 5 (Pixel Edition)`
3. **Lineage Bloatware ve Telemetri Temizliği:**
   * Trebuchet, Jelly, Eleven, Recorder, LineageParts, LineageStats paketleri kaldırıldı.
4. **Google Pixel Bootanimation:**
   * Resmi Pixel açılış animasyonu sisteme dahil edildi.
5. **Dahili GApps (MindTheGapps built-in):**
   * `vendor/gapps` entegrasyonu sağlandı.
6. **Snapdragon İlgisiz Çip Ağaçlarının Temizlenmesi:**
   * `vendor/xiaomi` altındaki msm8953, msm8937 vb. Mi 5 dışı gereksiz Android.bp dosyaları silinerek Soong modül bağımlılık çakışmaları çözüldü.

---

### 7. Derleme (Build) Aşaması
```bash
source build/envsetup.sh
breakfast gemini
brunch gemini
```

**Derleme çıktısı:** `out/target/product/gemini/PixelGemini-11.0-*-gemini.zip`
