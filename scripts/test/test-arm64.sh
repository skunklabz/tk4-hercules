#!/bin/bash

# TKX-Hercules ARM64 Test Script
# This script tests ARM64 compatibility and provides troubleshooting information

set -e  # Exit on any error

echo "🧪 Testing TKX-Hercules ARM64 Support"
echo "====================================="
echo ""

# Check system architecture
ARCH=$(uname -m)
echo "📋 System Information:"
echo "  Architecture: $ARCH"
echo "  OS: $(uname -s)"
echo "  Kernel: $(uname -r)"
echo ""

# Check Docker availability
if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
fi

echo "🐳 Docker Information:"
echo "  Version: $(docker --version)"
echo "  Buildx: $(docker buildx version 2>/dev/null || echo 'Not available')"
echo ""

# Check for ARM64 platform
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    echo "✅ Running on ARM64 architecture"
    echo ""
    
    # Check if we're on macOS with Apple Silicon
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🍎 Detected macOS on Apple Silicon"
        echo "  Rosetta 2 should handle x86_64 emulation automatically"
        echo ""
    fi
    
    # Check QEMU availability
    echo "🔍 Checking QEMU emulation support..."
    if docker run --rm --platform linux/amd64 alpine:latest uname -m 2>/dev/null | grep -q "x86_64"; then
        echo "✅ QEMU emulation is working correctly"
    else
        echo "⚠️  QEMU emulation may have issues"
    fi
    echo ""
    
    # Test multi-platform image pull
    echo "📦 Testing multi-platform image pull..."
    if docker pull --platform linux/arm64 ghcr.io/skunklabz/tkx-hercules:latest 2>/dev/null; then
        echo "✅ ARM64 image available"
    else
        echo "⚠️  ARM64 image not available, will use AMD64 with emulation"
    fi
    
    if docker pull --platform linux/amd64 ghcr.io/skunklabz/tkx-hercules:latest 2>/dev/null; then
        echo "✅ AMD64 image available for emulation"
    else
        echo "❌ No compatible images found"
        exit 1
    fi
    echo ""
    
else
    echo "ℹ️  Running on $ARCH architecture (not ARM64)"
    echo "  This test is primarily for ARM64 systems"
    echo ""
fi

# Test container startup
echo "🚀 Testing container startup..."
echo "  This will attempt to start the TKX-Hercules container"
echo "  and check for common ARM64 compatibility issues"
echo ""

# Stop any existing containers
docker compose down 2>/dev/null || true

# Start the container
echo "Starting container..."
if docker compose up -d; then
    echo "✅ Container started successfully"
    
    # Wait a moment for startup
    sleep 5
    
    # Check container status
    echo ""
    echo "📊 Container Status:"
    docker compose ps
    
    # Check logs for errors
    echo ""
    echo "📋 Recent Logs:"
    docker compose logs --tail=20
    
    # Check for specific ARM64 errors
    echo ""
    echo "🔍 Checking for ARM64-specific issues..."
    if docker compose logs 2>&1 | grep -q "symbol not found"; then
        echo "❌ Found symbol relocation errors (ARM64 compatibility issue)"
        echo ""
        echo "💡 Troubleshooting steps:"
        echo "  1. Ensure you have the latest multi-platform image"
        echo "  2. Try rebuilding the image locally: make build-multi"
        echo "  3. Check if QEMU is properly configured"
        echo "  4. On macOS, ensure Rosetta 2 is installed"
        echo ""
    else
        echo "✅ No obvious ARM64 compatibility issues found"
    fi
    
    # Test connectivity
    echo ""
    echo "🌐 Testing connectivity..."
    if nc -z localhost 3270 2>/dev/null; then
        echo "✅ Port 3270 is accessible"
    else
        echo "⚠️  Port 3270 is not accessible"
    fi
    
    if nc -z localhost 8038 2>/dev/null; then
        echo "✅ Port 8038 is accessible"
    else
        echo "⚠️  Port 8038 is not accessible"
    fi
    
    # Stop the container
    echo ""
    echo "🛑 Stopping test container..."
    docker compose down
    
else
    echo "❌ Container failed to start"
    echo ""
    echo "📋 Error logs:"
    docker compose logs
    echo ""
    echo "💡 Troubleshooting:"
    echo "  1. Check Docker daemon is running"
    echo "  2. Ensure you have sufficient resources"
    echo "  3. Try building the image locally: make build"
    echo "  4. Check for ARM64 compatibility issues"
    exit 1
fi

echo ""
echo "✅ ARM64 test completed"
echo ""
echo "🎯 Next steps:"
echo "  - If tests passed: Connect to mainframe at localhost:3270"
echo "  - If issues found: Check the troubleshooting guide in docs/ARM64_SUPPORT.md"
echo "  - For more help: Run 'make test' for comprehensive testing" 