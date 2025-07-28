# TK4-Hercules Makefile
# Common development tasks for the project

.PHONY: help build start stop test validate clean docs build-ghcr push-ghcr version bump-patch bump-minor bump-major

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
	@echo "  build-platform - Build for specific platform"
	@echo "  build-ghcr   - Build for GitHub Container Registry"
	@echo ""
	@echo "Registry Commands:"
	@echo "  push-ghcr    - Build and push to GitHub Container Registry"
	@echo "  login-ghcr   - Login to GitHub Container Registry"
	@echo ""
	@echo "Container Commands:"
	@echo "  start        - Start the mainframe container"
	@echo "  stop         - Stop the mainframe container"
	@echo "  restart      - Restart the mainframe container"
	@echo "  logs         - Show container logs"
	@echo "  shell        - Open shell in running container"
	@echo ""
	@echo "Testing Commands:"
	@echo "  test         - Run all tests"
	@echo "  test-quick   - Run quick validation"
	@echo "  validate     - Validate exercise content"
	@echo ""
	@echo "Development Commands:"
	@echo "  clean        - Clean up containers and images"
	@echo "  docs         - Generate documentation"
	@echo "  lint         - Run linting checks"
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
	@./scripts/build/build.sh

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
	@docker-compose up -d

stop:
	@echo "Stopping TK4-Hercules mainframe..."
	@docker-compose down

restart: stop start
	@echo "Restarted TK4-Hercules mainframe"

logs:
	@docker-compose logs -f

shell:
	@docker-compose exec tk4-hercules /bin/bash

# Testing commands
test:
	@echo "Running comprehensive tests..."
	@./scripts/test/test-exercises.sh

test-quick:
	@echo "Running quick validation..."
	@./scripts/validation/quick-validate.sh

validate:
	@echo "Validating exercise content..."
	@./scripts/validation/validate-exercises.sh

# Development commands
clean:
	@echo "Cleaning up containers and images..."
	@docker-compose down -v
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

# Development workflow
dev-setup: build start
	@echo "Development environment ready!"
	@echo "Connect to mainframe: telnet localhost 3270"
	@echo "Web console: http://localhost:8038"

dev-clean: stop clean
	@echo "Development environment cleaned"

# CI/CD helpers
ci-test: build test
	@echo "CI tests completed"

ci-validate: validate
	@echo "CI validation completed"

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
	@docker-compose config
	@echo "✅ CI linting checks completed"

ci-full: ci-lint ci-validate ci-test
	@echo "✅ Full CI pipeline completed"

# Release helpers
release-prep: test validate
	@echo "Release preparation completed"

# Utility commands
status:
	@echo "Container status:"
	@docker-compose ps
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
	@echo "- docs/LEARNING_GUIDE.md: Educational content"
	@echo "- docs/TESTING.md: Testing procedures"
	@echo "- CONTRIBUTING.md: How to contribute"
	@echo ""
	@echo "Scripts:"
	@echo "- scripts/build/: Build scripts"
	@echo "- scripts/test/: Test scripts"
	@echo "- scripts/validation/: Validation scripts" 