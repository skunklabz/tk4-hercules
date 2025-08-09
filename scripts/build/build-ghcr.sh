#!/bin/bash

# TK4-Hercules GitHub Container Registry Build Script
# This script builds and pushes the Docker image to GHCR

set -e  # Exit on any error

# Determine repo root and read version from VERSION file
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VERSION=$(cat "$REPO_ROOT/VERSION" | tr -d ' ')

# Configuration
GHCR_IMAGE_NAME="ghcr.io/skunklabz/tk4-hercules"
GHCR_LATEST_TAG="${GHCR_IMAGE_NAME}:latest"
GHCR_VERSION_TAG="${GHCR_IMAGE_NAME}:v${VERSION}"

echo "🐳 Building TK4-Hercules for GitHub Container Registry"
echo "======================================================"
echo "GHCR Image: ${GHCR_IMAGE_NAME}"
echo "Version: ${VERSION}"
echo "Base: Ubuntu 22.04"
echo ""

# Check if we're logged into GHCR
if ! docker info | grep -q "ghcr.io"; then
    echo "⚠️  Not logged into GitHub Container Registry"
    echo "Please run: echo \$GITHUB_TOKEN | docker login ghcr.io -u skunklabz --password-stdin"
    echo "Or set up authentication via GitHub Actions"
fi

# Ensure buildx builder exists
docker buildx create --use --name tk4-hercules-builder || true

# Ask for confirmation before building and pushing
if [ "$1" != "--no-prompt" ]; then
    read -p "🚀 Build and push to GitHub Container Registry? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "⏭️  Skipping build and push."
        echo ""
        echo "📤 To build and push manually:"
        echo "   docker buildx build --platform linux/amd64,linux/arm64 -t ${GHCR_LATEST_TAG} -t ${GHCR_VERSION_TAG} --push ."
        exit 0
    fi
fi

# Build and push to GHCR (multi-arch)
echo "📤 Building and pushing to GitHub Container Registry (multi-arch)..."
docker buildx build --platform linux/amd64,linux/arm64 -t ${GHCR_LATEST_TAG} -t ${GHCR_VERSION_TAG} --push .

if [ $? -eq 0 ]; then
    echo "✅ Build and push completed successfully!"
    echo ""
    echo "📋 Images pushed:"
    echo "   ${GHCR_LATEST_TAG} (linux/amd64, linux/arm64)"
    echo "   ${GHCR_VERSION_TAG} (linux/amd64, linux/arm64)"
    
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