#!/usr/bin/env bash
set -e

WORKSPACE_DIR="${1:-/mnt/mi5workspace/android11}"
CCACHE_DIR_PATH="${2:-/mnt/mi5workspace/.ccache}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== [Step 4/4] Building PixelGemini OS for Xiaomi Mi 5 (gemini) ==="
echo "Target Workspace: $WORKSPACE_DIR"
echo "Ccache Directory: $CCACHE_DIR_PATH"

cd "$WORKSPACE_DIR"
export PATH=$HOME/bin:$PATH

# Setup Ccache
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR="$CCACHE_DIR_PATH"
mkdir -p "$CCACHE_DIR_PATH"
ccache -M 50G

# Source environment and prepare product
source build/envsetup.sh
breakfast gemini

echo "=========================================================="
echo " Starting Compilation (brunch gemini)..."
echo "=========================================================="
brunch gemini

# Copy output files to release directory
OUTPUT_DIR="$WORKSPACE_DIR/out/target/product/gemini"
RELEASE_DIR="$REPO_ROOT/release"
mkdir -p "$RELEASE_DIR"

echo "Copying release artifacts to $RELEASE_DIR..."
cp "$OUTPUT_DIR"/lineage-PixelGemini-*.zip "$RELEASE_DIR/" 2>/dev/null || cp "$OUTPUT_DIR"/lineage_gemini-ota-*.zip "$RELEASE_DIR/"
cp "$OUTPUT_DIR/boot.img" "$RELEASE_DIR/" 2>/dev/null || true
cp "$OUTPUT_DIR/recovery.img" "$RELEASE_DIR/" 2>/dev/null || true

echo "=========================================================="
echo " BUILD SUCCESSFUL!"
echo " Output files are ready in: $RELEASE_DIR"
ls -lh "$RELEASE_DIR"
echo "=========================================================="
