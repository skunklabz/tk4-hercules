# Project Structure Documentation

This document provides a detailed explanation of the TK4-Hercules project structure and organization.

## Overview

The TK4-Hercules project follows a well-organized structure that separates concerns and makes the codebase maintainable and scalable. The structure is designed to support both educational content and technical implementation.

## Directory Structure

```
tk4-hercules/
├── .github/                    # GitHub-specific files
│   ├── ISSUE_TEMPLATE/        # Issue templates
│   ├── PULL_REQUEST_TEMPLATE/ # PR templates
│   └── workflows/             # GitHub Actions CI/CD
├── .cursor/                    # Cursor IDE configuration
│   └── rules/                 # Project-specific rules
├── assets/                     # Static assets
│   ├── images/                # Images and screenshots
│   └── configs/               # Configuration templates
├── config/                     # Configuration files
├── docs/                       # Documentation
│   ├── LEARNING_GUIDE.md      # Educational content
│   ├── TESTING.md             # Testing procedures
│   └── PROJECT_STRUCTURE.md   # This file
├── examples/                   # Educational exercises
│   ├── challenges/            # Advanced exercises
│   └── README.md              # Exercise guide
├── scripts/                    # Build and utility scripts
│   ├── build/                 # Build scripts
│   ├── test/                  # Test scripts
│   └── validation/            # Validation scripts
├── tools/                      # Development tools
├── CONTRIBUTING.md            # Contribution guidelines
├── CHANGELOG.md               # Version history
├── CODE_OF_CONDUCT.md         # Community guidelines
├── LICENSE                    # MIT License
├── Makefile                   # Development commands
├── README.md                  # Main project documentation
├── SECURITY.md                # Security policy
├── Dockerfile                 # Container definition
├── docker-compose.yml         # Container orchestration
└── .gitignore                 # Git ignore rules
```

## Directory Details

### `.github/`
Contains GitHub-specific configuration files:
- **ISSUE_TEMPLATE/**: Templates for bug reports and feature requests
- **PULL_REQUEST_TEMPLATE/**: Template for pull requests
- **workflows/**: GitHub Actions CI/CD pipelines

### `.cursor/`
Cursor IDE configuration and project-specific rules:
- **rules/**: Contains project-specific coding standards and guidelines

### `assets/`
Static assets used throughout the project:
- **images/**: Screenshots, diagrams, and visual assets
- **configs/**: Configuration templates and examples

### `config/`
Configuration files for the project:
- Environment-specific configurations
- Build configurations
- Development settings

### `docs/`
Project documentation:
- **LEARNING_GUIDE.md**: Comprehensive educational content
- **TESTING.md**: Testing procedures and guidelines
- **PROJECT_STRUCTURE.md**: This file

### `examples/`
Educational exercises and examples:
- **challenges/**: Advanced exercises for experienced users
- **README.md**: Guide to the exercises

### `scripts/`
Build and utility scripts organized by function:
- **build/**: Scripts for building the Docker container
- **test/**: Scripts for testing functionality
- **validation/**: Scripts for validating content and structure

### `tools/`
Development tools and utilities:
- Code generators
- Development helpers
- Maintenance scripts

## File Organization Principles

### 1. Separation of Concerns
- **Documentation**: All documentation is in the `docs/` directory
- **Scripts**: Organized by function in `scripts/` subdirectories
- **Examples**: Educational content in `examples/`
- **Configuration**: Build and runtime configs in `config/`

### 2. Clear Naming Conventions
- Use descriptive, lowercase names with hyphens for directories
- Use descriptive, lowercase names with underscores for files
- Follow consistent naming patterns within each directory

### 3. Logical Grouping
- Related files are grouped together
- Common functionality is shared across appropriate directories
- Clear boundaries between different types of content

### 4. Scalability
- Structure supports growth and new features
- Easy to add new documentation, scripts, or examples
- Maintains organization as the project evolves

## Script Organization

### Build Scripts (`scripts/build/`)
- **build.sh**: Main build script
- **build-platform.sh**: Platform-specific builds
- **download-tk4.sh**: TK4- distribution download

### Test Scripts (`scripts/test/`)
- **test.sh**: Main test script
- **test-exercises.sh**: Comprehensive exercise testing
- **exercise-test-results.log**: Test output

### Validation Scripts (`scripts/validation/`)
- **quick-validate.sh**: Quick content validation
- **validate-exercises.sh**: Comprehensive exercise validation

## Documentation Organization

### Main Documentation
- **README.md**: Project overview and quick start
- **CONTRIBUTING.md**: How to contribute
- **CHANGELOG.md**: Version history
- **SECURITY.md**: Security policy
- **CODE_OF_CONDUCT.md**: Community guidelines

### Technical Documentation
- **docs/LEARNING_GUIDE.md**: Educational content
- **docs/TESTING.md**: Testing procedures
- **docs/PROJECT_STRUCTURE.md**: This file

## Configuration Management

### Docker Configuration
- **Dockerfile**: Container definition
- **docker-compose.yml**: Container orchestration
- **.dockerignore**: Files to exclude from Docker build

### Development Configuration
- **Makefile**: Common development tasks
- **.gitignore**: Files to exclude from version control
- **.cursor/rules/**: IDE-specific rules

## Best Practices

### 1. File Placement
- Put new scripts in the appropriate `scripts/` subdirectory
- Add new documentation to `docs/`
- Place new exercises in `examples/`
- Store configuration templates in `config/`

### 2. Naming Conventions
- Use descriptive names that indicate purpose
- Follow existing patterns in each directory
- Use consistent file extensions

### 3. Documentation
- Document new directories and files
- Update this file when adding new directories
- Include examples and usage instructions

### 4. Maintenance
- Keep the structure organized as the project grows
- Remove unused files and directories
- Update documentation when structure changes

## Migration Guide

When moving from the old structure to this new structure:

1. **Scripts**: Moved from root to `scripts/` subdirectories
2. **Documentation**: Moved from root to `docs/`
3. **Exercises**: Moved from `exercises/` to `examples/`
4. **New files**: Added standard open source project files

### Path Updates
- `./build.sh` → `make build` or `./scripts/build/build.sh`
- `./test.sh` → `make test` or `./scripts/test/test.sh`
- `LEARNING_GUIDE.md` → `docs/LEARNING_GUIDE.md`
- `exercises/` → `examples/`

## Future Considerations

### Potential Additions
- **api/**: API documentation if needed
- **deploy/**: Deployment configurations
- **monitoring/**: Monitoring and logging configurations
- **security/**: Security-related files and policies

### Scalability
- Structure supports adding new mainframe systems
- Easy to extend with additional educational content
- Maintains organization as complexity grows

This structure provides a solid foundation for the TK4-Hercules project while maintaining clarity and organization as it continues to grow and evolve. 