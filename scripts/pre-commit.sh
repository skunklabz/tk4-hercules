#!/bin/bash

# Pre-commit hook for tk4-hercules
# Runs local tests before allowing commits

set -e

echo "🔍 Running pre-commit checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "Dockerfile" ]; then
    print_error "Dockerfile not found. Please run this script from the project root."
    exit 1
fi

# Quick checks that don't require Docker
echo "📋 Running quick checks..."

# Check if VERSION file exists and has content
if [ ! -f "VERSION" ] || [ ! -s "VERSION" ]; then
    print_error "VERSION file is missing or empty"
    exit 1
fi
print_status "VERSION file is valid"

# Check if essential files exist
ESSENTIAL_FILES=("README.md" "Dockerfile")
for file in "${ESSENTIAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        print_error "Essential file missing: $file"
        exit 1
    fi
done
print_status "Essential files present"

# Check if workflow files are valid YAML
for workflow in .github/workflows/*.yml; do
    if [ -f "$workflow" ]; then
        # Basic syntax check (without requiring yaml module)
        if head -1 "$workflow" | grep -q "name:"; then
            print_status "$workflow syntax looks good"
        else
            print_error "$workflow has syntax issues"
            exit 1
        fi
    fi
done

# Check if Docker is available
if ! command -v docker > /dev/null 2>&1; then
    print_error "Docker is not installed or not in PATH"
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi
print_status "Docker is available and running"

# Run the full local test suite
echo "🧪 Running full local test suite..."
if ./scripts/test-local.sh; then
    print_status "All pre-commit checks passed!"
    echo ""
    echo "You can now commit your changes:"
    echo "  git add ."
    echo "  git commit -m 'your commit message'"
    echo ""
else
    print_error "Pre-commit checks failed. Please fix the issues above."
    exit 1
fi 