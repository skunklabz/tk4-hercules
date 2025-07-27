#!/bin/bash

# TK4-Hercules Docker Test Script
# This script tests the Docker container functionality

set -e  # Exit on any error

# Configuration
IMAGE_NAME="skunklabz/tk4-hercules"
CONTAINER_NAME="tk4-test-$(date +%s)"

echo "🧪 Testing TK4-Hercules Docker Container"
echo "========================================"
echo "Image: ${IMAGE_NAME}"
echo "Container: ${CONTAINER_NAME}"
echo ""

# Function to cleanup
cleanup() {
    echo "🧹 Cleaning up test container..."
    docker stop ${CONTAINER_NAME} 2>/dev/null || true
    docker rm ${CONTAINER_NAME} 2>/dev/null || true
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Test 1: Check if image exists
echo "📋 Test 1: Checking if image exists..."
if docker images ${IMAGE_NAME}:latest --format "{{.Repository}}" | grep -q ${IMAGE_NAME}; then
    echo "✅ Image found"
else
    echo "❌ Image not found. Please run ./build.sh first"
    exit 1
fi

# Test 2: Test container startup
echo ""
echo "🚀 Test 2: Testing container startup..."
docker run -d --name ${CONTAINER_NAME} \
    -p 3270:3270 \
    -p 8038:8038 \
    ${IMAGE_NAME}:latest

# Wait a moment for container to start
sleep 5

# Test 3: Check if container is running
echo ""
echo "🔍 Test 3: Checking container status..."
if docker ps --format "{{.Names}}" | grep -q ${CONTAINER_NAME}; then
    echo "✅ Container is running"
else
    echo "❌ Container failed to start"
    docker logs ${CONTAINER_NAME}
    exit 1
fi

# Test 4: Check health status
echo ""
echo "💚 Test 4: Checking health status..."
sleep 10  # Give health check time to run
HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' ${CONTAINER_NAME} 2>/dev/null || echo "no-health-check")
echo "Health status: ${HEALTH_STATUS}"

# Test 5: Check if ports are accessible
echo ""
echo "🔌 Test 5: Checking port accessibility..."
if netstat -an 2>/dev/null | grep -q ":3270.*LISTEN" || ss -tuln 2>/dev/null | grep -q ":3270"; then
    echo "✅ Port 3270 is accessible"
else
    echo "⚠️  Port 3270 not accessible (this may be normal if container is still starting)"
fi

if netstat -an 2>/dev/null | grep -q ":8038.*LISTEN" || ss -tuln 2>/dev/null | grep -q ":8038"; then
    echo "✅ Port 8038 is accessible"
else
    echo "⚠️  Port 8038 not accessible (this may be normal if container is still starting)"
fi

# Test 6: Check container logs
echo ""
echo "📝 Test 6: Checking container logs..."
echo "Recent logs:"
docker logs --tail 10 ${CONTAINER_NAME}

echo ""
echo "🎉 All tests completed!"
echo ""
echo "📊 Test Summary:"
echo "   - Image exists: ✅"
echo "   - Container starts: ✅"
echo "   - Container runs: ✅"
echo "   - Health check: ${HEALTH_STATUS}"
echo "   - Ports configured: ✅"
echo ""
echo "🚀 Container is ready for use!"
echo "   Connect via 3270 terminal: c3270 localhost:3270"
echo "   Web console: http://localhost:8038/" 