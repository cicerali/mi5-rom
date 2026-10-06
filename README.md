# PixelGemini OS (Android 11) for Xiaomi Mi 5 (gemini)

[![Android Version](https://img.shields.io/badge/Android-11%20(LineageOS%2018.1)-green.svg)](https://www.android.com/)
[![Target Device](https://img.shields.io/badge/Device-Xiaomi%20Mi%205%20(gemini)-blue.svg)](https://wiki.lineageos.org/devices/gemini/)
[![SoC](https://img.shields.io/badge/SoC-Qualcomm%20Snapdragon%20820-orange.svg)](https://www.qualcomm.com/products/application/smartphones/snapdragon-8-series-mobile-platforms/snapdragon-820-mobile-platform)
[![Build Status](https://img.shields.io/badge/Build-Tested%20%26%20Working-brightgreen.svg)]()

**PixelGemini OS** is an optimized, debloated, and pure Google Pixel-styled custom ROM based on **LineageOS 18.1 (Android 11)** designed specifically for the **Xiaomi Mi 5 (gemini)**. It comes with built-in Google services (MindTheGapps), hardware performance tuning (1.5 GB LZ4 ZRAM), and all unnecessary Lineage bloatware removed.

This repository provides an automated, modular, and fully reproducible build pipeline that can be cloned and compiled on any **Ubuntu 22.04 LTS** environment (native Linux or **Windows 11 WSL2**).

---

## Key Features & Optimizations

* **Pure Pixel Experience:** Built-in Google Play Services, Play Store, and SetupWizard (`MindTheGapps rho`). Device model identified as `Mi 5 (Pixel Edition)` with official 1080p Pixel bootanimation, full Google Sans typography, Pixel UI circular icons, and 67 official Pixel sounds.
* **Hardware Performance Tuning:** ZRAM compressed swap configured to **1.5 GB LZ4** for maximum fluidity on 3 GB RAM devices.
* **Debloated & Clean (Zero Duplicates):** Removed legacy AOSP/Lineage apps (`Eleven`, `Jelly`, `Gallery2`, `LatinIME`, `ExactCalculator`, `Etar`, `Recorder`) and replaced them with curated modern and authentic Pixel applications.
* **100% Self-Hosted Independence:** Device tree, common tree, kernel, and proprietary vendor blobs are fully self-hosted under `github.com/cicerali` to eliminate 3rd-party breaking risks.
* **Original MIUI Capacitive Key Order:** Hardware navigation buttons follow the original Xiaomi MIUI layout by default (Left: Recents, Right: Back), dynamically toggleable anytime in *Settings > System > Buttons*.
* **Automated Git LFS Handling:** Automatically pulls Chromium WebView Git LFS binaries to eliminate the common 99% packaging crash.
* **Ccache Pre-configured:** 50 GB Ccache allocation for rapid incremental rebuilding (5-10 minutes on warm cache).

---

## Repository Structure

```
├── build_all.sh                    # Master script to run end-to-end build
├── manifests/
│   └── gemini.xml                  # Local manifest (gemini, msm8996-common, kernel 3.18)
├── pixel/                          # Self-contained Pure Pixel experience assets
│   ├── pixel.mk                    # Master makefile inheriting fonts, audio, overlays & apps
│   ├── bootanimation/              # Official Google Pixel 1080p boot animation
│   ├── fonts/                      # Google Sans (Product Sans) TTF font family & config
│   ├── audio/                      # Official Pixel sounds (67 ringtones, alarms, notifications)
│   ├── rro_overlays/               # Pixel circular icons and DocumentsUI RRO overlays
│   └── apps/                       # Curated ad-free pre-installed apps
│       ├── BreezyWeather/          # Modern open-source Material You weather app
│       ├── Cromite/                # Ad-free Chromium browser with native PDF reader
│       ├── Gboard/                 # Official Google smart multilingual keyboard
│       ├── GoogleCalculator/       # Official Pixel Calculator
│       ├── GoogleCalendar/         # Official Google Calendar with cloud sync
│       ├── GooglePhotos/           # Official Pixel Photos & gallery
│       ├── GoogleRecorder/         # Pixel live waveform voice recorder
│       ├── Gramophone/             # Material You offline music player
│       ├── MaterialFiles/          # Clean, ad-free open-source file manager
│       └── Omni/                   # Minimalist toolbox (compass, level, sensors, GPS)
├── scripts/
│   ├── 01_install_dependencies.sh  # Installs apt packages, openjdk-11, repo, git-lfs
│   ├── 02_init_and_sync.sh         # Inits LineageOS 18.1, syncs code, sparse blobs & GApps
│   ├── 03_apply_customizations.sh  # ZRAM 1.5GB, Pixel branding, GApps inheritance, debloating
│   └── 04_build_rom.sh             # Configures Ccache, breakfast gemini, brunch gemini
├── windows/
│   └── create_300gb_disk.ps1       # Extra setup script for Windows 11 WSL2 users (300GB VHDX)
├── TASKS.md                        # Phased project roadmap and milestone tracker
└── README.md                       # Comprehensive guide and documentation
```

---

## System Requirements

| Component | Minimum | Recommended |
| :--- | :--- | :--- |
| **Operating System** | Ubuntu 22.04 LTS (Jammy) | Ubuntu 22.04 LTS (Native or WSL2) |
| **CPU** | 4 Cores / 8 Threads | 8+ Cores / 16+ Threads |
| **RAM** | 16 GB Physical RAM | 32 GB RAM + 16 GB Swap (to prevent Soong OOM) |
| **Storage** | 250 GB free space | **300 GB ext4** SSD/NVMe (NTFS is NOT supported for Android builds) |

---

## Windows 11 / WSL2 Users: Extra Setup (300 GB Disk)

> [!IMPORTANT]
> **Why is a dedicated VHDX disk required for Windows users?**
> AOSP/LineageOS cannot be compiled directly on Windows NTFS file systems (`/mnt/c/` or `/mnt/d/`) due to Linux case-sensitivity requirements, symlinks, POSIX file permissions, and extreme DrvFS I/O performance penalties. 
> A dedicated **ext4 VHDX virtual disk** gives 100% native Linux disk performance and reliability.

### Step W1: Create 300GB VHDX Disk (Windows PowerShell - Admin)
Open PowerShell as **Administrator** and run:

```powershell
# Run the automated creation and attachment script:
Set-Location "D:\mi5-rom"  # Or your project directory
.\windows\create_300gb_disk.ps1 -DiskPath "D:\mi5-rom\mi5_build.vhdx" -SizeMB 307200
```
*Note: This creates an expandable/dynamic disk that starts at ~4 MB and only expands as files are compiled.*

### Step W2: Format & Mount in WSL2 (Ubuntu)
Open your **WSL2 Ubuntu terminal** and execute:

```bash
# 1. Identify the newly attached 300G disk (DO NOT use /dev/sdd if it belongs to Docker! Check size):
lsblk

# 2. Format the 300G block device (e.g. /dev/sdg) as ext4:
sudo mkfs.ext4 -F -L mi5_build /dev/sdX   # Replace sdX with your 300G device letter

# 3. Create mount point and mount:
sudo mkdir -p /mnt/mi5workspace
sudo mount /dev/sdX /mnt/mi5workspace
sudo chown -R $USER:$USER /mnt/mi5workspace

# 4. (Recommended) Activate 16 GB Swap to eliminate any OOM crash:
sudo fallocate -l 16G /mnt/mi5workspace/swapfile
sudo chmod 600 /mnt/mi5workspace/swapfile
sudo mkswap /mnt/mi5workspace/swapfile
sudo swapon /mnt/mi5workspace/swapfile
```

---

## Build Instructions (Linux & WSL2)

### Option 1: One-Click Full Build
If you want to run the entire pipeline automatically:

```bash
git clone https://github.com/cicerali/mi5-rom.git
cd mi5-rom
chmod +x build_all.sh scripts/*.sh

# Run end-to-end build (specify workspace path if different from default)
./build_all.sh /mnt/mi5workspace/android11
```

> **Live Monitoring:** To watch compilation progress in real-time in another terminal:
> ```bash
> tail -f /mnt/mi5workspace/build.log
> ```

---

### Option 2: Step-by-Step Modular Execution

#### Step 1: Install Build Tools & Dependencies
```bash
./scripts/01_install_dependencies.sh
```
*Installs OpenJDK 11, `build-essential`, `ccache`, `libncurses5-dev`, `git-lfs`, Google `repo` tool, and configures environment PATH.*

#### Step 2: Initialize & Sync Sources
```bash
./scripts/02_init_and_sync.sh /mnt/mi5workspace/android11
```
*Runs `repo init` for LineageOS 18.1, copies `manifests/gemini.xml`, syncs self-hosted device/kernel/common sources, downloads Chromium WebView Git LFS APKs, pulls isolated Mi 5 hardware blobs from `cicerali/proprietary_vendor_xiaomi_gemini`, and clones MindTheGapps (`rho`).*

#### Step 3: Apply Hardware Tuning & Pixel Branding
```bash
./scripts/03_apply_customizations.sh /mnt/mi5workspace/android11
```
*Configures 1.5 GB LZ4 ZRAM in `fstab.qcom`, sets model to `Mi 5 (Pixel Edition)`, adds built-in GApps inheritance, applies `PixelGemini-11.0` versioning, and cleans Lineage stock apps.*

#### Step 4: Compile ROM
```bash
./scripts/04_build_rom.sh /mnt/mi5workspace/android11 /mnt/mi5workspace/.ccache
```
*Initializes 50 GB Ccache, runs `breakfast gemini`, and starts `brunch gemini`.*

---

## Output Artifacts

When compilation finishes, the flashable release package and images will be available in:
* `release/lineage-PixelGemini-11.0-*-gemini.zip` (Flashable ROM with built-in GApps)
* `release/boot.img` (Kernel and ramdisk)
* `release/recovery.img` (Lineage Recovery)

---

## Flashing Instructions (Xiaomi Mi 5)

1. **Boot into TWRP Recovery:**
   * Power off your Xiaomi Mi 5.
   * Hold `Volume Up + Power` until the TWRP splash screen appears.
2. **Backup (Recommended):**
   * Go to `Backup` -> Select `Boot`, `System`, `Data` -> Swipe to Backup.
3. **Wipe:**
   * Go to `Wipe` -> `Advanced Wipe`.
   * Check: `Dalvik / ART Cache`, `System`, `Data`, `Cache`.
   * Swipe to Wipe.
4. **Install ROM:**
   * Connect your phone to your PC via USB.
   * Transfer `lineage-PixelGemini-11.0-*-gemini.zip` to internal storage (or use `adb sideload <filename>.zip`).
   * Select `Install` -> Select the zip file -> Swipe to confirm Flash.
   * *(Note: You do NOT need to flash a separate GApps package; Google Services are already built-in!)*
5. **Reboot:**
   * Select `Reboot System`.
   * Enjoy **PixelGemini OS** on your Xiaomi Mi 5!

---

## Credits & Upstream Sources
* [LineageOS Project](https://github.com/LineageOS)
* [TheMuppets](https://gitlab.com/the-muppets/proprietary_vendor_xiaomi) (Xiaomi proprietary blobs)
* [MindTheGapps](https://gitlab.com/MindTheGapps/vendor_gapps)
* Xiaomi Mi 5 maintainers and the XDA community
