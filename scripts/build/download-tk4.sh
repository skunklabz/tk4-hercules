#!/bin/bash

# TK4- Download Helper Script
# This script helps users obtain the TK4- distribution from alternative sources

set -e

TK4_FILE="tk4-_v1.00_current.zip"
ARCHIVE_URL="https://web.archive.org/web/20200000000000*/http://wotho.ethz.ch/tk4-/tk4-_v1.00_current.zip"

echo "🔍 TK4- Distribution Download Helper"
echo "===================================="
echo ""
echo "The original TK4- distribution is no longer available from the primary sources."
echo "This script will help you find alternative sources."
echo ""

# Check if file already exists
if [ -f "$TK4_FILE" ]; then
    echo "✅ Found existing $TK4_FILE"
    echo "   Size: $(ls -lh $TK4_FILE | awk '{print $5}')"
    echo "   You can now run: ./build.sh"
    exit 0
fi

echo "📋 Available options to obtain TK4- distribution:"
echo ""
echo "1. 🌐 Official Source (Recommended)"
echo "   Direct download: https://wotho.pebble-beach.ch/tk4-/tk4-_v1.00_current.zip"
echo "   Size: ~238MB"
echo ""
echo "2. 🔗 Archive.org (Backup)"
echo "   Visit: https://web.archive.org/web/*/http://wotho.ethz.ch/tk4-/"
echo "   Search for: tk4-_v1.00_current.zip"
echo ""
echo "3. 📚 Software Archives"
echo "   - https://www.ibiblio.org/jmaynard/ (may have mirrors)"
echo "   - https://archive.org/details/software"
echo ""
echo "4. 🐛 Community Sources"
echo "   - Hercules mailing lists"
echo "   - Mainframe enthusiast forums"
echo "   - GitHub repositories with TK4- distributions"
echo ""

echo "📥 Once you have downloaded $TK4_FILE:"
echo "   1. Place it in the project root directory"
echo "   2. Run: ./build.sh"
echo "   3. Run: ./test.sh"
echo ""

echo "🚀 Alternative: Use pre-built image"
echo "   docker pull skunklabz/tk4-hercules:latest"
echo "   docker-compose up -d"
echo ""

# Try to open archive.org in browser (macOS/Linux)
if command -v open >/dev/null 2>&1; then
    echo "🌐 Opening archive.org in your browser..."
    open "https://web.archive.org/web/*/http://wotho.ethz.ch/tk4-/"
elif command -v xdg-open >/dev/null 2>&1; then
    echo "🌐 Opening archive.org in your browser..."
    xdg-open "https://web.archive.org/web/*/http://wotho.ethz.ch/tk4-/"
fi

echo ""
echo "💡 Tip: The TK4- distribution is approximately 50-100MB in size."
echo "   Look for files named 'tk4-_v1.00_current.zip' or similar." 