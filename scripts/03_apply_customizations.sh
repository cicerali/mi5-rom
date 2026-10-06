#!/usr/bin/env bash
set -e

WORKSPACE_DIR="${1:-/mnt/mi5workspace/android11}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== [Step 3/4] Applying Hardware Optimizations and Pure Pixel Package ==="
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

# 3. Pure Pixel Experience Package (Bootanimation, Google Sans fonts, Pixel Sounds)
if [ -d "$REPO_ROOT/pixel" ]; then
    echo "[*] Installing Pixel assets (Bootanimation, Google Sans fonts, Pixel Audio) to vendor/pixel..."
    mkdir -p vendor/pixel
    cp -r "$REPO_ROOT/pixel"/* vendor/pixel/
    
    if [ -f "$GEMINI_MK" ] && ! grep -q "vendor/pixel/pixel.mk" "$GEMINI_MK"; then
        echo "[*] Adding Pixel package inheritance to lineage_gemini.mk..."
        echo "" >> "$GEMINI_MK"
        echo "# Pure Pixel Experience (Bootanimation, Google Sans, Pixel Audio)" >> "$GEMINI_MK"
        echo "\$(call inherit-product, vendor/pixel/pixel.mk)" >> "$GEMINI_MK"
    fi
fi

# 4. Custom ROM Branding (PixelGemini-11.0)
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

# 5. Debloating Lineage stock apps and bloatware
echo "[*] Purging Lineage bloatware (Updater, SetupWizard, Seedvault, Etar, Profiles, Backgrounds, Eleven, Jelly, Recorder)..."
python3 - << 'EOF'
import os, re

workspace = os.getcwd()

# 1. vendor/lineage/config/common.mk
common_mk = os.path.join(workspace, 'vendor/lineage/config/common.mk')
if os.path.isfile(common_mk):
    with open(common_mk, 'r') as f:
        lines = f.readlines()
    unwanted = ['LineageSetupWizard', 'Updater']
    new_lines = [l for l in lines if not any(re.search(rf'\b{pkg}\b', l) for pkg in unwanted)]
    with open(common_mk, 'w') as f:
        f.writelines(new_lines)

# 2. vendor/lineage/config/common_mobile.mk
mobile_mk = os.path.join(workspace, 'vendor/lineage/config/common_mobile.mk')
if os.path.isfile(mobile_mk):
    with open(mobile_mk, 'r') as f:
        lines = f.readlines()
    unwanted = ['Eleven', 'Jelly', 'Seedvault', 'Etar', 'Profiles', 'Backgrounds', 'ExactCalculator', 'Email', 'Exchange2']
    new_lines = [l for l in lines if not any(re.search(rf'\b{pkg}\b', l) for pkg in unwanted)]
    with open(mobile_mk, 'w') as f:
        f.writelines(new_lines)

# 3. vendor/lineage/config/common_full.mk
full_mk = os.path.join(workspace, 'vendor/lineage/config/common_full.mk')
if os.path.isfile(full_mk):
    with open(full_mk, 'r') as f:
        lines = f.readlines()
    new_lines = [l for l in lines if not re.search(r'\bRecorder\b', l)]
    with open(full_mk, 'w') as f:
        f.writelines(new_lines)
EOF

# 6. Default Capacitive Button Order: Original MIUI Layout (Left = Recents, Right = Back)
echo "[*] Setting default capacitive button order to MIUI layout (Left = Recents, Right = Back)..."
python3 - << 'EOF'
import os, re

workspace = os.getcwd()

# 1. Update LineageParts button_settings.xml defaultValue to true
button_xml = os.path.join(workspace, 'packages/apps/LineageParts/res/xml/button_settings.xml')
if os.path.isfile(button_xml):
    with open(button_xml, 'r') as f:
        content = f.read()
    pattern = r'(android:key="swap_capacitive_keys"[\s\S]*?android:defaultValue=)"false"'
    new_content = re.sub(pattern, r'\1"true"', content)
    with open(button_xml, 'w') as f:
        f.write(new_content)

# 2. Update ButtonSettings.java default fallback to true
button_java = os.path.join(workspace, 'packages/apps/LineageParts/src/org/lineageos/lineageparts/input/ButtonSettings.java')
if os.path.isfile(button_java):
    with open(button_java, 'r') as f:
        content = f.read()
    content = content.replace('preferences.getBoolean(KEY_SWAP_CAPACITIVE_KEYS, false)', 'preferences.getBoolean(KEY_SWAP_CAPACITIVE_KEYS, true)')
    with open(button_java, 'w') as f:
        f.write(content)

# 3. Initialize hardware node in init.qcom.sh
init_sh = os.path.join(workspace, 'device/xiaomi/msm8996-common/rootdir/etc/init.qcom.sh')
if os.path.isfile(init_sh):
    with open(init_sh, 'r') as f:
        content = f.read()
    if 'reversed_keys_enable' not in content:
        target = 'chown -LR system.system /proc/touchpanel\n'
        addition = 'chown -LR system.system /proc/touchpanel\nif [ -f /proc/touchpanel/reversed_keys_enable ]; then\n    echo 1 > /proc/touchpanel/reversed_keys_enable\nfi\n'
        content = content.replace(target, addition)
        with open(init_sh, 'w') as f:
            f.write(content)
EOF

echo "[+] Customizations and Pixel package applied successfully!"
