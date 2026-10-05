#!/usr/bin/env bash
set -e

# Base directory for Android 11 sources
WORKSPACE_DIR="${1:-/mnt/mi5workspace/android11}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== [Step 2/4] Initializing and Syncing LineageOS 18.1 for Xiaomi Mi 5 (gemini) ==="
echo "Target Workspace: $WORKSPACE_DIR"

mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR"
export PATH=$HOME/bin:$PATH

# 1. Repo Init
if [ ! -d ".repo" ]; then
    echo "[*] Initializing LineageOS 18.1 repo..."
    repo init -u https://github.com/LineageOS/android.git -b lineage-18.1 --depth=1
fi

# 2. Setup Local Manifests
echo "[*] Installing local manifest (gemini, msm8996-common, kernel 3.18)..."
mkdir -p .repo/local_manifests
cp "$REPO_ROOT/manifests/gemini.xml" .repo/local_manifests/gemini.xml

# 3. Repo Sync
echo "[*] Syncing sources (using $(nproc) threads)..."
repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags --current-branch

# 4. Pull Git LFS for Chromium WebView (Prevents packaging zip failure at 99%)
echo "[*] Ensuring Git LFS objects are downloaded for Chromium WebView..."
if [ -d "external/chromium-webview/prebuilt/arm64" ]; then
    cd external/chromium-webview/prebuilt/arm64
    git lfs pull || true
    cd "$WORKSPACE_DIR"
fi
if [ -d "external/chromium-webview/prebuilt/arm" ]; then
    cd external/chromium-webview/prebuilt/arm
    git lfs pull || true
    cd "$WORKSPACE_DIR"
fi

# 5. Sparse Checkout Proprietary Vendor Blobs (gemini + msm8996-common ONLY)
echo "[*] Fetching Xiaomi Mi 5 vendor drivers via sparse-checkout..."
mkdir -p vendor/xiaomi
cd vendor/xiaomi
if [ ! -d ".git" ]; then
    git init
    git remote add origin https://gitlab.com/the-muppets/proprietary_vendor_xiaomi.git
    git config core.sparseCheckout true
    echo "gemini/*" >> .git/info/sparse-checkout
    echo "msm8996-common/*" >> .git/info/sparse-checkout
fi
git pull --depth=1 origin lineage-18.1 || true
cd "$WORKSPACE_DIR"

# 6. Built-in GApps (MindTheGapps rho / Android 11)
echo "[*] Fetching MindTheGapps (Android 11 built-in)..."
if [ ! -d "vendor/gapps" ]; then
    git clone --depth=1 -b rho https://gitlab.com/MindTheGapps/vendor_gapps.git vendor/gapps
fi

echo "[+] Sync and dependencies preparation completed successfully!"
