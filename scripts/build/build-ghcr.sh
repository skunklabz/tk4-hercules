#!/bin/bash

# TK4-Hercules GitHub Container Registry Build Script
# This script builds and pushes the Docker image to GHCR

set -e  # Exit on any error

# Configuration
GHCR_IMAGE_NAME="ghcr.io/skunklabz/tk4-hercules"
VERSION="1.01"
GHCR_LATEST_TAG="${GHCR_IMAGE_NAME}:latest"
GHCR_VERSION_TAG="${GHCR_IMAGE_NAME}:v${VERSION}"

echo "🐳 Building TK4-Hercules for GitHub Container Registry"
echo "======================================================"
echo "GHCR Image: ${GHCR_IMAGE_NAME}"
echo "Version: ${VERSION}"
echo "Base: Ubuntu 22.04 LTS"
echo ""

# Check if we're logged into GHCR
if ! docker info | grep -q "ghcr.io"; then
    echo "⚠️  Not logged into GitHub Container Registry"
    echo "Please run: echo \$GITHUB_TOKEN | docker login ghcr.io -u skunklabz --password-stdin"
    echo "Or set up authentication via GitHub Actions"
fi

# Build the image with platform support
echo "📦 Building Docker image..."
docker build --platform linux/amd64 -t ${GHCR_LATEST_TAG} -t ${GHCR_VERSION_TAG} .

if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
    echo ""
    echo "📋 Image details:"
    docker images ${GHCR_IMAGE_NAME} --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    echo ""
    
    # Ask for confirmation before pushing
    if [ "$1" != "--no-prompt" ]; then
        read -p "🚀 Push to GitHub Container Registry? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "⏭️  Skipping push. Images are ready locally."
            echo ""
            echo "📤 To push manually:"
            echo "   docker push ${GHCR_LATEST_TAG}"
            echo "   docker push ${GHCR_VERSION_TAG}"
            exit 0
        fi
    fi
    
    # Push to GHCR
    echo "📤 Pushing to GitHub Container Registry..."
    docker push ${GHCR_LATEST_TAG}
    docker push ${GHCR_VERSION_TAG}
    
    echo "✅ Push completed successfully!"
    echo ""
    echo "🔗 GHCR URL: https://ghcr.io/skunklabz/tk4-hercules"
    echo "📖 Usage:"
    echo "   docker pull ${GHCR_LATEST_TAG}"
    echo "   docker run -p 3270:3270 -p 8038:8038 ${GHCR_LATEST_TAG}"
    echo ""
    echo "📋 Available tags:"
    echo "   ${GHCR_LATEST_TAG} (latest)"
    echo "   ${GHCR_VERSION_TAG} (versioned)"
else
    echo "❌ Build failed!"
    exit 1
fi 