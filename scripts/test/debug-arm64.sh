#!/bin/bash

# Debug ARM64 Support for TK4-Hercules
# This script helps debug ARM64 issues

set -e

echo "🐛 Debugging ARM64 support for TK4-Hercules"
echo "==========================================="

# Build the image
echo "📦 Building ARM64 image..."
docker build --platform linux/arm64 -t tk4-hercules:debug-arm64 .

if [ $? -eq 0 ]; then
    echo "✅ ARM64 build successful!"
    
    # Test the container interactively
    echo "🔍 Testing container interactively..."
    echo "Running container with interactive shell..."
    echo "You can inspect the container manually."
    echo "Type 'exit' to continue with automated tests."
    echo ""
    
    docker run --rm -it --name tk4-hercules-debug-arm64 \
        -p 3271:3270 \
        -p 8039:8038 \
        tk4-hercules:debug-arm64 /bin/bash
    
    echo ""
    echo "🔍 Running automated tests..."
    
    # Test container startup with different commands
    echo "📋 Testing container with different startup commands..."
    
    # Test 1: Just bash
    echo "Test 1: Running with bash..."
    docker run --rm --name tk4-hercules-test1 \
        tk4-hercules:debug-arm64 /bin/bash -c "echo 'Bash works'; ls -la /tk4-/"
    
    # Test 2: Check Hercules binary
    echo "Test 2: Checking Hercules binary..."
    docker run --rm --name tk4-hercules-test2 \
        tk4-hercules:debug-arm64 /bin/bash -c "ls -la /tk4-/hercules; file /tk4-/hercules"
    
    # Test 3: Check Hercules version
    echo "Test 3: Checking Hercules version..."
    docker run --rm --name tk4-hercules-test3 \
        tk4-hercules:debug-arm64 /bin/bash -c "/tk4-/hercules --version || echo 'Version check failed'"
    
    # Test 4: Check startup script
    echo "Test 4: Checking startup script..."
    docker run --rm --name tk4-hercules-test4 \
        tk4-hercules:debug-arm64 /bin/bash -c "cat /tk4-/mvs; echo '---'; ls -la /tk4-/mvs"
    
    # Test 5: Try running startup script
    echo "Test 5: Trying startup script..."
    docker run --rm --name tk4-hercules-test5 \
        tk4-hercules:debug-arm64 /bin/bash -c "cd /tk4- && ./mvs" || echo "Startup script failed as expected"
    
    # Clean up
    echo "🧹 Cleaning up debug image..."
    docker rmi tk4-hercules:debug-arm64 2>/dev/null || true
    
else
    echo "❌ ARM64 build failed!"
    exit 1
fi

echo ""
echo "🎉 ARM64 debug completed!" 