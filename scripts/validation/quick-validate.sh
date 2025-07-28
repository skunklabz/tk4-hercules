#!/bin/bash

# Quick TK4-Hercules Exercise Validation
# Simple validation without complex operations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "🔍 Quick TK4-Hercules Exercise Validation"
echo "========================================="
echo ""

# Test counter
PASSED=0
FAILED=0

# Function to log results
log_result() {
    local test_name="$1"
    local status="$2"
    local message="$3"
    
    case $status in
        "PASS")
            echo -e "${GREEN}✅ PASS${NC}: $test_name - $message"
            ((PASSED++))
            ;;
        "FAIL")
            echo -e "${RED}❌ FAIL${NC}: $test_name - $message"
            ((FAILED++))
            ;;
    esac
}

echo -e "${BLUE}📁 Testing exercise files...${NC}"

# Test 1: Check if examples directory exists
if [ -d "examples" ]; then
    log_result "Examples Directory" "PASS" "Directory exists"
else
    log_result "Examples Directory" "FAIL" "Directory missing"
    exit 1
fi

# Test 2: Check for required files
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
        log_result "File: $file" "PASS" "File exists"
    else
        log_result "File: $file" "FAIL" "File missing"
    fi
done

echo ""
echo -e "${BLUE}📖 Testing exercise content...${NC}"

# Test 3: Check for required sections in exercise files
exercise_files=(
    "examples/01-first-session.md"
    "examples/02-file-systems.md"
    "examples/03-first-jcl-job.md"
)

for file in "${exercise_files[@]}"; do
    if [ -f "$file" ]; then
        # Check for Objective
        if grep -q "Objective" "$file"; then
            log_result "Content: $file - Objective" "PASS" "Section found"
        else
            log_result "Content: $file - Objective" "FAIL" "Section missing"
        fi
        
        # Check for Prerequisites
        if grep -q "Prerequisites" "$file"; then
            log_result "Content: $file - Prerequisites" "PASS" "Section found"
        else
            log_result "Content: $file - Prerequisites" "FAIL" "Section missing"
        fi
        
        # Check for Navigation
        if grep -q "Navigation" "$file"; then
            log_result "Content: $file - Navigation" "PASS" "Section found"
        else
            log_result "Content: $file - Navigation" "FAIL" "Section missing"
        fi
    fi
done

echo ""
echo -e "${BLUE}🔗 Testing navigation links...${NC}"

# Test 4: Check for navigation links
if grep -r "Next" examples/ > /dev/null 2>&1; then
    log_result "Next Links" "PASS" "Next links found"
else
    log_result "Next Links" "FAIL" "Next links missing"
fi

if grep -r "Previous" examples/ > /dev/null 2>&1; then
    log_result "Previous Links" "PASS" "Previous links found"
else
    log_result "Previous Links" "FAIL" "Previous links missing"
fi

echo ""
echo -e "${BLUE}💻 Testing code examples...${NC}"

# Test 5: Check for code examples
if grep -r "jcl" examples/ > /dev/null 2>&1; then
    log_result "JCL Code Examples" "PASS" "JCL examples found"
else
    log_result "JCL Code Examples" "FAIL" "JCL examples missing"
fi

if grep -r "tso" examples/ > /dev/null 2>&1; then
    log_result "TSO Code Examples" "PASS" "TSO examples found"
else
    log_result "TSO Code Examples" "FAIL" "TSO examples missing"
fi

echo ""
echo -e "${BLUE}👤 Testing user accounts...${NC}"

# Test 6: Check for user account documentation
if grep -r "HERC01" examples/ > /dev/null 2>&1; then
    log_result "User Accounts" "PASS" "User accounts documented"
else
    log_result "User Accounts" "FAIL" "User accounts not documented"
fi

if grep -r "CUL8TR" examples/ > /dev/null 2>&1; then
    log_result "Passwords" "PASS" "Passwords documented"
else
    log_result "Passwords" "FAIL" "Passwords not documented"
fi

echo ""
echo -e "${BLUE}🔧 Testing commands...${NC}"

# Test 7: Check for essential commands
essential_commands=("LISTD" "BROWSE" "ALLOCATE" "DELETE")

for cmd in "${essential_commands[@]}"; do
    if grep -r "$cmd" examples/ > /dev/null 2>&1; then
        log_result "Command: $cmd" "PASS" "Command documented"
    else
        log_result "Command: $cmd" "FAIL" "Command not documented"
    fi
done

echo ""
echo "📊 Validation Results Summary"
echo "============================"
echo -e "${GREEN}✅ Passed: $PASSED${NC}"
echo -e "${RED}❌ Failed: $FAILED${NC}"
echo ""

TOTAL=$((PASSED + FAILED))
echo "Total Tests: $TOTAL"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All validations passed!${NC}"
    echo -e "${BLUE}💡 Run ./test-exercises.sh for full functional testing${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Some validations failed. Please fix the issues above.${NC}"
    exit 1
fi 