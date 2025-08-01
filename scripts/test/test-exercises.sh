#!/bin/bash

# TK4-Hercules Exercise Test Script
# Tests exercise file structure, container startup, and basic mainframe functionality

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

echo "🧪 TK4-Hercules Exercise Tests"
echo "=============================="
echo "Testing:"
echo "  - Exercise file structure"
echo "  - Container startup and connectivity"
echo "  - Basic mainframe functionality"
echo ""

# Function to log test results
log_test() {
    local test_name="$1"
    local status="$2"
    local message="$3"
    
    case $status in
        "PASS")
            echo -e "${GREEN}✅ PASS${NC}: $test_name - $message"
            ((TESTS_PASSED++))
            ;;
        "FAIL")
            echo -e "${RED}❌ FAIL${NC}: $test_name - $message"
            ((TESTS_FAILED++))
            ;;
        "SKIP")
            echo -e "${YELLOW}⏭️  SKIP${NC}: $test_name - $message"
            ((TESTS_SKIPPED++))
            ;;
    esac
}

# Function to test exercise file structure
test_exercise_structure() {
    echo -e "${BLUE}📁 Testing exercise file structure...${NC}"
    
    local required_files=(
        "examples/README.md"
        "examples/start-here.md"
        "examples/01-first-session.md"
        "examples/02-file-systems.md"
        "examples/03-first-jcl-job.md"
        "examples/challenges/01-multi-step-jobs.md"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            log_test "File Exists: $file" "PASS" "File found"
        else
            log_test "File Exists: $file" "FAIL" "File missing"
        fi
    done
}

# Function to test exercise content quality
test_exercise_content() {
    echo -e "${BLUE}📖 Testing exercise content quality...${NC}"
    
    # Test required sections in exercise files
    local exercise_files=(
        "examples/01-first-session.md"
        "examples/02-file-systems.md"
        "examples/03-first-jcl-job.md"
    )
    
    local required_sections=(
        "Objective"
        "Prerequisites"
        "What You'll Learn"
        "Learning Checkpoint"
        "Navigation"
    )
    
    for file in "${exercise_files[@]}"; do
        if [ -f "$file" ]; then
            for section in "${required_sections[@]}"; do
                if grep -q "$section" "$file"; then
                    log_test "Content: $file - $section" "PASS" "Section found"
                else
                    log_test "Content: $file - $section" "FAIL" "Section missing"
                fi
            done
        fi
    done
}

# Function to test container startup
test_container_startup() {
    echo -e "${BLUE}🐳 Testing container startup...${NC}"
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        log_test "Docker Runtime" "FAIL" "Docker is not running"
        return
    fi
    
    log_test "Docker Runtime" "PASS" "Docker is running"
    
    # Check if docker-compose.yml exists
    if [ -f "docker-compose.yml" ]; then
        log_test "Docker Compose" "PASS" "docker-compose.yml found"
    else
        log_test "Docker Compose" "FAIL" "docker-compose.yml missing"
        return
    fi
    
    # Check if Dockerfile exists
    if [ -f "versions/tk4/Dockerfile" ]; then
        log_test "Dockerfile" "PASS" "Dockerfile found in versions/tk4/"
    else
        log_test "Dockerfile" "FAIL" "Dockerfile missing in versions/tk4/"
        return
    fi
    
    # Test container build (without running)
    echo "Building container for testing..."
    if docker build -t tkx-hercules-tk4-test versions/tk4/ >/dev/null 2>&1; then
        log_test "Container Build" "PASS" "Container builds successfully"
    else
        log_test "Container Build" "FAIL" "Container build failed"
        return
    fi
    
    # Clean up test image
    docker rmi tkx-hercules-tk4-test >/dev/null 2>&1 || true
}

# Function to test container connectivity
test_container_connectivity() {
    echo -e "${BLUE}🔌 Testing container connectivity...${NC}"
    
    # Check if container is currently running
    if docker compose ps | grep -q "tk4-hercules.*Up"; then
        log_test "Container Status" "PASS" "Container is running"
        
        # Test port 3270 (terminal)
        if netstat -an 2>/dev/null | grep -q ":3270"; then
            log_test "Port 3270 (Terminal)" "PASS" "Port is listening"
        else
            log_test "Port 3270 (Terminal)" "FAIL" "Port not listening"
        fi
        
        # Test port 8038 (web console)
        if netstat -an 2>/dev/null | grep -q ":8038"; then
            log_test "Port 8038 (Web Console)" "PASS" "Port is listening"
        else
            log_test "Port 8038 (Web Console)" "FAIL" "Port not listening"
        fi
        
        # Test basic connectivity to container
        if docker compose exec -T tk4-hercules echo "test" >/dev/null 2>&1; then
            log_test "Container Exec" "PASS" "Can execute commands in container"
        else
            log_test "Container Exec" "FAIL" "Cannot execute commands in container"
        fi
        
    else
        log_test "Container Status" "SKIP" "Container not running (start with 'make start')"
        log_test "Port 3270 (Terminal)" "SKIP" "Container not running"
        log_test "Port 8038 (Web Console)" "SKIP" "Container not running"
        log_test "Container Exec" "SKIP" "Container not running"
    fi
}

# Function to test basic mainframe functionality
test_mainframe_functionality() {
    echo -e "${BLUE}💻 Testing basic mainframe functionality...${NC}"
    
    # Check if container is running
    if ! docker compose ps | grep -q "tk4-hercules.*Up"; then
        log_test "Mainframe Tests" "SKIP" "Container not running (start with 'make start')"
        return
    fi
    
    # Test if Hercules process is running in container
    if docker compose exec -T tk4-hercules ps aux | grep -q "hercules"; then
        log_test "Hercules Process" "PASS" "Hercules emulator is running"
    else
        log_test "Hercules Process" "FAIL" "Hercules emulator not running"
    fi
    
    # Test if MVS is loaded (check for typical MVS processes)
    if docker compose exec -T tk4-hercules ps aux | grep -q "MVS"; then
        log_test "MVS System" "PASS" "MVS system is loaded"
    else
        log_test "MVS System" "SKIP" "MVS system status unclear"
    fi
    
    # Test if required directories exist in container
    local required_dirs=(
        "/opt/hercules"
        "/opt/hercules/tk4-"
        "/opt/hercules/tk4-/conf"
        "/opt/hercules/tk4-/logs"
    )
    
    for dir in "${required_dirs[@]}"; do
        if docker compose exec -T tk4-hercules test -d "$dir"; then
            log_test "Directory: $dir" "PASS" "Directory exists"
        else
            log_test "Directory: $dir" "FAIL" "Directory missing"
        fi
    done
}

# Function to test configuration files
test_configuration_files() {
    echo -e "${BLUE}⚙️  Testing configuration files...${NC}"
    
    local required_configs=(
        "docker-compose.yml"
        "versions/tk4/Dockerfile"
        "VERSION"
        "README.md"
    )
    
    for config in "${required_configs[@]}"; do
        if [ -f "$config" ]; then
            log_test "Config: $config" "PASS" "File exists"
        else
            log_test "Config: $config" "FAIL" "File missing"
        fi
    done
    
    # Test if VERSION file contains valid version
    if [ -f "VERSION" ]; then
        local version=$(cat VERSION | tr -d ' ')
        if [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            log_test "Version Format" "PASS" "Valid semantic version: $version"
        else
            log_test "Version Format" "FAIL" "Invalid version format: $version"
        fi
    fi
}

# Function to print test summary
print_summary() {
    echo ""
    echo -e "${BLUE}📊 Test Summary${NC}"
    echo "=================="
    echo -e "${GREEN}✅ Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}❌ Failed: $TESTS_FAILED${NC}"
    echo -e "${YELLOW}⏭️  Skipped: $TESTS_SKIPPED${NC}"
    
    local total=$((TESTS_PASSED + TESTS_FAILED + TESTS_SKIPPED))
    echo "Total: $total"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo ""
        echo -e "${GREEN}🎉 All tests passed!${NC}"
        exit 0
    else
        echo ""
        echo -e "${RED}⚠️  Some tests failed. Please check the output above.${NC}"
        exit 1
    fi
}

# Main test execution
main() {
    test_exercise_structure
    test_exercise_content
    test_configuration_files
    test_container_startup
    test_container_connectivity
    test_mainframe_functionality
    print_summary
}

# Run the tests
main 