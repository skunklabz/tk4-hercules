# Testing Guide for TK4-Hercules LMS

This document explains how to run tests for the TK4-Hercules LMS web application using Docker containers.

## Overview

The test suite includes:
- **Unit Tests**: Jest-based tests for individual functions and components
- **Integration Tests**: Playwright-based end-to-end tests for the web application
- **Hercules Emulator**: TK4 mainframe emulator running in a container
- **LMS Web Application**: Web application running in a container

All components run headless and communicate via Docker networking.

## Prerequisites

- Docker and Docker Compose installed
- At least 4GB of available memory for test containers (Hercules emulator requires 2GB)
- AMD64 architecture (Hercules emulator is AMD64 only)

## Quick Start

### Run All Tests
```bash
# Using the test runner script (recommended)
./scripts/run-tests.sh

# Or using npm scripts
npm run test:docker
```

### Run Unit Tests Only
```bash
# Using the test runner script
./scripts/run-tests.sh --unit

# Or using npm scripts
npm run test:docker:unit
```

### Run Integration Tests Only
```bash
# Using the test runner script
./scripts/run-tests.sh --integration

# Or using npm scripts
npm run test:docker:integration
```

### Debug Mode
```bash
# Using the test runner script
./scripts/run-tests.sh --debug

# Or using npm scripts
npm run test:docker:debug
```

## Test Runner Script Options

The `./scripts/run-tests.sh` script provides several options:

- `--unit`: Run only Jest unit tests
- `--integration`: Run only Playwright integration tests
- `--debug`: Run tests in debug mode (container stays running)
- `--help` or `-h`: Show help information

## Test Results

After running tests, you'll find results in the following directories:

- **Unit Test Coverage**: `coverage/` - HTML and text coverage reports
- **Integration Test Reports**: `playwright-report/` - HTML test reports
- **Test Results**: `test-results/` - Raw test output and artifacts

## Docker Configuration

### Test Container Structure

The test environment uses multiple containers:

1. **Hercules Emulator**: TK4 mainframe emulator (AMD64, 2GB RAM)
2. **LMS Web Application**: Node.js 18 Alpine with the web application
3. **Test Container**: Node.js 18 Alpine with Chromium for Playwright
4. **Unit Tests**: Isolated container with volume mounts for results

All containers communicate via Docker networking and run headless.

### Docker Compose Profiles

- `unit`: Runs only unit tests (no containers needed)
- `integration`: Runs integration tests with Hercules emulator and LMS app
- `all`: Runs both unit and integration tests with full container stack
- `debug`: Runs tests in debug mode with full container stack

## Local Development

For local development without Docker:

```bash
# Install dependencies
npm install

# Run unit tests
npm run test:unit

# Run integration tests
npm run test

# Run all tests
npm run test:all
```

## Troubleshooting

### Common Issues

1. **Docker not running**
   ```
   Error: Docker is not running
   ```
   Solution: Start Docker Desktop or Docker daemon

2. **Insufficient memory**
   ```
   Error: Container killed due to memory limit
   ```
   Solution: Increase Docker memory allocation to at least 2GB

3. **Port conflicts**
   ```
   Error: Port 3000 already in use
   ```
   Solution: Stop any running instances of the application

4. **Test timeouts**
   ```
   Error: Test timeout exceeded
   ```
   Solution: Increase timeout in `playwright.config.js` or check system resources

### Cleanup

To clean up Docker containers and volumes:

```bash
# Using npm script
npm run test:docker:clean

# Or manually
docker compose -f docker-compose.test.yml down --volumes --remove-orphans
```

## CI/CD Integration

The Docker test setup is designed to work seamlessly with CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Run Tests
  run: |
    cd web-app
    ./scripts/run-tests.sh
```

## Performance Tips

1. **Use volume mounts** for test results to avoid copying large files
2. **Run tests in parallel** when possible (already configured in Playwright)
3. **Clean up containers** after each run to free up resources
4. **Use the Alpine base image** for smaller container size

## Test Environment Variables

The following environment variables are set in the test containers:

- `NODE_ENV=test`: Ensures test-specific configuration
- `CI=true`: Enables CI-specific behavior (retries, parallel limits)
- `PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1`: Uses system Chromium
- `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser`: Points to Alpine's Chromium

## Contributing

When adding new tests:

1. **Unit Tests**: Add to `tests/unit/` directory
2. **Integration Tests**: Add to `tests/` directory (root level)
3. **Update Jest config**: If adding new test patterns
4. **Update Playwright config**: If changing test setup

Remember to run the full test suite before submitting changes:

```bash
./scripts/run-tests.sh
``` 