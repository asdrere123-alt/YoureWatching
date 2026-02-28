#!/bin/bash

# YoureWatching Plugin Installer
# This script installs the plugin and compiles it to .pyc to keep it "closed source"

PLUGIN_PATH="/usr/lib/enigma2/python/Plugins/Extensions/YoureWatching"

echo "======================================="
echo " Installing You're Watching plugin..."
echo "======================================="

# 1. Create directory
mkdir -p $PLUGIN_PATH

# 2. Download files
# (Note: These URLs will needs to be updated with your actual GitHub username/repo)
GITHUB_RAW="https://raw.githubusercontent.com/asdrere123-alt/YoureWatching/main"

wget -qO $PLUGIN_PATH/__init__.py "$GITHUB_RAW/__init__.py"
wget -qO $PLUGIN_PATH/plugin_b64.txt "$GITHUB_RAW/plugin_b64.txt"

# 3. Decode base64 to py
base64 -d $PLUGIN_PATH/plugin_b64.txt > $PLUGIN_PATH/plugin.py

# 4. Compile to pyc
python3 -m py_compile $PLUGIN_PATH/plugin.py
python3 -m py_compile $PLUGIN_PATH/__init__.py

# 5. Cleanup source
rm -f $PLUGIN_PATH/plugin.py
rm -f $PLUGIN_PATH/plugin_b64.txt
rm -f $PLUGIN_PATH/__init__.py

echo "======================================="
echo " Plugin installed successfully!"
echo " Please restart Enigma2."
echo "======================================="

killall -9 enigma2
