#!/bin/bash

# Setup git hooks for tkx-hercules
# Installs pre-commit hook for automatic testing

set -e

echo "🔧 Setting up git hooks..."

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository. Please run this from the project root."
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Install pre-commit hook
echo "Installing pre-commit hook..."
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for tk4-hercules

# Run the pre-commit script
./scripts/pre-commit.sh
EOF

# Make the hook executable
chmod +x .git/hooks/pre-commit

echo -e "${GREEN}✅ Git hooks installed successfully!${NC}"
echo ""
echo "Now every commit will automatically run local tests."
echo "If tests fail, the commit will be blocked."
echo ""
echo "To bypass the hook (not recommended):"
echo "  git commit --no-verify -m 'your message'"
echo ""
echo "To remove the hook:"
echo "  rm .git/hooks/pre-commit" 