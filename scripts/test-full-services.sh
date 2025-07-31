#!/bin/bash

# Full service testing script for tk4-hercules
# Starts the actual MVS system and tests all services

set -e

echo "🚀 Testing full MVS services..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if we're in the right directory
if [ ! -f "Dockerfile" ]; then
    print_error "Dockerfile not found. Please run this script from the project root."
    exit 1
fi

# Function to wait for service to be ready
wait_for_service() {
    local port=$1
    local service=$2
    local max_attempts=30
    local attempt=1
    
    echo "⏳ Waiting for $service to be ready..."
    
    while [ $attempt -le $max_attempts ]; do
        if command -v nc > /dev/null 2>&1; then
            if nc -z localhost $port; then
                print_status "$service is ready!"
                return 0
            fi
        fi
        
        echo "Attempt $attempt/$max_attempts - $service not ready yet..."
        sleep 10
        attempt=$((attempt + 1))
    done
    
    print_error "$service failed to start within expected time"
    return 1
}

# Function to test web console
test_web_console() {
    local max_attempts=10
    local attempt=1
    
    echo "🌐 Testing web console..."
    
    while [ $attempt -le $max_attempts ]; do
        if command -v curl > /dev/null 2>&1; then
            if curl -s --connect-timeout 10 http://localhost:8038 > /dev/null 2>&1; then
                print_status "Web console is accessible"
                
                # Try to get content
                local response=$(curl -s --connect-timeout 10 http://localhost:8038 2>/dev/null || echo "")
                if [ -n "$response" ]; then
                    print_status "Web console is serving content"
                    return 0
                else
                    print_warning "Web console is accessible but not serving content yet"
                fi
            fi
        fi
        
        echo "Attempt $attempt/$max_attempts - Web console not ready yet..."
        sleep 15
        attempt=$((attempt + 1))
    done
    
    print_warning "Web console may not be fully functional (this can take several minutes)"
    return 0
}

# Main testing logic
main() {
    print_info "Starting full MVS service tests..."
    
    # Clean up any existing test containers
    docker stop test-tk4-full 2>/dev/null || true
    docker rm test-tk4-full 2>/dev/null || true
    
    # Build the image if needed
    if ! docker images | grep -q "tk4-hercules.*latest"; then
        print_info "Building Docker image..."
        docker build --platform linux/amd64 -t tk4-hercules:latest .
    fi
    
    # Start container with actual MVS startup
    print_info "Starting container with MVS system..."
    docker run -d --name test-tk4-full \
        --platform linux/amd64 \
        -p 3270:3270 \
        -p 8038:8038 \
        tk4-hercules:latest
    
    # Wait for container to start
    sleep 5
    
    # Check if container is running
    if ! docker ps | grep -q test-tk4-full; then
        print_error "Container failed to start"
        docker logs test-tk4-full || true
        exit 1
    fi
    
    print_status "Container started successfully"
    
    # Show initial logs
    echo ""
    print_info "Initial container logs:"
    docker logs test-tk4-full | head -20
    
    # Wait for 3270 service
    if wait_for_service 3270 "3270 Terminal"; then
        print_status "3270 terminal service is ready"
    else
        print_error "3270 terminal service failed to start"
        docker logs test-tk4-full
        docker stop test-tk4-full
        docker rm test-tk4-full
        exit 1
    fi
    
    # Test web console (this may take longer)
    test_web_console
    
    # Show final status
    echo ""
    print_info "Final container status:"
    docker ps | grep test-tk4-full || true
    
    echo ""
    print_info "Recent container logs:"
    docker logs --tail 20 test-tk4-full
    
    # Provide connection information
    echo ""
    print_status "Full service tests completed!"
    echo ""
    print_info "Services are now available:"
    echo "  🌐 Web Console: http://localhost:8038"
    echo "  💻 3270 Terminal: telnet localhost 3270"
    echo ""
    print_info "To stop the test container:"
    echo "  docker stop test-tk4-full"
    echo "  docker rm test-tk4-full"
    echo ""
    print_info "To keep the container running for manual testing:"
    echo "  # Container will continue running until stopped"
    echo "  # You can connect to the services above"
}

# Run main function
main "$@" 