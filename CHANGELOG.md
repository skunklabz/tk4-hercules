# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2025-01-XX

### Added
- **Multi-Version Support**: Complete TK4- and TK5- system support
- **Volume Isolation**: Separate volume namespaces for each version
- **Patrick Raths Attribution**: Proper credit for MVS-TK5 Docker implementation
- **Enhanced Documentation**: Updated attributions and acknowledgments
- **Version Management**: Centralized version control with VERSION file

### Changed
- **Repository Structure**: Organized versions into tk4/ and tk5/ directories
- **Docker Configuration**: Multi-version docker-compose.yml with environment variable support
- **Documentation**: Updated README and attributions to reflect current state
- **Version Bump**: Incremented to 1.2.0 for major multi-version release

### Fixed
- **Attributions**: Proper credit to Patrick Raths for TK5- Docker implementation
- **Repository References**: Updated all tk4-hercules references to tkx-hercules
- **Documentation Cleanup**: Removed outdated references and improved clarity

## [1.1.1] - 2025-01-XX

### Fixed
- Resolved GitHub release conflict for v1.1.0

### Added
- Semantic Versioning (SemVer) implementation with centralized VERSION file
- Automated version bumping commands in Makefile
- Comprehensive SemVer documentation (docs/SEMVER.md)
- Automated release workflow with GitHub Actions
- Version management integration with CI/CD pipeline
- SemVer-aware Cursor rules for automatic version management
- AI assistant guidelines for SemVer-compliant changes

### Changed
- Transitioned to trunk-based development workflow
- Updated GitHub Actions to focus on main branch only
- Centralized version management using VERSION file
- Enhanced release process with automated version bumping
- Improved documentation for version management

### Fixed
- Version consistency across all project files
- Automated version validation in CI pipeline

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