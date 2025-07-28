# TK4-Hercules Makefile
# Common development tasks for the project

.PHONY: help build start stop test validate clean docs

# Default target
help:
	@echo "TK4-Hercules Development Commands"
	@echo "================================="
	@echo ""
	@echo "Build Commands:"
	@echo "  build        - Build the Docker container"
	@echo "  build-platform - Build for specific platform"
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

# Build commands
build:
	@echo "Building TK4-Hercules container..."
	@./scripts/build/build.sh

build-platform:
	@echo "Building for specific platform..."
	@./scripts/build/build-platform.sh

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
	@echo "Version: 1.0.0"
	@echo "Mainframe: IBM MVS 3.8j (TK4-)"
	@echo "Emulator: Hercules"
	@echo "Container: Docker"
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