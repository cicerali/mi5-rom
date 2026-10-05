#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="${1:-/mnt/mi5workspace/android11}"

echo "=========================================================="
echo " Starting Full Automated Build for PixelGemini OS (Mi 5)"
echo " Workspace: $WORKSPACE_DIR"
echo "=========================================================="

bash "$SCRIPT_DIR/scripts/01_install_dependencies.sh"
bash "$SCRIPT_DIR/scripts/02_init_and_sync.sh" "$WORKSPACE_DIR"
bash "$SCRIPT_DIR/scripts/03_apply_customizations.sh" "$WORKSPACE_DIR"
bash "$SCRIPT_DIR/scripts/04_build_rom.sh" "$WORKSPACE_DIR"

echo "All build stages completed successfully!"
