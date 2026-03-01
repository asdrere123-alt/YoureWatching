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

# 1. Create plugin folder
mkdir -p "$PLUGIN_DIR"

# 2. Download the protected plugin base64 code and icon
echo "📥 Downloading plugin..."
wget -q "$GITHUB_RAW/plugin_b64.txt" -O "$PLUGIN_DIR/plugin_b64.txt"
wget -q "$GITHUB_RAW/__init__.py" -O "$PLUGIN_DIR/__init__.py"
wget -q "$GITHUB_RAW/plugin.png" -O "$PLUGIN_DIR/plugin.png"

if [ $? -ne 0 ]; then
    echo "❌ Download failed! Check your internet connection or GitHub repo."
    exit 1
fi

# 3. Decode the plugin code locally
echo "⚙️  Decoding & Compiling..."
base64 -d "$PLUGIN_DIR/plugin_b64.txt" > "$PLUGIN_DIR/plugin.py" 2>/dev/null

# If base64 fails (missing on some old boxes), try using python built-in library
if [ ! -f "$PLUGIN_DIR/plugin.py" ] || [ ! -s "$PLUGIN_DIR/plugin.py" ]; then
    python -c "import base64; open('$PLUGIN_DIR/plugin.py', 'wb').write(base64.b64decode(open('$PLUGIN_DIR/plugin_b64.txt').read()))"
fi

# 4. Compile it natively on the receiver to match its Python version (works for Py2 & Py3!)
python -m py_compile "$PLUGIN_DIR/plugin.py" "$PLUGIN_DIR/__init__.py" 2>/dev/null
python -O -m py_compile "$PLUGIN_DIR/plugin.py" "$PLUGIN_DIR/__init__.py" 2>/dev/null

# 5. Lock it down (delete the readable script files)
rm -f "$PLUGIN_DIR/plugin.py"
rm -f "$PLUGIN_DIR/plugin_b64.txt"

echo "✅ Plugin installed successfully (Closed Source)!"

# 6. Restart Enigma2
echo ""
echo "🔄 Restarting Enigma2 in background..."
( sleep 3; killall -9 enigma2 ) &
exit 0
