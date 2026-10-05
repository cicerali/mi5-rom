#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="/mnt/mi5workspace/android11"
CLEAN_BUILD="${CLEAN_BUILD:-0}"

# Parse command line options
for arg in "$@"; do
    case "$arg" in
        --clean|-c)
            CLEAN_BUILD="1"
            ;;
        --full-clean)
            CLEAN_BUILD="full"
            ;;
        --help|-h)
            echo "Usage: $0 [options] [workspace_dir]"
            echo ""
            echo "Options:"
            echo "  --clean, -c     Perform 'mka installclean' before building (recommended for major changes)"
            echo "  --full-clean    Perform full 'mka clean' (deletes entire out/ folder)"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Default is incremental build (fast, does not clean previous outputs)."
            exit 0
            ;;
        -*)
            echo "Unknown option: $arg (use --help for options)"
            exit 1
            ;;
        *)
            WORKSPACE_DIR="$arg"
            ;;
    esac
done

export CLEAN_BUILD

echo "=========================================================="
echo " Starting Full Automated Build for PixelGemini OS (Mi 5)"
echo " Workspace:  $WORKSPACE_DIR"
if [ "$CLEAN_BUILD" = "full" ]; then
    echo " Build Mode: Full Clean (mka clean)"
elif [ "$CLEAN_BUILD" = "1" ]; then
    echo " Build Mode: Install Clean (mka installclean)"
else
    echo " Build Mode: Incremental (normal / fast build)"
fi
echo "=========================================================="

bash "$SCRIPT_DIR/scripts/01_install_dependencies.sh"
bash "$SCRIPT_DIR/scripts/02_init_and_sync.sh" "$WORKSPACE_DIR"
bash "$SCRIPT_DIR/scripts/03_apply_customizations.sh" "$WORKSPACE_DIR"
bash "$SCRIPT_DIR/scripts/04_build_rom.sh" "$WORKSPACE_DIR"

echo "All build stages completed successfully!"
