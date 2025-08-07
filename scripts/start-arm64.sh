#!/bin/bash

# ARM64 Workaround Script for TKX-Hercules
# This script provides a workaround for symbol relocation errors on ARM64 systems

set -e

echo "🔧 ARM64 Workaround for TKX-Hercules"
echo "====================================="
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

# Remove existing containers
echo "🗑️  Cleaning up existing containers..."
docker rm -f tkx-hercules 2>/dev/null || true

echo ""
echo "🚀 Starting TKX-Hercules with ARM64 workaround..."
echo ""

# Method 1: Try with AMD64 platform
echo "📋 Method 1: Using AMD64 platform with emulation..."
PLATFORM=linux/amd64 docker compose up -d

# Wait a moment for startup
sleep 5

# Check if it's working
if docker compose ps | grep -q "Up"; then
    echo "✅ Container started successfully with AMD64 platform"
    echo ""
    echo "🎯 Connection details:"
    echo "  Terminal: telnet localhost 3270"
    echo "  Web Console: http://localhost:8038"
    echo ""
    echo "📋 Container status:"
    docker compose ps
    echo ""
    echo "📋 Recent logs:"
    docker compose logs --tail=5
    echo ""
    echo "💡 If you still see symbol relocation errors, try Method 2"
    exit 0
else
    echo "❌ Method 1 failed, trying Method 2..."
    docker compose down 2>/dev/null || true
fi

# Method 2: Try with different base image
echo ""
echo "📋 Method 2: Using Ubuntu-based image..."
echo "  Building Ubuntu-based image (this may take a few minutes)..."
docker build -f Dockerfile.ubuntu -t tkx-hercules:ubuntu . >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Ubuntu image built successfully"
    echo ""
    echo "🚀 Starting with Ubuntu-based image..."
    
    # Create a simple docker compose override
    cat > docker-compose.override.yml << EOF
services:
  tkx-hercules:
image: tkx-hercules:ubuntu
    platform: linux/amd64
EOF
    
    docker compose up -d
    
    # Wait a moment for startup
    sleep 5
    
    # Check if it's working
    if docker compose ps | grep -q "Up"; then
        echo "✅ Container started successfully with Ubuntu image"
        echo ""
        echo "🎯 Connection details:"
        echo "  Terminal: telnet localhost 3270"
        echo "  Web Console: http://localhost:8038"
        echo ""
        echo "📋 Container status:"
        docker compose ps
        echo ""
        echo "📋 Recent logs:"
        docker compose logs --tail=5
        exit 0
    else
        echo "❌ Method 2 also failed"
    fi
else
    echo "❌ Failed to build Ubuntu image"
fi

# Method 3: Fallback to simple docker run
echo ""
echo "📋 Method 3: Using simple docker run with AMD64 platform..."
echo ""

docker run -d \
  --platform linux/amd64 \
  --name tkx-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tkx-hercules:latest

if [ $? -eq 0 ]; then
    echo "✅ Container started with docker run"
    echo ""
    echo "🎯 Connection details:"
    echo "  Terminal: telnet localhost 3270"
    echo "  Web Console: http://localhost:8038"
    echo ""
    echo "📋 Container status:"
    docker ps | grep tkx-hercules
    echo ""
    echo "📋 Recent logs:"
    docker logs tkx-hercules --tail=5
else
    echo "❌ All methods failed"
    echo ""
    echo "💡 Troubleshooting suggestions:"
    echo "  1. Check Docker Desktop settings"
    echo "  2. Ensure Rosetta 2 is installed (macOS)"
    echo "  3. Try updating Docker to latest version"
    echo "  4. Check system resources (memory, CPU)"
    echo ""
    echo "📚 For more help, see: docs/ARM64_TROUBLESHOOTING.md"
    exit 1
fi 