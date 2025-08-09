#!/bin/bash

# TK4-Hercules Platform-Aware Build Script
# This script detects the platform and builds the Docker image accordingly

set -e  # Exit on any error

# Determine repo root and read version from VERSION file
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VERSION=$(cat "$REPO_ROOT/VERSION" | tr -d ' ')

# Configuration
IMAGE_NAME="skunklabz/tk4-hercules"
LATEST_TAG="${IMAGE_NAME}:latest"
VERSION_TAG="${IMAGE_NAME}:v${VERSION}"

echo "🐳 Building TK4-Hercules Docker Image (Platform-Aware)"
echo "======================================================"
echo "Image: ${IMAGE_NAME}"
echo "Version: ${VERSION}"
echo "Base: Alpine Linux 3.19"
echo ""

# Detect platform
PLATFORM=$(uname -m)
echo "🔍 Detected platform: ${PLATFORM}"

# Force AMD64 builds only
echo "🖥️  Forcing AMD64 build platform (project policy)"
BUILD_PLATFORM="linux/amd64"
PLATFORM_SUFFIX=""

# Build the image with appropriate platform
echo "📦 Building Docker image for ${BUILD_PLATFORM}..."
docker build --platform ${BUILD_PLATFORM} -t ${LATEST_TAG} -t ${VERSION_TAG} .

if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
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
    echo "💡 Platform-specific notes:"
    if [[ "$PLATFORM" == "arm64" || "$PLATFORM" == "aarch64" ]]; then
        echo "   - Built for x86_64 compatibility on Apple Silicon"
        echo "   - May run slower due to emulation"
        echo "   - Consider using pre-built images for better performance"
    else
        echo "   - Built for native x86_64 platform"
        echo "   - Optimal performance expected"
    fi
else
    echo "❌ Build failed!"
    exit 1
fi 