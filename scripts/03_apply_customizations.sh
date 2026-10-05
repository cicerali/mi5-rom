#!/usr/bin/env bash
set -e

WORKSPACE_DIR="${1:-/mnt/mi5workspace/android11}"
echo "=== [Step 3/4] Applying Hardware Optimizations and Pixel Branding ==="
echo "Target Workspace: $WORKSPACE_DIR"

cd "$WORKSPACE_DIR"

# 1. Hardware Optimization: Configure ZRAM to 1.5 GB LZ4 for 3GB RAM Mi 5
FSTAB_FILE="device/xiaomi/msm8996-common/rootdir/etc/fstab.qcom"
if [ -f "$FSTAB_FILE" ]; then
    echo "[*] Setting ZRAM size to 1.5GB LZ4..."
    sed -i 's/zramsize=[0-9]*/zramsize=1610612736/g' "$FSTAB_FILE"
fi

# 2. Pixel Branding & Built-in GApps Inheritance in lineage_gemini.mk
GEMINI_MK="device/xiaomi/gemini/lineage_gemini.mk"
if [ -f "$GEMINI_MK" ]; then
    echo "[*] Updating device model to 'Mi 5 (Pixel Edition)'..."
    sed -i 's/PRODUCT_MODEL := .*/PRODUCT_MODEL := Mi 5 (Pixel Edition)/g' "$GEMINI_MK"
    
    if ! grep -q "vendor/gapps/arm64/arm64-vendor.mk" "$GEMINI_MK"; then
        echo "[*] Adding built-in GApps inheritance..."
        echo "" >> "$GEMINI_MK"
        echo "# MindTheGapps (Android 11 built-in)" >> "$GEMINI_MK"
        echo "\$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)" >> "$GEMINI_MK"
    fi
fi

# 3. Custom ROM Branding (PixelGemini-11.0)
COMMON_MK="vendor/lineage/config/common.mk"
if [ -f "$COMMON_MK" ]; then
    if ! grep -q "PixelGemini" "$COMMON_MK"; then
        echo "[*] Setting ROM branding to PixelGemini-11.0..."
        cat << 'EOF' >> "$COMMON_MK"

# PixelGemini Branding
LINEAGE_VERSION := PixelGemini-11.0-$(shell date -u +%Y%m%d)-gemini
LINEAGE_DISPLAY_VERSION := $(LINEAGE_VERSION)
EOF
    fi
fi

# 4. Debloating Lineage stock apps (Eleven, Jelly, Recorder)
MOBILE_MK="vendor/lineage/config/common_mobile.mk"
if [ -f "$MOBILE_MK" ]; then
    echo "[*] Removing Lineage Eleven (music) and Jelly (browser)..."
    sed -i 's/[[:space:]]*Eleven[[:space:]]*\\//g' "$MOBILE_MK"
    sed -i 's/[[:space:]]*Jelly[[:space:]]*\\//g' "$MOBILE_MK"
fi

FULL_MK="vendor/lineage/config/common_full.mk"
if [ -f "$FULL_MK" ]; then
    echo "[*] Removing Lineage Recorder..."
    sed -i 's/[[:space:]]*Recorder[[:space:]]*\\?//g' "$FULL_MK"
fi

echo "[+] Customizations applied successfully!"
