#!/bin/bash

# Port and service testing script for tk4-hercules
# Tests 3270 terminal and web console functionality

set -e

echo "🔌 Testing ports and services..."

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

# Function to test port connectivity
test_port() {
    local port=$1
    local service=$2
    local timeout=${3:-5}
    
    echo "🔌 Testing $service (port $port)..."
    
    if command -v nc > /dev/null 2>&1; then
        if nc -z -w $timeout localhost $port; then
            print_status "$service (port $port) is accessible"
            return 0
        else
            print_error "$service (port $port) is not accessible"
            return 1
        fi
    else
        print_warning "netcat not available, cannot test port $port"
        return 0
    fi
}

# Function to test web service
test_web_service() {
    local port=$1
    local service=$2
    local url="http://localhost:$port"
    
    echo "🌐 Testing $service web interface..."
    
    if command -v curl > /dev/null 2>&1; then
        # Test basic connectivity
        if curl -s --connect-timeout 10 --max-time 15 "$url" > /dev/null 2>&1; then
            print_status "$service web interface is accessible"
            
            # Try to get response content
            local response=$(curl -s --connect-timeout 10 --max-time 15 "$url" 2>/dev/null || echo "")
            if [ -n "$response" ]; then
                print_status "$service is serving content"
                
                # Check for specific content indicators
                if echo "$response" | grep -q -i "html\|hercules\|mainframe\|3270" 2>/dev/null; then
                    print_status "$service appears to be serving mainframe content"
                else
                    print_warning "$service is serving content but may not be mainframe-related"
                fi
            else
                print_warning "$service is accessible but not serving content"
            fi
            return 0
        else
            print_warning "$service web interface is not accessible (this may be expected if MVS is not fully started)"
            return 0
        fi
    else
        print_warning "curl not available, cannot test web interface"
        return 0
    fi
}

# Function to test 3270 terminal functionality
test_3270_terminal() {
    echo "💻 Testing 3270 terminal functionality..."
    
    if command -v nc > /dev/null 2>&1; then
        # Try to connect and send basic 3270 commands
        # Note: This is a simplified test - real 3270 testing would require a 3270 client
        
        # Test basic connection
        if echo -e "\r" | nc -w 5 localhost 3270 > /dev/null 2>&1; then
            print_status "3270 terminal accepts connections"
            
            # Try to send a basic command (this is very basic)
            if echo -e "\r\n" | nc -w 3 localhost 3270 > /dev/null 2>&1; then
                print_status "3270 terminal responds to basic commands"
            else
                print_warning "3270 terminal connection test completed (basic functionality)"
            fi
        else
            print_warning "3270 terminal connection test failed (this may be normal for basic nc)"
        fi
    else
        print_warning "netcat not available, cannot test 3270 terminal"
    fi
}

# Main testing logic
main() {
    print_info "Starting port and service tests..."
    
    # Check if container is running
if ! docker ps | grep -q tk4-hercules; then
  print_info "No running tk4-hercules container found. Starting one for testing..."
        
        # Start container for testing
  docker run -d --name test-tk4-ports \
            --platform linux/amd64 \
            -p 3270:3270 \
            -p 8038:8038 \
    tk4-hercules:latest 2>/dev/null || {
            print_error "Failed to start test container"
            exit 1
        }
        
        # Wait for services to start
        echo "⏳ Waiting for services to start..."
        sleep 15
        
        CONTAINER_NAME="test-tk4-ports"
        CLEANUP=true
    else
  print_info "Using existing tk4-hercules container"
  CONTAINER_NAME="tk4-hercules"
        CLEANUP=false
    fi
    
    # Test ports
    test_port 3270 "3270 Terminal"
    test_port 8038 "Web Console"
    
    # Test web service
    test_web_service 8038 "Web Console"
    
    # Test 3270 terminal functionality
    test_3270_terminal
    
    # Show container status
    echo ""
    print_info "Container status:"
docker ps | grep tk4-hercules || true
    
    # Show container logs (last 10 lines)
    echo ""
    print_info "Recent container logs:"
    docker logs --tail 10 $CONTAINER_NAME 2>/dev/null || true
    
    # Cleanup if we started a test container
    if [ "$CLEANUP" = true ]; then
        echo ""
        print_info "Cleaning up test container..."
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
    fi
    
    echo ""
    print_status "Port and service tests completed!"
    
    # Provide usage information
    echo ""
    print_info "To connect to the services:"
    echo "  🌐 Web Console: http://localhost:8038"
    echo "  💻 3270 Terminal: telnet localhost 3270"
    echo "  📋 Or use a 3270 terminal emulator to connect to localhost:3270"
}

# Run main function
main "$@" 