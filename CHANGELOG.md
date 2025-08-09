# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.3.0] - 2025-08-09

### Changed
- Refactored the project to simplify the build process and remove unnecessary components.
- Collapsed the `versions/` directory into the root, making the project a single-version setup.
- Updated the `Makefile` to use standard `docker compose` commands.
- The `Dockerfile` was cleaned up and now starts the application by default.

### Removed
- Removed the `web-app/` directory, which was an unused component.
- Removed the `.cursor/` IDE-specific directory.

## [1.2.2] - 2025-08-08

### Fixed
- Resolve release workflow failure by bumping version to avoid tag collision.

## [1.2.0] - 2025-01-XX

### Added
- **Version Management**: Centralized version control with VERSION file

### Changed
- Converted repository to TK4-only (removed TK5 content and references)
- **Documentation**: Updated README and attributions to reflect TK4-only state
- **Version Bump**: Incremented to 1.2.0 for significant repository change

### Fixed
- **Repository References**: Updated all references to tk4-hercules
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