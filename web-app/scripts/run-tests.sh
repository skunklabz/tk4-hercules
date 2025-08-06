#!/bin/bash

# Test runner script for TKX-Hercules LMS
# This script runs tests in Docker containers with proper cleanup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to cleanup containers and volumes
cleanup() {
    print_status "Cleaning up Docker containers and volumes..."
    docker-compose -f docker-compose.test.yml down --volumes --remove-orphans 2>/dev/null || true
    print_success "Cleanup completed"
}

# Function to handle script exit
exit_handler() {
    cleanup
    exit $1
}

# Set up exit handler
trap exit_handler EXIT

# Parse command line arguments
TEST_TYPE="all"
DEBUG_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --unit)
            TEST_TYPE="unit"
            shift
            ;;
        --integration)
            TEST_TYPE="integration"
            shift
            ;;
        --debug)
            DEBUG_MODE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --unit         Run only unit tests"
            echo "  --integration  Run only integration tests"
            echo "  --debug        Run tests in debug mode"
            echo "  --help, -h     Show this help message"
            echo ""
            echo "Default: Run all tests"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose >/dev/null 2>&1; then
    print_error "docker-compose is not installed. Please install docker-compose and try again."
    exit 1
fi

print_status "Starting tests in Docker containers..."

# Create necessary directories
mkdir -p test-results coverage playwright-report

# Determine which profile to use
if [ "$DEBUG_MODE" = true ]; then
    PROFILE="debug"
    print_status "Running tests in debug mode"
elif [ "$TEST_TYPE" = "unit" ]; then
    PROFILE="unit"
    print_status "Running unit tests only"
elif [ "$TEST_TYPE" = "integration" ]; then
    PROFILE="integration"
    print_status "Running integration tests only"
else
    PROFILE="all"
    print_status "Running all tests"
fi

# Run tests
if [ "$DEBUG_MODE" = true ]; then
    # Debug mode doesn't abort on container exit
    docker-compose -f docker-compose.test.yml --profile $PROFILE up --build
else
    # Normal mode aborts on container exit
    docker-compose -f docker-compose.test.yml --profile $PROFILE up --build --abort-on-container-exit --exit-code-from test-$PROFILE
fi

# Check exit code
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    print_success "All tests passed!"
    
    # Show test results if available
    if [ -d "test-results" ] && [ "$(ls -A test-results 2>/dev/null)" ]; then
        print_status "Test results available in test-results/"
    fi
    
    if [ -d "coverage" ] && [ "$(ls -A coverage 2>/dev/null)" ]; then
        print_status "Coverage reports available in coverage/"
    fi
    
    if [ -d "playwright-report" ] && [ "$(ls -A playwright-report 2>/dev/null)" ]; then
        print_status "Playwright reports available in playwright-report/"
    fi
else
    print_error "Tests failed with exit code $EXIT_CODE"
    exit $EXIT_CODE
fi 