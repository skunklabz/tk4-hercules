#!/bin/bash

# TK4-Hercules Exercise Validation Script
# Quick validation of exercise files and content without running mainframe

# Don't exit on error, handle them gracefully

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

echo "🔍 TK4-Hercules Exercise Validation"
echo "==================================="
echo "Validating exercise files and content..."
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
        "versions/tk4/Dockerfile"
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

# Function to test navigation links
test_navigation_links() {
    echo -e "${BLUE}🔗 Testing navigation links...${NC}"
    
    # Check for navigation sections
    if grep -r "Navigation" examples/ > /dev/null 2>&1; then
        log_test "Navigation Sections" "PASS" "Navigation sections found"
    else
        log_test "Navigation Sections" "FAIL" "Navigation sections missing"
    fi
    
    # Check for navigation sections (more flexible)
    if grep -r "Navigation" examples/ > /dev/null 2>&1; then
        log_test "Navigation Sections" "PASS" "Navigation sections found"
    else
        log_test "Navigation Sections" "FAIL" "Navigation sections missing"
    fi
    
    # Check for next/previous links (optional)
    if grep -r "Next:" examples/ > /dev/null 2>&1; then
        log_test "Next Links" "PASS" "Next links found"
    else
        log_test "Next Links" "SKIP" "Next links not implemented yet"
    fi
    
    if grep -r "Previous:" examples/ > /dev/null 2>&1; then
        log_test "Previous Links" "PASS" "Previous links found"
    else
        log_test "Previous Links" "SKIP" "Previous links not implemented yet"
    fi
}

# Function to test code examples
test_code_examples() {
    echo -e "${BLUE}💻 Testing code examples...${NC}"
    
    # Check for TSO command examples
    if grep -r "\`\`\`tso" examples/ > /dev/null 2>&1; then
        log_test "TSO Code Examples" "PASS" "TSO code examples found"
    else
        log_test "TSO Code Examples" "SKIP" "TSO code examples not found"
    fi
    
    # Check for JCL examples
    if grep -r "\`\`\`jcl" examples/ > /dev/null 2>&1; then
        log_test "JCL Code Examples" "PASS" "JCL code examples found"
    else
        log_test "JCL Code Examples" "FAIL" "JCL code examples missing"
    fi
    
    # Check for COBOL examples
    if grep -r "\`\`\`cobol" examples/ > /dev/null 2>&1; then
        log_test "COBOL Code Examples" "PASS" "COBOL code examples found"
    else
        log_test "COBOL Code Examples" "SKIP" "COBOL code examples not found"
    fi
}

# Function to test learning objectives
test_learning_objectives() {
    echo -e "${BLUE}🎯 Testing learning objectives...${NC}"
    
    # Check for clear objectives in each exercise
    local exercise_files=(
        "examples/01-first-session.md"
        "examples/02-file-systems.md"
        "examples/03-first-jcl-job.md"
    )
    
    for file in "${exercise_files[@]}"; do
        if [ -f "$file" ]; then
            if grep -q "Objective" "$file"; then
                log_test "Learning Objective: $file" "PASS" "Objective clearly stated"
            else
                log_test "Learning Objective: $file" "FAIL" "Objective missing"
            fi
        fi
    done
}

# Function to test prerequisites
test_prerequisites() {
    echo -e "${BLUE}📋 Testing prerequisites...${NC}"
    
    # Check for prerequisites in each exercise
    local exercise_files=(
        "examples/01-first-session.md"
        "examples/02-file-systems.md"
        "examples/03-first-jcl-job.md"
    )
    
    for file in "${exercise_files[@]}"; do
        if [ -f "$file" ]; then
            if grep -q "Prerequisites" "$file"; then
                log_test "Prerequisites: $file" "PASS" "Prerequisites listed"
            else
                log_test "Prerequisites: $file" "FAIL" "Prerequisites missing"
            fi
        fi
    done
}

# Function to test user accounts documentation
test_user_accounts() {
    echo -e "${BLUE}👤 Testing user accounts documentation...${NC}"
    
    # Check if user accounts are documented
    if grep -r "HERC01" examples/ > /dev/null 2>&1; then
        log_test "User Account Documentation" "PASS" "User accounts documented"
    else
        log_test "User Account Documentation" "FAIL" "User accounts not documented"
    fi
    
    # Check for password information
    if grep -r "CUL8TR" examples/ > /dev/null 2>&1; then
        log_test "Password Documentation" "PASS" "Passwords documented"
    else
        log_test "Password Documentation" "FAIL" "Passwords not documented"
    fi
}

# Function to test command examples
test_command_examples() {
    echo -e "${BLUE}🔧 Testing command examples...${NC}"
    
    # Check for essential TSO commands
    local essential_commands=(
        "LISTD"
        "BROWSE"
        "ALLOCATE"
        "DELETE"
    )
    
    for cmd in "${essential_commands[@]}"; do
        if grep -r "$cmd" examples/ > /dev/null 2>&1; then
            log_test "Command Example: $cmd" "PASS" "Command documented"
        else
            log_test "Command Example: $cmd" "FAIL" "Command not documented"
        fi
    done
}

# Function to test external links
test_external_links() {
    echo -e "${BLUE}🔗 Testing external links...${NC}"
    
    # Check for important external resources
    local external_links=(
        "hercules-390.github.io"
        "jaymoseley.com"
        "mslinn.com"
        "ibm.com"
    )
    
    for link in "${external_links[@]}"; do
        if grep -r "$link" examples/ > /dev/null 2>&1; then
            log_test "External Link: $link" "PASS" "External link found"
        else
            log_test "External Link: $link" "SKIP" "External link not found - optional"
        fi
    done
}

# Function to test markdown formatting
test_markdown_formatting() {
    echo -e "${BLUE}📝 Testing markdown formatting...${NC}"
    
    # Check for proper markdown headers
    if grep -r "^## " examples/ > /dev/null 2>&1; then
        log_test "Markdown Headers" "PASS" "Proper headers found"
    else
        log_test "Markdown Headers" "FAIL" "Headers missing"
    fi
    
    # Check for code blocks
    if grep -r "^\\\`\\\`\\\`" examples/ > /dev/null 2>&1; then
        log_test "Code Blocks" "PASS" "Code blocks found"
    else
        log_test "Code Blocks" "FAIL" "Code blocks missing"
    fi
    
    # Check for emojis (engagement)
    if grep -r "🎯\|🚀\|💻\|🔧\|📁\|🎓" examples/ > /dev/null 2>&1; then
        log_test "Emoji Usage" "PASS" "Emojis used for engagement"
    else
        log_test "Emoji Usage" "SKIP" "No emojis found (optional)"
    fi
}

# Function to test exercise progression
test_exercise_progression() {
    echo -e "${BLUE}📈 Testing exercise progression...${NC}"
    
    # Check that exercises build on each other
    if grep -r "Exercise 1" examples/02-file-systems.md > /dev/null 2>&1; then
        log_test "Exercise Progression" "PASS" "Exercises reference previous ones"
    else
        log_test "Exercise Progression" "SKIP" "Progression references optional"
    fi
}

# Main validation execution
main() {
    echo "🚀 Starting exercise validation..."
    echo ""
    
    # Check if we're in the right directory
    if [ ! -d "examples" ]; then
        echo -e "${RED}❌ Error: Must run from tk4-hercules project root${NC}"
        exit 1
    fi
    
    # Run all validation tests
    test_exercise_structure
    test_exercise_content
    test_navigation_links
    test_code_examples
    test_learning_objectives
    test_prerequisites
    test_user_accounts
    test_command_examples
    test_external_links
    test_markdown_formatting
    test_exercise_progression
    
    echo ""
    echo "📊 Validation Results Summary"
    echo "============================"
    echo -e "${GREEN}✅ Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}❌ Failed: $TESTS_FAILED${NC}"
    echo -e "${YELLOW}⏭️  Skipped: $TESTS_SKIPPED${NC}"
    echo ""
    
    # Calculate total tests
    TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED + TESTS_SKIPPED))
    echo "Total Tests: $TOTAL_TESTS"
    
    # Determine exit code
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}🎉 All critical validations passed!${NC}"
        echo -e "${BLUE}💡 Run ./scripts/test/test-exercises.sh for full functional testing${NC}"
        EXIT_CODE=0
    else
        echo -e "${RED}⚠️  Some validations failed. Please fix the issues above.${NC}"
        EXIT_CODE=1
    fi
    
    echo ""
    echo -e "${BLUE}💡 Tips:${NC}"
    echo "  - Fix any FAILED tests before running functional tests"
    echo "  - SKIPPED tests are optional and can be ignored"
    echo "  - Run ./scripts/test/test-exercises.sh for full mainframe testing"
    
    exit $EXIT_CODE
}

# Run main function
main "$@" 