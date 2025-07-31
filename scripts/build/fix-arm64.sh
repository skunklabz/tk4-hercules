#!/bin/bash

# TK4-Hercules ARM64 Fix Script
# This script helps fix ARM64 compatibility issues

set -e  # Exit on any error

echo "🔧 Fixing TK4-Hercules ARM64 Compatibility Issues"
echo "=================================================="
echo ""

# Check if we're on ARM64
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ] && [ "$ARCH" != "arm64" ]; then
    echo "ℹ️  Not running on ARM64 architecture ($ARCH)"
    echo "  This script is designed for ARM64 systems"
    exit 0
fi

echo "✅ Running on ARM64 architecture ($ARCH)"
echo ""

# Stop any running containers
echo "🛑 Stopping any running containers..."
docker compose down 2>/dev/null || true

# Remove existing images to force rebuild
echo "🗑️  Removing existing images..."
docker rmi ghcr.io/skunklabz/tk4-hercules:latest 2>/dev/null || true
docker rmi tk4-hercules:latest 2>/dev/null || true

# Clean up any dangling images
echo "🧹 Cleaning up Docker system..."
docker system prune -f

# Build multi-platform image locally
echo "🔨 Building multi-platform image locally..."
if make build-multi; then
    echo "✅ Multi-platform build completed"
else
    echo "❌ Multi-platform build failed"
    echo ""
    echo "💡 Alternative: Try building for ARM64 only"
    echo "   docker build --platform linux/arm64 -t tk4-hercules:arm64 ."
    exit 1
fi

# Test the new build
echo ""
echo "🧪 Testing the new build..."
if make test-arm64; then
    echo "✅ ARM64 compatibility test passed"
else
    echo "❌ ARM64 compatibility test failed"
    echo ""
    echo "💡 Additional troubleshooting:"
    echo "  1. Check Docker buildx is available: docker buildx version"
    echo "  2. Ensure QEMU is installed for emulation"
    echo "  3. On macOS, verify Rosetta 2 is installed"
    echo "  4. Try running with explicit platform: docker compose up -d --platform linux/amd64"
    exit 1
fi

echo ""
echo "🎉 ARM64 compatibility issues should now be resolved!"
echo ""
echo "🚀 To start the mainframe:"
echo "   make start"
echo ""
echo "🔍 To check status:"
echo "   make status"
echo ""
echo "📋 To view logs:"
echo "   make logs" 