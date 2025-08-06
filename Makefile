# TKX-Hercules Makefile
# Common development tasks for the project

.PHONY: help build build-platform build-multi start stop test test-arm64 validate clean docs build-ghcr push-ghcr version bump-patch bump-minor bump-major

# Version management
VERSION := $(shell cat VERSION)

# Default target
help:
	@echo "TKX-Hercules Development Commands"
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
	@echo "  build-multi  - Build multi-platform images (AMD64 + ARM64)"
	@echo "  build-ghcr   - Build for GitHub Container Registry"
	@echo "  fix-arm64    - Fix ARM64 compatibility issues"
	@echo "  start-arm64  - Start with ARM64 workaround"
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
	@echo "  test-arm64   - Test ARM64 support"
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
	@echo "Building TKX-Hercules container..."
	@./scripts/build/build.sh

build-platform:
	@echo "Building for specific platform..."
	@./scripts/build/build-platform.sh

build-multi:
	@echo "Building multi-platform images..."
	@./scripts/build/build-multi-platform.sh

build-ghcr:
	@echo "Building for GitHub Container Registry..."
	@./scripts/build/build-ghcr.sh --no-prompt

fix-arm64:
	@echo "Fixing ARM64 compatibility issues..."
	@./scripts/build/fix-arm64.sh

start-arm64:
	@echo "Starting TKX-Hercules with ARM64 workaround..."
	@./scripts/start-arm64.sh

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
	@echo "Starting TKX-Hercules mainframe..."
	@echo "Building local image if needed..."
	@docker build --platform linux/amd64 -t tkx-hercules:latest .
	@echo "Starting container with local image..."
	@docker run -d --name tkx-hercules \
		--platform linux/amd64 \
		-p 3270:3270 \
		-p 8038:8038 \
		-v tk4-conf:/tk4-/conf \
		-v tk4-local_conf:/tk4-/local_conf \
		-v tk4-local_scripts:/tk4-/local_scripts \
		-v tk4-prt:/tk4-/prt \
		-v tk4-dasd:/tk4-/dasd \
		-v tk4-pch:/tk4-/pch \
		-v tk4-jcl:/tk4-/jcl \
		-v tk4-log:/tk4-/log \
		--restart unless-stopped \
		--memory=2g \
		--cpus=2.0 \
		tkx-hercules:latest

stop:
	@echo "Stopping TKX-Hercules mainframe..."
	@docker stop tkx-hercules 2>/dev/null || true
	@docker rm tkx-hercules 2>/dev/null || true

restart: stop start
	@echo "Restarted TKX-Hercules mainframe"

logs:
	@docker logs -f tkx-hercules

shell:
	@docker exec -it tkx-hercules /bin/bash

# Testing commands
test:
	@echo "Running essential tests (core functionality)..."
	@echo "This tests:"
	@echo "  - Exercise file structure"
	@echo "  - Container startup and connectivity"
	@echo "  - Basic mainframe functionality"
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

test-arm64:
	@echo "Testing ARM64 support..."
	@./scripts/test/test-arm64.sh

validate:
	@echo "Validating exercise content..."
	@./scripts/validation/validate-exercises.sh

# Development commands
clean:
	@echo "Cleaning up containers and images..."
	@docker compose down -v
	@docker rmi tkx-hercules:latest 2>/dev/null || true
	@docker rmi ghcr.io/skunklabz/tkx-hercules:latest 2>/dev/null || true
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
	@docker compose config
	@echo "✅ CI linting checks completed"

ci-full: ci-lint ci-validate ci-test
	@echo "✅ Full CI pipeline completed"

# Release helpers
release-prep: test validate
	@echo "Release preparation completed"

# Multi-version support
build-tk4:
	@echo "Building TK4- version..."
	@MVS_VERSION=tk4 docker-compose build

build-tk5:
	@echo "Building TK5- version..."
	@MVS_VERSION=tk5 docker-compose build

build-tk5-external:
	@echo "Building TK5- External version..."
	@MVS_VERSION=tk5-external docker-compose build

start-tk4:
	@echo "Starting TK4- version..."
	@MVS_VERSION=tk4 docker-compose up -d

start-tk5:
	@echo "Starting TK5- version..."
	@MVS_VERSION=tk5 docker-compose up -d

start-tk5-external:
	@echo "Starting TK5- External version..."
	@MVS_VERSION=tk5-external docker-compose up -d

test-tk4:
	@echo "Testing TK4- version..."
	@MVS_VERSION=tk4 make test

test-tk5:
	@echo "Testing TK5- version..."
	@MVS_VERSION=tk5 make test

test-tk5-external:
	@echo "Testing TK5- External version..."
	@MVS_VERSION=tk5-external make test

stop-tk4:
	@echo "Stopping TK4- version..."
	@MVS_VERSION=tk4 docker-compose down

stop-tk5:
	@echo "Stopping TK5- version..."
	@MVS_VERSION=tk5 docker-compose down

stop-tk5-external:
	@echo "Stopping TK5- External version..."
	@MVS_VERSION=tk5-external docker-compose down

logs-tk4:
	@echo "Showing TK4- logs..."
	@MVS_VERSION=tk4 docker-compose logs -f

logs-tk5:
	@echo "Showing TK5- logs..."
	@MVS_VERSION=tk5 docker-compose logs -f

logs-tk5-external:
	@echo "Showing TK5- External logs..."
	@MVS_VERSION=tk5-external docker-compose logs -f

# Default version (TK4- for backward compatibility)
build: build-tk4
start: start-tk4
stop: stop-tk4
logs: logs-tk4

# Utility commands
status:
	@echo "Container status:"
	@docker compose ps
	@echo ""
	@echo "Port status:"
	@echo "3270 (Terminal): $(shell netstat -an 2>/dev/null | grep :3270 || echo 'Not listening')"
	@echo "8038 (Web): $(shell netstat -an 2>/dev/null | grep :8038 || echo 'Not listening')"

info:
	@echo "TKX-Hercules Project Information"
	@echo "================================"
	@echo "Version: $(VERSION)"
	@echo "Mainframe: IBM MVS 3.8j (TK4- and TK5-)"
	@echo "Emulator: Hercules"
	@echo "Container: Docker"
	@echo "Registry: GitHub Container Registry (ghcr.io)"
	@echo ""
	@echo "Available Versions:"
	@echo "- TK4-: Original Turnkey 4- system (8 volumes)"
	@echo "- TK5-: Enhanced Turnkey 5- system (15 volumes)"
	@echo "- TK5- External: AMD64-compatible TK5- system (15 volumes)"
	@echo ""
	@echo "Usage:"
	@echo "- make start-tk4: Start TK4- version (default)"
	@echo "- make start-tk5: Start TK5- version"
	@echo "- make start-tk5-external: Start TK5- External version (AMD64 compatible)"
	@echo "- make build-tk4: Build TK4- image"
	@echo "- make build-tk5: Build TK5- image"
	@echo "- make build-tk5-external: Build TK5- External image"
	@echo ""
	@echo "Documentation:"
	@echo "- README.md: Quick start guide"
	@echo "- docs/TKX_MIGRATION_PLAN.md: Migration strategy"
	@echo "- docs/TK5_TECHNICAL_SPECS.md: TK5- specifications"
	@echo "- docs/ATTRIBUTIONS.md: Credits and acknowledgments"
	@echo ""
	@echo "Scripts:"
	@echo "- scripts/build/: Build scripts"
	@echo "- scripts/test/: Test scripts"
	@echo "- scripts/validation/: Validation scripts" 