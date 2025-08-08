#!/bin/bash

# TK4-Hercules Multi-Platform Build Script
# This script builds Docker images for both AMD64 and ARM64 platforms

set -e  # Exit on any error

# Read version from VERSION file
VERSION=$(cat ../../VERSION | tr -d ' ')

# Configuration
IMAGE_NAME="tk4-hercules"
LATEST_TAG="${IMAGE_NAME}:latest"
VERSION_TAG="${IMAGE_NAME}:v${VERSION}"

echo "🐳 Building TK4-Hercules Multi-Platform Docker Images"
echo "====================================================="
echo "Image: ${IMAGE_NAME}"
echo "Version: ${VERSION}"
echo "Platforms: linux/amd64, linux/arm64"
echo ""

# Check if buildx is available
if ! docker buildx version >/dev/null 2>&1; then
    echo "❌ Docker buildx is not available!"
    echo "Please install Docker buildx or update Docker Desktop"
    exit 1
fi

# Create and use a new builder instance
echo "🔧 Setting up buildx builder..."
docker buildx create --name tk4-hercules-multi --use --driver docker-container || true

# Build for multiple platforms
echo "📦 Building multi-platform Docker images..."
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t ${LATEST_TAG} \
    -t ${VERSION_TAG} \
    --load \
    .

if [ $? -eq 0 ]; then
    echo "✅ Multi-platform build completed successfully!"
    echo ""
    echo "📋 Image details:"
    docker images ${IMAGE_NAME} --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    echo ""
    echo "🚀 To run the container:"
    echo "   docker compose up -d"
    echo ""
    echo "🔍 To test the build:"
    echo "   docker run --rm -it ${LATEST_TAG} /bin/bash"
    echo ""
    echo "📤 To push to registry (if you have access):"
    echo "   docker push ${LATEST_TAG}"
    echo "   docker push ${VERSION_TAG}"
    echo ""
    echo "💡 Platform support:"
    echo "   - linux/amd64: Native x86_64 support"
    echo "   - linux/arm64: Native ARM64 support (Apple Silicon, ARM servers)"
    echo ""
    echo "🎯 The image will automatically use the appropriate platform"
    echo "   when pulled on different architectures"
else
    echo "❌ Multi-platform build failed!"
    exit 1
fi 