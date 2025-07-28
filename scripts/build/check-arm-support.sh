#!/bin/bash

# Check ARM64 Support in TK4- Distribution
# This script downloads and checks if the TK4- distribution includes ARM64 binaries

set -e

echo "🔍 Checking ARM64 support in TK4- distribution..."
echo "================================================"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "📥 Downloading TK4- distribution..."
wget --no-check-certificate -O tk4-_v1.00_current.zip https://wotho.pebble-beach.ch/tk4-/tk4-_v1.00_current.zip

echo "📦 Extracting distribution..."
unzip -q tk4-_v1.00_current.zip

echo "🔍 Exploring distribution structure..."
echo "Root directory contents:"
ls -la

echo ""
echo "🔍 Looking for Hercules binaries..."
find . -name "*hercules*" -type f 2>/dev/null || echo "No Hercules binaries found"

echo ""
echo "🔍 Looking for architecture-specific directories..."
find . -type d -name "*arm*" -o -name "*64*" -o -name "*x86*" 2>/dev/null || echo "No architecture-specific directories found"

echo ""
echo "🔍 Checking for Linux binaries..."
if [ -d "tk4-/hercules/linux" ]; then
    echo "✅ Linux binaries directory found"
    
    # Check for ARM64 binaries
    if [ -d "tk4-/hercules/linux/arm" ]; then
        echo "✅ ARM binaries found:"
        ls -la tk4-/hercules/linux/arm/
        
        # Check if binaries are executable
        if [ -x "tk4-/hercules/linux/arm/hercules" ]; then
            echo "✅ ARM Hercules binary is executable"
        else
            echo "⚠️  ARM Hercules binary is not executable"
        fi
    else
        echo "❌ ARM binaries directory not found"
    fi
    
    # Check for ARM64 softfloat binaries
    if [ -d "tk4-/hercules/linux/arm_softfloat" ]; then
        echo "✅ ARM softfloat binaries found:"
        ls -la tk4-/hercules/linux/arm_softfloat/
    else
        echo "⚠️  ARM softfloat binaries directory not found"
    fi
    
    # List all available architectures
    echo ""
    echo "📋 Available architectures:"
    for arch in tk4-/hercules/linux/*; do
        if [ -d "$arch" ]; then
            echo "  - $(basename "$arch")"
        fi
    done
    
else
    echo "❌ Linux binaries directory not found"
    echo "Looking for alternative Hercules locations..."
    find . -name "hercules" -type f 2>/dev/null || echo "No Hercules binary found"
fi

echo ""
echo "🧹 Cleaning up..."
cd /
rm -rf "$TEMP_DIR"

echo "✅ ARM64 support check completed" 