#!/bin/bash

# TKX-Hercules Docker Build Script
# This script builds the Docker image with proper tagging and testing
# Now uses SDL-Hercules-390 submodule instead of building Hercules from source

set -e  # Exit on any error

# Read version from VERSION file
VERSION=$(cat ../VERSION | tr -d ' ')

# Configuration
IMAGE_NAME="skunklabz/tkx-hercules"
GHCR_IMAGE_NAME="ghcr.io/skunklabz/tkx-hercules"
LATEST_TAG="${IMAGE_NAME}:latest"
VERSION_TAG="${IMAGE_NAME}:v${VERSION}"
GHCR_LATEST_TAG="${GHCR_IMAGE_NAME}:latest"
GHCR_VERSION_TAG="${GHCR_IMAGE_NAME}:v${VERSION}"

# Check if we're in a GitHub Actions environment
if [ -n "$GITHUB_ACTIONS" ]; then
    echo "🔧 Running in GitHub Actions environment"
    USE_GHCR=true
else
    echo "🔧 Running in local environment"
    USE_GHCR=false
fi

echo "🐳 Building TKX-Hercules Docker Image"
echo "======================================"
echo "Image: ${IMAGE_NAME}"
echo "GHCR Image: ${GHCR_IMAGE_NAME}"
echo "Version: ${VERSION}"
echo "Architecture: AMD64"
echo ""

# Check if submodules are initialized
echo "🔍 Checking submodules..."
if [ ! -d "external/sdl-hercules-390" ]; then
    echo "❌ SDL-Hercules-390 submodule not found. Initializing submodules..."
    git submodule update --init --recursive
fi

# Build the image with platform support
echo "📦 Building Docker image..."
docker build --platform linux/amd64 -t ${LATEST_TAG} -t ${VERSION_TAG} .

if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
    
    # Tag for GHCR if needed
    if [ "$USE_GHCR" = true ] || [ "$1" = "--ghcr" ]; then
        echo "🏷️  Tagging for GitHub Container Registry..."
        docker tag ${LATEST_TAG} ${GHCR_LATEST_TAG}
        docker tag ${VERSION_TAG} ${GHCR_VERSION_TAG}
        echo "✅ GHCR tagging completed!"
    fi
    
    echo ""
    echo "📋 Image details:"
    docker images ${IMAGE_NAME} --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    if [ "$USE_GHCR" = true ] || [ "$1" = "--ghcr" ]; then
        docker images ${GHCR_IMAGE_NAME} --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    fi
    echo ""
    echo "🚀 To run the container:"
    echo "   docker compose up -d"
    echo ""
    echo "🔍 To test the build:"
    echo "   docker run --rm -it ${LATEST_TAG} /bin/bash"
    echo ""
    if [ "$USE_GHCR" = true ] || [ "$1" = "--ghcr" ]; then
        echo "📤 To push to GitHub Container Registry:"
        echo "   docker push ${GHCR_LATEST_TAG}"
        echo "   docker push ${GHCR_VERSION_TAG}"
        echo ""
        echo "🔗 GHCR URL: https://ghcr.io/skunklabz/tkx-hercules"
    else
        echo "📤 To push to GitHub Container Registry:"
        echo "   ./scripts/build/build.sh --ghcr"
        echo "   docker push ${GHCR_LATEST_TAG}"
        echo "   docker push ${GHCR_VERSION_TAG}"
    fi
else
    echo "❌ Build failed!"
    exit 1
fi 