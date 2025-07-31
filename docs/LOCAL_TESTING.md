# Local Testing Guide

This guide explains how to test your changes locally before pushing to remote, ensuring code quality and preventing CI/CD failures.

## Quick Start

### 1. Run Local Tests
```bash
# Run full local test suite (recommended for pre-commit)
make test-local

# Or run the script directly
./scripts/test-local.sh
```

### 2. Test Ports and Services
```bash
# Test port connectivity (basic port validation)
make test-ports

# Or run the script directly
./scripts/test-ports.sh
```

### 3. Test Full MVS Services
```bash
# Test full MVS system with actual services (comprehensive)
make test-full

# Or run the script directly
./scripts/test-full-services.sh
```

### 4. Run Pre-commit Checks
```bash
# Run pre-commit validation
make pre-commit

# Or run the script directly
./scripts/pre-commit.sh
```

### 5. Set Up Automatic Testing
```bash
# Install git hooks for automatic testing
make setup-hooks
```

## Testing Levels

### 🚀 **Level 1: Basic Local Tests (`test-local`)**
**Purpose**: Fast validation for pre-commit checks
**Duration**: ~2 minutes

**What it tests**:
- ✅ **Docker build validation** - Ensures the Docker image builds successfully
- ✅ **Container startup testing** - Verifies the container starts and runs properly
- ✅ **Port 3270 connectivity** - Tests 3270 terminal port accessibility
- ✅ **Multi-platform build test** - Tests builds for both amd64 and arm64 (if buildx available)
- ✅ **Workflow file validation** - Checks GitHub Actions workflow syntax
- ✅ **Essential file checks** - Verifies VERSION, README.md, Dockerfile, etc.

**Note**: Web console (port 8038) is not tested in this mode as it requires full MVS startup.

### 🔌 **Level 2: Port Testing (`test-ports`)**
**Purpose**: Test port connectivity and basic services
**Duration**: ~1 minute

**What it tests**:
- ✅ **Port 3270 connectivity** - Tests 3270 terminal port
- ✅ **Port 8038 connectivity** - Tests web console port
- ✅ **Service availability** - Checks if services are accessible
- ✅ **Container status** - Shows running container information

**Note**: Uses existing container or starts a test container.

### 🎯 **Level 3: Full Service Testing (`test-full`)**
**Purpose**: Comprehensive testing with actual MVS system
**Duration**: ~5-10 minutes

**What it tests**:
- ✅ **Full MVS system startup** - Starts the actual mainframe system
- ✅ **3270 terminal functionality** - Tests complete 3270 service
- ✅ **Web console functionality** - Tests web interface with content validation
- ✅ **Service readiness** - Waits for services to be fully operational
- ✅ **Long-term stability** - Tests services over extended period

**Note**: This is the most comprehensive test but takes longer to complete.

## What Gets Tested

### Pre-commit Checks (`pre-commit`)
- ✅ **Quick file validation** - Checks essential files exist and are valid
- ✅ **Docker availability** - Ensures Docker is running
- ✅ **Full local test suite** - Runs all Level 1 tests
- ✅ **Commit blocking** - Prevents commits if tests fail

## Workflow Integration

### Manual Testing
```bash
# Before pushing changes (recommended workflow)
make test-local
make pre-commit

# If all tests pass, commit and push
git add .
git commit -m "your changes"
git push origin main
```

### Automatic Testing (Recommended)
```bash
# Set up git hooks once
make setup-hooks

# Now every commit automatically runs tests
git add .
git commit -m "your changes"  # Tests run automatically
git push origin main
```

### Comprehensive Testing
```bash
# For major changes or before releases
make test-full

# This will start the actual MVS system and test all services
```

## What the Tests Do

### Docker Build Test
1. Builds the Docker image locally
2. Verifies the build completes successfully
3. Tests container startup and basic functionality
4. Checks multi-platform builds (if available)

### Container Test
1. Starts the container in detached mode
2. Waits for startup (5-10 seconds)
3. Verifies container is running
4. Checks container logs for errors
5. Cleans up test container

### Port Validation Test
1. Tests port 3270 (3270 terminal) connectivity
2. Tests port 8038 (web console) accessibility
3. Validates service responses
4. Checks for proper content delivery

### Full Service Test
1. Starts actual MVS system
2. Waits for services to be ready (up to 5 minutes)
3. Tests 3270 terminal with full functionality
4. Tests web console with content validation
5. Validates long-term service stability

### File Validation
1. Checks VERSION file exists and has content
2. Verifies essential files (README.md, Dockerfile, docker-compose.yml)
3. Validates GitHub Actions workflow syntax
4. Ensures proper project structure

## Troubleshooting

### Docker Not Running
```bash
# Start Docker Desktop or Docker daemon
# Then run tests again
make test-local
```

### Build Failures
```bash
# Check Dockerfile syntax
docker build -t test .

# Check for missing files
ls -la Dockerfile docker-compose.yml VERSION
```

### Container Startup Issues
```bash
# Check container logs
docker logs test-tk4-local

# Verify Docker has enough resources
docker system info
```

### Port Testing Issues
```bash
# Check if ports are in use
netstat -an | grep -E "3270|8038"

# Test specific port
nc -z localhost 3270
curl -I http://localhost:8038
```

### Full Service Test Issues
```bash
# Check if MVS system is starting properly
docker logs test-tk4-full

# Verify system has enough resources
docker stats test-tk4-full
```

### Bypass Tests (Not Recommended)
```bash
# Only use in emergencies
git commit --no-verify -m "emergency fix"
```

## CI/CD Integration

The local tests mirror what happens in CI/CD:

- **Local**: `make test-local` → **CI**: `docker-build.yml`
- **Local**: `make pre-commit` → **CI**: Pre-commit validation
- **Local**: Docker build → **CI**: Multi-platform build and push

## Best Practices

1. **Always test locally first** - Don't rely on CI to catch issues
2. **Use git hooks** - Automatic testing prevents bad commits
3. **Run tests before pushing** - Ensures remote builds succeed
4. **Use appropriate test level** - Level 1 for quick checks, Level 3 for comprehensive testing
5. **Check logs on failures** - Understand what went wrong
6. **Keep tests fast** - Level 1 tests should complete in <2 minutes

## Scripts Overview

| Script | Purpose | When to Use | Duration |
|--------|---------|-------------|----------|
| `scripts/test-local.sh` | Level 1: Basic validation | Pre-commit, quick checks | ~2 min |
| `scripts/test-ports.sh` | Level 2: Port testing | Service validation | ~1 min |
| `scripts/test-full-services.sh` | Level 3: Full MVS testing | Comprehensive testing | ~5-10 min |
| `scripts/pre-commit.sh` | Pre-commit validation | Before every commit | ~2 min |
| `scripts/setup-hooks.sh` | Install git hooks | One-time setup | <1 min |

## Makefile Targets

| Target | Command | Description | Level |
|--------|---------|-------------|-------|
| `test-local` | `make test-local` | Run basic local test suite | 1 |
| `test-ports` | `make test-ports` | Test ports and services | 2 |
| `test-full` | `make test-full` | Test full MVS services | 3 |
| `pre-commit` | `make pre-commit` | Run pre-commit checks | 1 |
| `setup-hooks` | `make setup-hooks` | Install git hooks | - |

## Success Indicators

✅ **All tests pass** - You're ready to push
✅ **Container starts successfully** - Docker image is working
✅ **Port 3270 accessible** - 3270 terminal service is working
✅ **Port 8038 accessible** - Web console service is working (Level 3)
✅ **Multi-platform builds** - Compatible with different architectures
✅ **No syntax errors** - Workflows and files are valid
✅ **Essential files present** - Project structure is correct

## Service Access

After successful tests, you can access the services:

### Level 1 & 2 Tests
- **3270 Terminal**: `telnet localhost 3270` (if container is running)

### Level 3 Tests (Full MVS)
- **🌐 Web Console**: http://localhost:8038
- **💻 3270 Terminal**: `telnet localhost 3270`
- **📋 3270 Emulator**: Use a 3270 terminal emulator to connect to `localhost:3270`

## Next Steps

After local tests pass:
1. Commit your changes: `git commit -m "your message"`
2. Push to remote: `git push origin main`
3. CI/CD will run the same tests remotely
4. If CI passes, your changes are deployed

This ensures a smooth development workflow with confidence that your changes will work in production.

## Local Development

The project is configured to use **local images only** - no Docker Hub or external registries required:

```bash
# Start the mainframe (builds and uses local image)
make start

# Stop the mainframe
make stop

# Restart the mainframe
make restart

# View logs
make logs

# Access shell
make shell
```

All commands use the locally built `tk4-hercules:latest` image, ensuring you're always working with your latest changes. 