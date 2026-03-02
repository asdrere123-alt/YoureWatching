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

# 2. Download the protected plugin base64 code and icon
echo "📥 Downloading plugin..."
WGET_OPTS="--no-check-certificate"
wget -q $WGET_OPTS "$GITHUB_RAW/plugin_b64.txt?t=$(date +%s)" -O "$PLUGIN_DIR/plugin_b64.txt"
wget -q $WGET_OPTS "$GITHUB_RAW/__init__.py?t=$(date +%s)" -O "$PLUGIN_DIR/__init__.py"
wget -q $WGET_OPTS "$GITHUB_RAW/plugin.png?t=$(date +%s)" -O "$PLUGIN_DIR/plugin.png"

if [ $? -ne 0 ]; then
    echo "❌ Download failed! (SSL error or No Internet)"
    exit 1
fi

# Determine Python command
PYTHON_CMD="python"
if ! command -v python >/dev/null 2>&1; then
    PYTHON_CMD="python3"
fi

# 3. Decode the plugin code locally
echo "⚙️  Decoding & Compiling..."
if command -v base64 >/dev/null 2>&1; then
    base64 -d "$PLUGIN_DIR/plugin_b64.txt" > "$PLUGIN_DIR/plugin.py" 2>/dev/null
fi

# If base64 fails or is missing, use python fallback
if [ ! -f "$PLUGIN_DIR/plugin.py" ] || [ ! -s "$PLUGIN_DIR/plugin.py" ]; then
    $PYTHON_CMD -c "import base64; open('$PLUGIN_DIR/plugin.py', 'wb').write(base64.b64decode(open('$PLUGIN_DIR/plugin_b64.txt').read()))"
fi

# 4. Compile it natively on the receiver
$PYTHON_CMD -m py_compile "$PLUGIN_DIR/plugin.py" "$PLUGIN_DIR/__init__.py" >/dev/null 2>&1
$PYTHON_CMD -O -m py_compile "$PLUGIN_DIR/plugin.py" "$PLUGIN_DIR/__init__.py" >/dev/null 2>&1

# 5. Lock it down
if [ -f "$PLUGIN_DIR/plugin.pyc" ] || [ -f "$PLUGIN_DIR/__pycache__/plugin.cpython-312.pyc" ] || [ -f "$PLUGIN_DIR/__pycache__/plugin.cpython-311.pyc" ] || [ -f "$PLUGIN_DIR/__pycache__/plugin.cpython-310.pyc" ] || [ -d "$PLUGIN_DIR/__pycache__" ]; then
    rm -f "$PLUGIN_DIR/plugin.py"
    rm -f "$PLUGIN_DIR/plugin_b64.txt"
    echo "✅ Plugin installed and compiled successfully!"
else
    # If compilation failed, keep the .py so the plugin at least tries to run (OpenPLi fallback)
    echo "⚠️  Compilation warning, but installation continued."
    rm -f "$PLUGIN_DIR/plugin_b64.txt"
fi

# 6. Restart Enigma2
echo ""
echo "🔄 Restarting Enigma2..."
if [ -f /etc/init.d/enigma2 ]; then
    ( sleep 2; /etc/init.d/enigma2 restart ) &
else
    ( sleep 2; killall -9 enigma2 ) &
fi
exit 0
