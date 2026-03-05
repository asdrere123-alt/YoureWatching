#!/bin/sh
# =============================================
# 🎬 You're Watching Plugin - Auto Installer
# By Ahmed Ibrahim (@asdrere123-alt)
# Compatible with ALL Python versions (OpenATV 6.x to 7.x)
# =============================================

PLUGIN_DIR="/usr/lib/enigma2/python/Plugins/Extensions/YoureWatching"
GITHUB_RAW="https://raw.githubusercontent.com/asdrere123-alt/YoureWatching/main"

echo ""
echo "======================================"
echo "🎬 You're Watching Plugin Installer"
echo "By Ahmed Ibrahim"
echo "======================================"
echo ""

# 1. Clean old version and create fresh plugin folder
echo "🗑️  Removing old version (if any)..."
rm -rf "$PLUGIN_DIR"
mkdir -p "$PLUGIN_DIR"

# 2. Download the plugin files and images
echo "📥 Downloading plugin..."
WGET_OPTS="--no-check-certificate"
# Download core files
wget -q $WGET_OPTS "$GITHUB_RAW/plugin.pyc?t=$(date +%s)" -O "$PLUGIN_DIR/plugin.pyc"
wget -q $WGET_OPTS "$GITHUB_RAW/__init__.py?t=$(date +%s)" -O "$PLUGIN_DIR/__init__.py"
wget -q $WGET_OPTS "$GITHUB_RAW/plugin.png?t=$(date +%s)" -O "$PLUGIN_DIR/plugin.png"

# Download images folder
mkdir -p "$PLUGIN_DIR/images"
wget -q $WGET_OPTS "$GITHUB_RAW/images/audio.png?t=$(date +%s)" -O "$PLUGIN_DIR/images/audio.png"
wget -q $WGET_OPTS "$GITHUB_RAW/images/subtitle.png?t=$(date +%s)" -O "$PLUGIN_DIR/images/subtitle.png"

if [ $? -ne 0 ]; then
    echo "❌ Download failed! (SSL error or No Internet)"
    exit 1
fi

echo "✅ Plugin and images installed successfully!"

# 6. Restart Enigma2
echo ""
echo "🔄 Restarting Enigma2..."
if [ -f /etc/init.d/enigma2 ]; then
    ( sleep 2; /etc/init.d/enigma2 restart ) &
else
    ( sleep 2; killall -9 enigma2 ) &
fi
exit 0
