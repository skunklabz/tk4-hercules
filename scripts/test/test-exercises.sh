#!/bin/bash

# TK4-Hercules Essential Exercise Test Script
# Simplified test suite focusing on core functionality

set -e

# Configuration
CONTAINER_NAME="tk4-hercules"
TEST_TIMEOUT=120  # 2 minutes timeout for tests
LOG_FILE="exercise-test-results.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

echo "🧪 TK4-Hercules Essential Test Suite"
echo "===================================="
echo "Testing core functionality..."
echo "Log file: $LOG_FILE"
echo ""

# Initialize log file
echo "TK4-Hercules Essential Test Results - $(date)" > "$LOG_FILE"
echo "=============================================" >> "$LOG_FILE"

# Function to log test results
log_test() {
    local test_name="$1"
    local status="$2"
    local message="$3"
    
    case $status in
        "PASS")
            echo -e "${GREEN}✅ PASS${NC}: $test_name - $message"
            echo "✅ PASS: $test_name - $message" >> "$LOG_FILE"
            ((TESTS_PASSED++))
            ;;
        "FAIL")
            echo -e "${RED}❌ FAIL${NC}: $test_name - $message"
            echo "❌ FAIL: $test_name - $message" >> "$LOG_FILE"
            ((TESTS_FAILED++))
            ;;
        "SKIP")
            echo -e "${YELLOW}⏭️  SKIP${NC}: $test_name - $message"
            echo "⏭️  SKIP: $test_name - $message" >> "$LOG_FILE"
            ((TESTS_SKIPPED++))
            ;;
    esac
}

# Function to wait for mainframe to be ready
wait_for_mainframe() {
    echo -e "${BLUE}⏳ Waiting for mainframe to be ready...${NC}"
    
    local max_attempts=12  # 12 attempts * 10 seconds = 120 seconds timeout
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        # Check web interface for mainframe readiness
        if curl -s http://localhost:8038/cgi-bin/tasks/syslog | grep -q "Enter input for console\|HHC00010A\|READY"; then
            echo -e "${GREEN}✅ Mainframe is ready!${NC}"
            return 0
        fi
        
        echo -n "."
        sleep 10  # Check every 10 seconds
        ((attempt++))
    done
    
    echo -e "${RED}❌ Mainframe failed to start within timeout${NC}"
    return 1
}

# Function to test exercise files
test_exercise_files() {
    echo -e "${BLUE}📁 Testing exercise files...${NC}"
    
    # Check if examples directory exists
    if [ -d "examples" ]; then
        log_test "Examples Directory" "PASS" "Directory exists"
    else
        log_test "Examples Directory" "FAIL" "Directory missing"
        return 1
    fi
    
    # Check for required files
    required_files=(
        "examples/README.md"
        "examples/start-here.md"
        "examples/01-first-session.md"
        "examples/02-file-systems.md"
        "examples/03-first-jcl-job.md"
        "examples/challenges/01-multi-step-jobs.md"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            log_test "File: $file" "PASS" "File exists"
        else
            log_test "File: $file" "FAIL" "File missing"
        fi
    done
}

# Function to test exercise content
test_exercise_content() {
    echo -e "${BLUE}📖 Testing exercise content...${NC}"
    
    exercise_files=(
        "examples/01-first-session.md"
        "examples/02-file-systems.md"
        "examples/03-first-jcl-job.md"
    )
    
    for file in "${exercise_files[@]}"; do
        if [ -f "$file" ]; then
            # Check for essential sections
            if grep -q "Objective" "$file"; then
                log_test "Content: $file - Objective" "PASS" "Section found"
            else
                log_test "Content: $file - Objective" "FAIL" "Section missing"
            fi
            
            if grep -q "Prerequisites" "$file"; then
                log_test "Content: $file - Prerequisites" "PASS" "Section found"
            else
                log_test "Content: $file - Prerequisites" "FAIL" "Section missing"
            fi
        fi
    done
}

# Function to test mainframe connectivity
test_mainframe_connectivity() {
    echo -e "${BLUE}🔌 Testing mainframe connectivity...${NC}"
    
    # Test web interface
    if curl -s http://localhost:8038/ > /dev/null; then
        log_test "Web Interface" "PASS" "Web console accessible"
    else
        log_test "Web Interface" "FAIL" "Web console not accessible"
    fi
    
    # Test 3270 port
    if nc -z localhost 3270 2>/dev/null; then
        log_test "3270 Port" "PASS" "Terminal port accessible"
    else
        log_test "3270 Port" "FAIL" "Terminal port not accessible"
    fi
    
    # Test container health
    if docker ps | grep -q "$CONTAINER_NAME"; then
        log_test "Container Health" "PASS" "Container is running"
    else
        log_test "Container Health" "FAIL" "Container is not running"
    fi
}

# Main function
main() {
    echo -e "${BLUE}🚀 Starting essential test suite...${NC}"
    
    # Pre-flight checks
    if [ ! -f "Dockerfile" ] || [ ! -f "docker-compose.yml" ]; then
        echo -e "${RED}❌ Error: Must run from tk4-hercules project root${NC}"
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Error: Docker is not installed${NC}"
        exit 1
    fi
    
    # Start test container
    echo -e "${BLUE}🐳 Starting test container...${NC}"
    if [ "${CI:-false}" = "true" ]; then
        IMAGE_NAME="tk4-hercules:test"
    else
        IMAGE_NAME="ghcr.io/skunklabz/tk4-hercules:latest"
    fi
    
    IMAGE_NAME="$IMAGE_NAME" docker compose up -d --force-recreate
    
    # Wait for container to be ready
    if ! wait_for_mainframe; then
        echo -e "${RED}❌ Failed to start mainframe for testing${NC}"
        docker compose down
        exit 1
    fi
    
    echo ""
    echo "🧪 Running essential tests..."
    echo ""
    
    # Run essential test suites
    test_exercise_files
    test_exercise_content
    test_mainframe_connectivity
    
    echo ""
    echo "📊 Test Results Summary"
    echo "======================"
    echo -e "${GREEN}✅ Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}❌ Failed: $TESTS_FAILED${NC}"
    echo -e "${YELLOW}⏭️  Skipped: $TESTS_SKIPPED${NC}"
    echo ""
    
    # Calculate total tests
    TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED + TESTS_SKIPPED))
    echo "Total Tests: $TOTAL_TESTS"
    
    # Write summary to log
    echo "" >> "$LOG_FILE"
    echo "Test Summary:" >> "$LOG_FILE"
    echo "=============" >> "$LOG_FILE"
    echo "Passed: $TESTS_PASSED" >> "$LOG_FILE"
    echo "Failed: $TESTS_FAILED" >> "$LOG_FILE"
    echo "Skipped: $TESTS_SKIPPED" >> "$LOG_FILE"
    echo "Total: $TOTAL_TESTS" >> "$LOG_FILE"
    
    # Determine exit code
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}🎉 All essential tests passed!${NC}"
        echo "🎉 All essential tests passed!" >> "$LOG_FILE"
        EXIT_CODE=0
    else
        echo -e "${RED}⚠️  Some tests failed. Check the log for details.${NC}"
        echo "⚠️  Some tests failed. Check the log for details." >> "$LOG_FILE"
        EXIT_CODE=1
    fi
    
    # Cleanup
    echo ""
    echo -e "${BLUE}🧹 Cleaning up test environment...${NC}"
    docker compose down
    
    echo ""
    echo -e "${BLUE}📋 Detailed results saved to: $LOG_FILE${NC}"
    
    exit $EXIT_CODE
}

# Handle script interruption
trap 'echo -e "\n${YELLOW}⚠️  Test interrupted. Cleaning up...${NC}"; docker compose down; exit 1' INT TERM

# Run main function
main "$@" 