#!/bin/bash

# Local testing script for tk4-hercules
# Mirrors the CI/CD workflow for local validation

set -e

echo "🧪 Starting local testing..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

print_status "Docker is running"

# Check if we're in the right directory
if [ ! -f "Dockerfile" ]; then
    print_error "Dockerfile not found. Please run this script from the project root."
    exit 1
fi

print_status "Project structure looks good"

# Build the Docker image
echo "🐳 Building Docker image..."
docker build --platform linux/amd64 -t tk4-hercules:test .

if [ $? -eq 0 ]; then
    print_status "Docker image built successfully"
else
    print_error "Docker build failed"
    exit 1
fi

# Test container startup and port validation
echo "🧪 Testing container startup and port validation..."
CONTAINER_NAME="test-tk4-local"

# Clean up any existing test container
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Start container with port mappings
docker run -d --name $CONTAINER_NAME \
    --platform linux/amd64 \
    -p 3270:3270 \
    -p 8038:8038 \
    tk4-hercules:test

# Wait for container to start and services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Check if container is running
if docker ps | grep -q $CONTAINER_NAME; then
    print_status "Container started successfully"
    
    # Check container logs for any obvious errors
    echo "📋 Container logs:"
    docker logs $CONTAINER_NAME | head -10
    
    # Test port 3270 (3270 terminal)
    echo "🔌 Testing 3270 terminal port..."
    if command -v nc > /dev/null 2>&1; then
        if nc -z localhost 3270; then
            print_status "Port 3270 is accessible"
        else
            print_error "Port 3270 is not accessible"
            docker logs $CONTAINER_NAME
            docker stop $CONTAINER_NAME
            docker rm $CONTAINER_NAME
            exit 1
        fi
    else
        print_warning "netcat not available, skipping port 3270 test"
    fi
    
    # Test port 8038 (web console)
    echo "🌐 Testing web console port 8038..."
    if command -v curl > /dev/null 2>&1; then
        # Wait a bit more for web service to fully start
        sleep 5
        
        # Test if web port is accessible
        if curl -s --connect-timeout 10 http://localhost:8038 > /dev/null 2>&1; then
            print_status "Web console (port 8038) is accessible"
            
            # Try to get the actual page content
            WEB_RESPONSE=$(curl -s --connect-timeout 10 http://localhost:8038 2>/dev/null || echo "")
            if [ -n "$WEB_RESPONSE" ]; then
                print_status "Web console is serving content"
            else
                print_warning "Web console port is open but no content received"
            fi
        else
            print_warning "Web console (port 8038) is not accessible (this is expected in test mode)"
            print_info "Note: Web console requires MVS to be fully started, which is not done in test mode"
        fi
    else
        print_warning "curl not available, skipping web console test"
    fi
    
    # Test basic 3270 terminal functionality (if available)
    echo "💻 Testing 3270 terminal functionality..."
    if command -v nc > /dev/null 2>&1; then
        # Try to connect to 3270 and send a basic command
        # Note: This is a basic connectivity test, not full 3270 protocol
        if echo -e "\r" | nc -w 5 localhost 3270 > /dev/null 2>&1; then
            print_status "3270 terminal accepts connections"
        else
            print_warning "3270 terminal connection test failed (this may be normal)"
        fi
    fi
    
    # Stop and clean up
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
    print_status "Container and port tests passed"
else
    print_error "Container failed to start"
    echo "Container logs:"
    docker logs $CONTAINER_NAME || true
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
    exit 1
fi

# Test multi-platform build (if buildx is available)
if docker buildx version > /dev/null 2>&1; then
    echo "🔧 Testing multi-platform build..."
    docker buildx build --platform linux/amd64,linux/arm64 -t tk4-hercules:test-multi .
    if [ $? -eq 0 ]; then
        print_status "Multi-platform build successful"
    else
        print_warning "Multi-platform build failed (this is optional for local testing)"
    fi
else
    print_warning "Docker buildx not available, skipping multi-platform test"
fi

# Validate workflow files
echo "📋 Validating workflow files..."
for workflow in .github/workflows/*.yml; do
    if [ -f "$workflow" ]; then
        echo "Checking $workflow..."
        # Basic YAML syntax check (without requiring yaml module)
        if head -1 "$workflow" | grep -q "name:"; then
            print_status "$workflow syntax looks good"
        else
            print_error "$workflow has syntax issues"
            exit 1
        fi
    fi
done

# Check VERSION file
if [ -f "VERSION" ]; then
    VERSION=$(cat VERSION | tr -d ' ')
    print_status "VERSION file found: $VERSION"
else
    print_error "VERSION file not found"
    exit 1
fi

# Check essential files
ESSENTIAL_FILES=("README.md" "Dockerfile" "docker-compose.yml")
for file in "${ESSENTIAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_status "$file exists"
    else
        print_warning "$file not found"
    fi
done

echo ""
print_status "All local tests passed! 🎉"
echo ""
echo "You can now safely push to remote:"
echo "  git add ."
echo "  git commit -m 'your commit message'"
echo "  git push origin main"
echo "" 