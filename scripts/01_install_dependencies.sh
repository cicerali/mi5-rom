#!/usr/bin/env bash
set -e

echo "=== [Step 1/4] Installing Ubuntu 22.04 Build Dependencies ==="

sudo apt update && sudo apt install -y \
    bc bison build-essential ccache curl flex g++-multilib gcc-multilib git \
    git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev \
    lib32z1-dev libelf-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev \
    libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools \
    xsltproc zip zlib1g-dev python3 python-is-python3 openjdk-11-jdk libncurses6

# Install Google repo tool if not present
mkdir -p "$HOME/bin"
if [ ! -f "$HOME/bin/repo" ]; then
    echo "Installing repo tool..."
    curl -s https://storage.googleapis.com/git-repo-downloads/repo > "$HOME/bin/repo"
    chmod a+x "$HOME/bin/repo"
fi

# Ensure ~/bin is in PATH
if ! grep -q '$HOME/bin' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH=$HOME/bin:$PATH' >> "$HOME/.bashrc"
fi
export PATH=$HOME/bin:$PATH

# Initialize Git LFS
git lfs install

# Verify Git Config
if [ -z "$(git config --global user.name)" ]; then
    echo "Configuring Git identity..."
    git config --global user.name "PixelGemini Builder"
    git config --global user.email "builder@pixelgemini.local"
fi

echo "[+] Build dependencies installed successfully!"
