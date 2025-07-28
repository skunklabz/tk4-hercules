# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Docker image optimization documentation (docs/IMAGE_OPTIMIZATION.md)
- Comprehensive .dockerignore file for build context optimization

### Changed
- **BREAKING**: Switched base image from Ubuntu 22.04 to Alpine Linux 3.19
- Optimized Docker image size from 1.06GB to 427MB (60% reduction)
- Improved multi-stage build with better layer optimization
- Removed unnecessary platform binaries (Darwin, Windows, ARM)
- Removed documentation and demo files from final image
- Updated build scripts to reflect Alpine base image
- Enhanced package management with Alpine's apk

### Performance
- 60% reduction in Docker image size (1.06GB → 427MB)
- 77% faster build times (~30s → ~7s)
- Reduced bandwidth usage for deployments
- Lower storage costs and improved CI/CD performance

### Fixed
- Updated script paths in documentation

## [1.1.0] - 2025-07-27

### Added
- Repository restructuring for better organization
- Comprehensive CONTRIBUTING.md guide
- CHANGELOG.md for version tracking
- Organized scripts into build, test, and validation directories
- Moved documentation to dedicated docs/ directory
- Moved exercises to examples/ directory
- GitHub Actions CI/CD workflows
- Makefile for development tasks
- Issue and PR templates
- Security policy and code of conduct
- MIT License
- Comprehensive .gitignore
- Project structure documentation

### Changed
- Improved project structure following common standards
- Enhanced documentation organization
- Better separation of concerns in directory structure
- Updated README.md with new structure and commands
- Reorganized all scripts into logical subdirectories

### Fixed
- Updated script paths in documentation
- Fixed .gitignore to properly include scripts/build directory

## [1.0.0] - 2024-01-XX

### Added
- Initial release of TK4-Hercules containerized mainframe
- Hercules emulator with IBM MVS 3.8j (Turnkey 4-)
- Docker containerization for easy deployment
- Educational exercises and learning materials
- 3270 terminal access and web console
- Comprehensive testing suite
- Build and validation scripts

### Features
- Multi-user mainframe environment
- JCL job processing capabilities
- TSO interactive sessions
- File system operations
- Programming environment (COBOL, FORTRAN, Assembler)
- System administration tools
- Networking capabilities (VTAM)
- Database operations (VSAM)

### Documentation
- README.md with installation and usage instructions
- LEARNING_GUIDE.md for educational content
- Exercise tutorials and challenges
- Testing documentation
- Mainframe concept explanations

---

## Version History

- **1.1.0**: Repository restructuring and documentation improvements (2025-07-27)
- **1.0.0**: Initial release with basic mainframe functionality (2024-01-XX)

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 