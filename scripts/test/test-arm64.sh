#!/bin/bash

# Test ARM64 Support for TK4-Hercules
# This script tests if the container can run on ARM64 architecture

set -e

echo "🧪 Testing ARM64 support for TK4-Hercules"
echo "========================================="

# Check if we're on ARM64
PLATFORM=$(uname -m)
echo "🔍 Current platform: ${PLATFORM}"

if [[ "$PLATFORM" != "arm64" && "$PLATFORM" != "aarch64" ]]; then
    echo "⚠️  This test is designed for ARM64 platforms"
    echo "   Current platform: ${PLATFORM}"
    echo "   You can still run this test, but it may not be representative"
fi

# Build the image for ARM64
echo "📦 Building ARM64 image..."
docker build --platform linux/arm64 -t tk4-hercules:test-arm64 .

if [ $? -eq 0 ]; then
    echo "✅ ARM64 build successful!"
    
    # Test running the container
    echo "🚀 Testing container startup..."
    CONTAINER_ID=$(docker run --rm -d --name tk4-hercules-test-arm64 \
        -p 3271:3270 \
        -p 8039:8038 \
        tk4-hercules:test-arm64)
    
    if [ $? -eq 0 ]; then
        echo "✅ Container started successfully!"
        echo "📋 Container ID: ${CONTAINER_ID}"
        
        # Wait a moment for startup
        sleep 5
        
        # Check if container is running
        if docker ps | grep -q tk4-hercules-test-arm64; then
            echo "✅ Container is running!"
            
            # Check container logs
            echo "📋 Container logs:"
            docker logs tk4-hercules-test-arm64 | head -10
            
            # Check if Hercules binary is working
            echo "🔍 Testing Hercules binary..."
            docker exec tk4-hercules-test-arm64 /tk4-/hercules --version 2>/dev/null || echo "Hercules version check failed"
            
            # Test port connectivity
            echo "🔌 Testing port connectivity..."
            if nc -z localhost 3271 2>/dev/null; then
                echo "✅ Port 3271 (3270) is accessible"
            else
                echo "⚠️  Port 3271 (3270) is not accessible"
            fi
            
            if nc -z localhost 8039 2>/dev/null; then
                echo "✅ Port 8039 (8038) is accessible"
            else
                echo "⚠️  Port 8039 (8038) is not accessible"
            fi
            
        else
            echo "❌ Container is not running"
            echo "📋 Checking container logs for errors:"
            docker logs tk4-hercules-test-arm64 2>/dev/null || echo "No logs available"
        fi
        
        # Clean up
        echo "🧹 Cleaning up test container..."
        docker stop tk4-hercules-test-arm64 2>/dev/null || true
        docker rm tk4-hercules-test-arm64 2>/dev/null || true
        
    else
        echo "❌ Failed to start container"
    fi
    
    # Clean up test image
    echo "🧹 Cleaning up test image..."
    docker rmi tk4-hercules:test-arm64 2>/dev/null || true
    
else
    echo "❌ ARM64 build failed!"
    exit 1
fi

echo ""
echo "🎉 ARM64 test completed!" 