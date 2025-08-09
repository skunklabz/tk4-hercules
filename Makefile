# TK4-Hercules Makefile
# Common development tasks for the project

.PHONY: help build build-platform start stop test validate clean docs build-ghcr push-ghcr version bump-patch bump-minor bump-major

# Version management
VERSION := $(shell cat VERSION)

# Default target
help:
	@echo "TK4-Hercules Development Commands"
	@echo "================================="
	@echo ""
	@echo "Version Management:"
	@echo "  version       - Show current version"
	@echo "  bump-patch    - Bump patch version (1.1.0 → 1.1.1)"
	@echo "  bump-minor    - Bump minor version (1.1.0 → 1.2.0)"
	@echo "  bump-major    - Bump major version (1.1.0 → 2.0.0)"
	@echo ""
	@echo "Build Commands:"
	@echo "  build        - Build the Docker container"
	@echo "  build-platform - Build for AMD64 platform"
	@echo "  build-ghcr   - Build for GitHub Container Registry"
	@echo ""
	@echo "Registry Commands:"
	@echo "  push-ghcr    - Build and push to GitHub Container Registry"
	@echo "  login-ghcr   - Login to GitHub Container Registry"
	@echo "  Note: Local development uses local images only (no external registries)"
	@echo ""
	@echo "Container Commands:"
	@echo "  start        - Build and start the mainframe container (local image)"
	@echo "  stop         - Stop the mainframe container"
	@echo "  restart      - Restart the mainframe container"
	@echo "  logs         - Show container logs"
	@echo "  shell        - Open shell in running container"
	@echo ""
	@echo "Testing Commands:"
	@echo "  test         - Run essential tests (core functionality)"
	@echo "  test-quick   - Run quick validation"
	@echo "  validate     - Validate exercise content"
	@echo "  test-local   - Run full local test suite"
	@echo "  test-ports   - Test ports and services (3270, 8038)"
	@echo "  test-full    - Test full MVS services (starts actual system)"
	@echo "  pre-commit   - Run pre-commit checks (before pushing)"
	@echo ""
	@echo "Development Commands:"
	@echo "  clean        - Clean up containers and images"
	@echo "  docs         - Generate documentation"
	@echo "  lint         - Run linting checks"
	@echo "  setup-hooks  - Install git hooks for automatic testing"
	@echo ""
	@echo "CI/CD Commands:"
	@echo "  ci-lint      - Run CI linting checks"
	@echo "  ci-test      - Run CI tests"
	@echo "  ci-validate  - Run CI validation"
	@echo "  ci-full      - Run full CI pipeline"
	@echo ""

# Version management commands
version:
	@echo "Current version: $(VERSION)"

bump-patch:
	@echo "Bumping patch version..."
	@$(eval NEW_VERSION := $(shell echo $(VERSION) | awk -F. '{print $$1"."$$2"."$$3+1}'))
	@echo $(NEW_VERSION) > VERSION
	@echo "Version bumped to: $(NEW_VERSION)"
	@echo "Don't forget to:"
	@echo "  1. Update CHANGELOG.md with new version"
	@echo "  2. Commit the version bump"
	@echo "  3. Create a release tag: git tag v$(NEW_VERSION)"

bump-minor:
	@echo "Bumping minor version..."
	@$(eval NEW_VERSION := $(shell echo $(VERSION) | awk -F. '{print $$1"."$$2+1".0"}'))
	@echo $(NEW_VERSION) > VERSION
	@echo "Version bumped to: $(NEW_VERSION)"
	@echo "Don't forget to:"
	@echo "  1. Update CHANGELOG.md with new version"
	@echo "  2. Commit the version bump"
	@echo "  3. Create a release tag: git tag v$(NEW_VERSION)"

bump-major:
	@echo "Bumping major version..."
	@$(eval NEW_VERSION := $(shell echo $(VERSION) | awk -F. '{print $$1+1".0.0"}'))
	@echo $(NEW_VERSION) > VERSION
	@echo "Version bumped to: $(NEW_VERSION)"
	@echo "Don't forget to:"
	@echo "  1. Update CHANGELOG.md with new version"
	@echo "  2. Commit the version bump"
	@echo "  3. Create a release tag: git tag v$(NEW_VERSION)"

# Build commands
build:
	@echo "Building TK4-Hercules container..."
	@docker compose build

build-platform:
	@echo "Building for specific platform..."
	@./scripts/build/build-platform.sh



build-ghcr:
	@echo "Building for GitHub Container Registry..."
	@./scripts/build/build-ghcr.sh --no-prompt

# Registry commands
push-ghcr:
	@echo "Building and pushing to GitHub Container Registry..."
	@./scripts/build/build-ghcr.sh

login-ghcr:
	@echo "Logging into GitHub Container Registry..."
	@echo "Please ensure you have a GitHub token with 'write:packages' permission"
	@echo "Run: echo \$GITHUB_TOKEN | docker login ghcr.io -u skunklabz --password-stdin"

# Container management
start:
	@echo "Starting TK4-Hercules mainframe..."
	@docker compose up -d

stop:
	@echo "Stopping TK4-Hercules mainframe..."
	@docker compose down

restart: stop start
	@echo "Restarted TK4-Hercules mainframe"

logs:
	@docker compose logs -f

shell:
	@docker exec -it tk4-hercules /bin/bash

# Testing commands
test:
	@echo "Running essential tests (core functionality)..."
	@echo "This tests:"
	@echo "  - Exercise file structure"
	@echo "  - Container startup and connectivity"
	@echo "  - Basic mainframe functionality (TK4-)"
	@./scripts/test/test-exercises.sh

test-quick:
	@echo "Running quick validation..."
	@./scripts/validation/quick-validate.sh

test-local:
	@echo "Running full local test suite..."
	@echo "This includes:"
	@echo "  - Docker build validation"
	@echo "  - Container startup testing"
	@echo "  - Multi-platform build test"
	@echo "  - Workflow file validation"
	@echo "  - Essential file checks"
	@./scripts/test-local.sh

test-ports:
	@echo "Testing ports and services..."
	@echo "This includes:"
	@echo "  - 3270 terminal port validation"
	@echo "  - Web console (port 8038) testing"
	@echo "  - Service connectivity checks"
	@./scripts/test-ports.sh

test-full:
	@echo "Testing full MVS services..."
	@echo "This includes:"
	@echo "  - Starting actual MVS system"
	@echo "  - Testing 3270 terminal functionality"
	@echo "  - Testing web console (port 8038)"
	@echo "  - Full service validation"
	@./scripts/test-full-services.sh

pre-commit:
	@echo "Running pre-commit checks..."
	@echo "This ensures your code is ready for remote push"
	@./scripts/pre-commit.sh



validate:
	@echo "Validating exercise content..."
	@./scripts/validation/validate-exercises.sh

# Development commands
clean:
	@echo "Cleaning up containers and images..."
	@docker compose down -v
	@docker rmi tk4-hercules:latest 2>/dev/null || true
	@docker rmi ghcr.io/skunklabz/tk4-hercules:latest 2>/dev/null || true
	@docker system prune -f

docs:
	@echo "Generating documentation..."
	@echo "Documentation is in the docs/ directory"

lint:
	@echo "Running linting checks..."
	@shellcheck scripts/**/*.sh || true
	@echo "Linting complete"

setup-hooks:
	@echo "Setting up git hooks for automatic testing..."
	@./scripts/setup-hooks.sh

# Development workflow
dev-setup: build start
	@echo "Development environment ready!"
	@echo "Connect to mainframe: telnet localhost 3270"
	@echo "Web console: http://localhost:8038"

dev-clean: stop clean
	@echo "Development environment cleaned"

# CI/CD helpers
ci-lint:
	@echo "Running CI linting checks..."
	@shellcheck scripts/**/*.sh || true
	@echo "Checking script permissions..."
	@for script in scripts/**/*.sh; do \
		if [ -f "$$script" ]; then \
			if [ ! -x "$$script" ]; then \
				echo "❌ Script $$script is not executable"; \
				exit 1; \
			fi; \
		fi; \
	done
	@echo "Validating YAML files..."
	@docker compose config
	@echo "✅ CI linting checks completed"

# Utility commands
status:
	@echo "Container status:"
	@docker compose ps
	@echo ""
	@echo "Port status:"
	@echo "3270 (Terminal): $(shell netstat -an 2>/dev/null | grep :3270 || echo 'Not listening')"
	@echo "8038 (Web): $(shell netstat -an 2>/dev/null | grep :8038 || echo 'Not listening')"

info:
	@echo "TK4-Hercules Project Information"
	@echo "================================"
	@echo "Version: $(VERSION)"
	@echo "Mainframe: IBM MVS 3.8j (TK4-)"
	@echo "Emulator: Hercules"
	@echo "Container: Docker"
	@echo "Registry: GitHub Container Registry (ghcr.io)"
	@echo ""
	@echo "Documentation:"
	@echo "- README.md: Quick start guide"
	@echo "- docs/TKX_MIGRATION_PLAN.md: Migration strategy"
	@echo "- docs/ARM64_SUPPORT.md: Platform notes"
	@echo "- docs/ATTRIBUTIONS.md: Credits and acknowledgments"
	@echo ""
	@echo "Scripts:"
	@echo "- scripts/build/: Build scripts"
	@echo "- scripts/test/: Test scripts"
	@echo "- scripts/validation/: Validation scripts" 