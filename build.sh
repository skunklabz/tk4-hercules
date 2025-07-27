#!/bin/bash

# TK4-Hercules Docker Build Script
# This script builds the Docker image with proper tagging and testing

set -e  # Exit on any error

# Configuration
IMAGE_NAME="skunklabz/tk4-hercules"
VERSION="1.01"
LATEST_TAG="${IMAGE_NAME}:latest"
VERSION_TAG="${IMAGE_NAME}:v${VERSION}"

echo "🐳 Building TK4-Hercules Docker Image"
echo "======================================"
echo "Image: ${IMAGE_NAME}"
echo "Version: ${VERSION}"
echo "Base: Ubuntu 22.04 LTS"
echo ""

# Build the image with platform support
echo "📦 Building Docker image..."
docker build --platform linux/amd64 -t ${LATEST_TAG} -t ${VERSION_TAG} .

if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
    echo ""
    echo "📋 Image details:"
    docker images ${IMAGE_NAME} --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    echo ""
    echo "🚀 To run the container:"
    echo "   docker-compose up -d"
    echo ""
    echo "🔍 To test the build:"
    echo "   docker run --rm -it ${LATEST_TAG} /bin/bash"
    echo ""
    echo "📤 To push to registry (if you have access):"
    echo "   docker push ${LATEST_TAG}"
    echo "   docker push ${VERSION_TAG}"
else
    echo "❌ Build failed!"
    exit 1
fi 