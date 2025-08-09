# TK4-Hercules Testing Guide

This document describes the testing strategy for the TK4-Hercules project, which has been simplified to focus on essential functionality while maintaining quality assurance.

## Test Structure Overview

The testing framework has been streamlined to include only the most important tests:

### Essential Tests (`scripts/test/test-exercises.sh`)
- **Purpose**: Core functionality validation
- **Scope**: Exercise files, container startup, basic connectivity
- **Duration**: ~2 minutes
- **Use Case**: Primary test suite for development and CI

### Quick Validation (`scripts/validation/quick-validate.sh`)
- **Purpose**: Fast file structure validation
- **Scope**: Exercise file existence and basic content structure
- **Duration**: ~30 seconds
- **Use Case**: CI/CD pipeline, pre-commit checks

### ARM64 Support (`scripts/test/test-arm64.sh`)
- **Purpose**: Multi-platform compatibility
- **Scope**: ARM64 architecture support
- **Duration**: ~3 minutes
- **Use Case**: Platform-specific testing

### Basic Container Test (`scripts/test/test.sh`)
- **Purpose**: Docker container functionality
- **Scope**: Image building, container startup, port accessibility
- **Duration**: ~1 minute
- **Use Case**: Container validation

### Exercise Validation (`scripts/validation/validate-exercises.sh`)
- **Purpose**: Content quality assurance
- **Scope**: Exercise content structure and completeness
- **Duration**: ~1 minute
- **Use Case**: Content review and quality checks

## Running Tests

### Local Development
```bash
# Run essential tests (recommended for development)
make test

# Run quick validation
make test-quick

# Run full local test suite
make test-local

# Test ARM64 support
make test-arm64

# Validate exercise content
make validate
```

### CI/CD Pipeline
```bash
# Quick validation for CI
make test-quick

# Essential tests for CI
make test

# Full CI pipeline
make ci-full
```

## Test Categories

### 1. Essential Tests (Primary)
These tests validate the core functionality that must work for the project to be useful:

- **Exercise File Structure**: Ensures all required exercise files exist
- **Container Startup**: Validates Docker container can start successfully
- **Mainframe Connectivity**: Tests web interface and 3270 terminal access
- **Basic Health Checks**: Verifies container is running and responsive

### 2. Quick Validation (Secondary)
Fast checks for file structure and basic content:

- **File Existence**: Checks for required exercise files
- **Content Structure**: Validates basic markdown structure
- **No Container Required**: Can run without Docker

### 3. Platform Tests (Specialized)
Architecture-specific validation:

- **ARM64 Support**: Tests compatibility with ARM64 processors
- **Multi-platform Build**: Validates cross-platform builds

### 4. Content Validation (Quality)
Content quality and completeness checks:

- **Exercise Completeness**: Ensures exercises have required sections
- **Content Structure**: Validates markdown formatting
- **Navigation**: Checks for proper exercise flow

## Removed Tests

The following complex tests were removed to simplify the testing framework:

- **Interactive TSO Commands**: Required complex session management
- **JCL Job Submission**: Needed extensive mainframe setup
- **File Operations**: Required interactive TSO sessions
- **Programming Environment**: Needed compiler setup and configuration
- **System Administration**: Required admin privileges
- **Database Operations**: Needed database setup
- **Networking Tests**: Required network configuration
- **File Transfer**: Needed complex file transfer setup

## Test Configuration

### Timeouts
- **Essential Tests**: 120 seconds
- **Quick Validation**: 30 seconds
- **ARM64 Tests**: 180 seconds

### Logging
All tests generate detailed logs in:
- `exercise-test-results.log` - Essential test results
- Console output with color-coded results

### Exit Codes
- **0**: All tests passed
- **1**: Some tests failed
- **2**: Test setup failed

## Best Practices

### For Developers
1. Run `make test-quick` before committing
2. Run `make test` for comprehensive validation
3. Run `make test-arm64` if working on ARM64 support
4. Check logs for detailed failure information

### For CI/CD
1. Use `make test-quick` for fast feedback
2. Use `make test` for thorough validation
3. Use `make ci-full` for complete pipeline
4. Monitor test duration and optimize as needed

### For Content Contributors
1. Run `make validate` to check exercise content
2. Ensure all required sections are present
3. Test navigation flow between exercises
4. Validate markdown formatting

## Troubleshooting

### Common Issues

**Container won't start**
```bash
# Check Docker status
docker ps -a

# Check container logs
docker compose logs

# Clean up and retry
make clean
make test
```

**Tests timeout**
```bash
# Increase timeout in test script
# Check system resources
# Verify Docker has sufficient memory/CPU
```

**ARM64 tests fail**
```bash
# Verify you're on ARM64 platform
uname -m

# Check Docker platform support
docker buildx ls

# Run debug version if available
```

### Getting Help

1. Check the test logs for detailed error messages
2. Verify Docker and system requirements
3. Review the troubleshooting section in README.md
4. Open an issue with test logs attached

## Future Enhancements

The simplified test structure provides a foundation for future enhancements:

- **Performance Tests**: Measure container startup time
- **Security Tests**: Validate container security
- **Integration Tests**: Test with external tools
- **Load Tests**: Validate under different loads
- **Automated UI Tests**: Test web interface functionality

## Conclusion

The simplified testing framework focuses on essential functionality while maintaining quality assurance. This approach provides:

- **Faster feedback**: Reduced test execution time
- **Better maintainability**: Fewer complex test scenarios
- **Improved reliability**: More focused test coverage
- **Easier debugging**: Clearer test results and logs

By focusing on core functionality, the tests are more reliable and provide better value for development and CI/CD workflows. 