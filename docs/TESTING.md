# TK4-Hercules Testing Guide

This document explains how to test the TK4-Hercules project and exercises to ensure everything works correctly.

## 🧪 Testing Overview

The project includes multiple testing approaches to validate different aspects:

1. **Quick Validation** - Fast checks of exercise files and content
2. **Functional Testing** - Full testing with running mainframe
3. **Container Testing** - Docker container functionality
4. **Exercise Testing** - Individual exercise validation

## 📋 Available Test Scripts

### Quick Validation (`./scripts/validation/quick-validate.sh`)
**Purpose**: Fast validation of exercise files without running mainframe
**Use Case**: Quick checks during development, CI/CD pipelines
**Time**: ~30 seconds
**Requirements**: None (just filesystem access)

**Tests**:
- ✅ Exercise file structure
- ✅ Required content sections (Objective, Prerequisites, Navigation)
- ✅ Code examples (JCL, TSO)
- ✅ User account documentation
- ✅ Essential command documentation
- ✅ Navigation links

**Usage**:
```bash
./scripts/validation/quick-validate.sh
```

### Functional Testing (`./scripts/test/test-exercises.sh`)
**Purpose**: Comprehensive testing with actual mainframe operations
**Use Case**: Full validation, before releases, quality assurance
**Time**: ~5-10 minutes
**Requirements**: Docker, mainframe container running

**Tests**:
- ✅ Mainframe connectivity and startup
- ✅ User account accessibility
- ✅ TSO command execution
- ✅ File operations (LISTD, BROWSE, ALLOCATE, DELETE)
- ✅ JCL job submission and monitoring
- ✅ Programming environment (COBOL, FORTRAN, Assembler)
- ✅ System administration commands
- ✅ File transfer capabilities
- ✅ Networking and VTAM
- ✅ Database operations (VSAM)

**Usage**:
```bash
./scripts/test/test-exercises.sh
```

### Container Testing (`./scripts/test/test.sh`)
**Purpose**: Test Docker container functionality
**Use Case**: Container health checks, deployment validation
**Time**: ~2-3 minutes
**Requirements**: Docker

**Tests**:
- ✅ Container startup and shutdown
- ✅ Port accessibility (3270, 8038)
- ✅ Basic mainframe boot process
- ✅ Health check endpoints

**Usage**:
```bash
./scripts/test/test.sh
```

## 🎯 Testing Strategy

### Development Workflow
1. **During Development**: Use `./scripts/validation/quick-validate.sh` for fast feedback
2. **Before Commits**: Run `./scripts/test/test-exercises.sh` to ensure functionality
3. **Before Releases**: Run all test suites

### CI/CD Integration
```yaml
# Example GitHub Actions workflow
- name: Quick Validation
  run: ./scripts/validation/quick-validate.sh

- name: Build and Test Container
  run: |
    ./scripts/build/build.sh
    ./scripts/test/test.sh

- name: Functional Testing
  run: ./scripts/test/test-exercises.sh
```

## 📊 Test Results

### Quick Validation Results
```
🔍 Quick TK4-Hercules Exercise Validation
=========================================

📁 Testing exercise files...
✅ PASS: Exercises Directory - Directory exists
✅ PASS: File: exercises/README.md - File exists
...

📖 Testing exercise content...
✅ PASS: Content: exercises/01-first-session.md - Objective - Section found
...

🔗 Testing navigation links...
✅ PASS: Next Links - Next links found
✅ PASS: Previous Links - Previous links found

📊 Validation Results Summary
============================
✅ Passed: 26
❌ Failed: 0
Total Tests: 26
🎉 All validations passed!
```

### Functional Testing Results
```
🧪 TK4-Hercules Exercise Test Suite
===================================

🔌 Testing mainframe connectivity...
✅ PASS: Container Status - Container is running
✅ PASS: Hercules Process - Hercules is running
✅ PASS: 3270 Port - 3270 port is accessible

📁 Testing file operations...
✅ PASS: List current directory - Command executed successfully
✅ PASS: List system datasets - Command executed successfully
...

📊 Test Results Summary
======================
✅ Passed: 45
❌ Failed: 0
⏭️  Skipped: 3
Total Tests: 48
🎉 All critical tests passed!
```

## 🔧 Troubleshooting

### Common Issues

#### Quick Validation Failures
- **Missing Files**: Ensure all exercise files exist
- **Missing Sections**: Check for required sections (Objective, Prerequisites, Navigation)
- **Navigation Links**: Verify Next/Previous links are properly formatted

#### Functional Testing Failures
- **Container Issues**: Check Docker is running and ports are available
- **Mainframe Startup**: Wait longer for mainframe to fully boot
- **Command Timeouts**: Increase timeout values in test script

#### Container Testing Failures
- **Port Conflicts**: Ensure ports 3270 and 8038 are not in use
- **Docker Issues**: Check Docker daemon is running
- **Resource Limits**: Ensure sufficient memory/CPU for container

### Debug Commands
```bash
# Check container status
docker ps

# View container logs
docker-compose logs

# Test port connectivity
telnet localhost 3270

# Check exercise files
ls -la exercises/

# Validate specific exercise
grep -r "Objective" exercises/01-first-session.md
```

## 📈 Test Coverage

### Exercise Coverage
- ✅ **Exercise 1**: First mainframe session
- ✅ **Exercise 2**: File systems and datasets
- ✅ **Exercise 3**: JCL job submission
- ✅ **Exercise 4**: Programming (COBOL, etc.)
- ✅ **Exercise 5**: File transfer
- ✅ **Exercise 6**: System administration
- ✅ **Exercise 7**: Mainframe games
- ✅ **Exercise 8**: Advanced JCL
- ✅ **Exercise 9**: Networking
- ✅ **Exercise 10**: Database operations
- ✅ **Challenges**: Advanced scenarios

### Mainframe Operations Coverage
- ✅ **TSO Commands**: LISTD, BROWSE, ALLOCATE, DELETE
- ✅ **JCL Operations**: Job submission, monitoring, output
- ✅ **File Operations**: Dataset creation, browsing, management
- ✅ **System Commands**: Status, user info, address spaces
- ✅ **Programming**: Compiler availability, code execution
- ✅ **Networking**: VTAM, terminal types, connectivity

## 🚀 Best Practices

### For Developers
1. **Run quick validation frequently** during development
2. **Test with real mainframe** before committing changes
3. **Update tests** when adding new exercises
4. **Document test requirements** for new features

### For Users
1. **Start with quick validation** to check setup
2. **Run functional tests** to verify mainframe operations
3. **Report test failures** with detailed logs
4. **Check troubleshooting guide** for common issues

### For Maintainers
1. **Run all test suites** before releases
2. **Monitor test coverage** and add tests for new features
3. **Update test scripts** when mainframe configuration changes
4. **Maintain test documentation** and troubleshooting guides

## 📚 Additional Resources

- [Main README](README.md) - Project overview and setup
- [Learning Guide](LEARNING_GUIDE.md) - Comprehensive learning materials
- [Exercises Index](exercises/README.md) - Individual exercise guide
- [Hercules Documentation](https://hercules-390.github.io/html/hercoper.html) - Official Hercules guide

---

**Happy testing! 🧪** 