# Semantic Versioning (SemVer) Guide

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html) for version management.

## Version Format

Versions follow the format: `MAJOR.MINOR.PATCH`

- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality in a backward-compatible manner
- **PATCH**: Backward-compatible bug fixes

## Version Management

### Current Version
The current version is stored in the `VERSION` file at the root of the project.

### Version Bumping Commands

Use the Makefile commands to bump versions:

```bash
# Show current version
make version

# Bump patch version (1.1.0 → 1.1.1)
make bump-patch

# Bump minor version (1.1.0 → 1.2.0)
make bump-minor

# Bump major version (1.1.0 → 2.0.0)
make bump-major
```

### When to Bump Versions

#### Patch (1.1.0 → 1.1.1)
- Bug fixes
- Documentation updates
- Minor improvements
- Security patches
- Build system changes

#### Minor (1.1.0 → 1.2.0)
- New features
- New exercises or tutorials
- New mainframe capabilities
- Backward-compatible enhancements
- New documentation sections

#### Major (1.1.0 → 2.0.0)
- Breaking changes to Docker configuration
- Changes to mainframe setup
- Incompatible API changes
- Major architectural changes
- Breaking changes to scripts or tools

## Release Process

### Automated Release (Recommended)
The project uses automated releases triggered by pushes to the main branch:

1. **Push to main**: Automatically triggers release workflow
2. **Version bump**: Patch version is automatically incremented
3. **Docker build**: Multi-platform image is built and pushed to GHCR
4. **Git tag**: New version tag is created and pushed
5. **GitHub release**: Release is created with changelog notes

**Example workflow:**
```bash
# Make your changes
git add .
git commit -m "feat: add new mainframe exercise"
git push origin main

# The release workflow automatically:
# - Bumps version from 1.1.0 → 1.1.1
# - Builds and pushes Docker image
# - Creates Git tag v1.1.1
# - Creates GitHub release
```

### Manual Release
For major or minor version bumps, use the manual workflow:

1. Go to Actions → Release workflow
2. Click "Run workflow"
3. Select version bump type (patch/minor/major)
4. The workflow will handle the entire release process

### Release Workflow Details

The release workflow (`/.github/workflows/release.yml`) performs these steps:

1. **Version Management**:
   - Reads current version from `VERSION` file
   - Calculates new version based on bump type
   - Updates `VERSION` file and `CHANGELOG.md`

2. **Docker Build**:
   - Builds multi-platform image (AMD64 + ARM64)
   - Pushes to GitHub Container Registry
   - Tags: `latest`, `main`, and version-specific tag

3. **Git Operations**:
   - Commits version changes
   - Creates and pushes Git tag
   - Creates GitHub release with changelog notes

4. **Post-Release**:
   - Runs validation tests
   - Provides release URLs and information

## CHANGELOG.md Format

Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format:

```markdown
## [Unreleased]

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security vulnerability fixes
```

## Version History

### 1.1.0 (2025-07-27)
- Repository restructuring
- Comprehensive documentation
- GitHub Actions CI/CD
- Trunk-based development implementation

### 1.0.0 (2024-01-XX)
- Initial release
- Basic mainframe functionality
- Docker containerization
- Educational exercises

## Best Practices

### For Contributors
1. **Document changes**: Always update CHANGELOG.md with your changes
2. **Use conventional commits**: Follow conventional commit format
3. **Test thoroughly**: Ensure all tests pass before version bump
4. **Review changes**: Get code review before merging

### For Maintainers
1. **Regular releases**: Release frequently with small changes
2. **Clear communication**: Document breaking changes clearly
3. **Backward compatibility**: Maintain compatibility when possible
4. **Automated testing**: Ensure CI/CD validates all changes

### Version Bumping Guidelines
- **Patch**: For bug fixes and minor improvements
- **Minor**: For new features and enhancements
- **Major**: For breaking changes and major refactoring

## Integration with CI/CD

The GitHub Actions workflows automatically:
- Read version from `VERSION` file
- Tag Docker images with version
- Create GitHub releases with proper tags
- Update documentation with current version

## Troubleshooting

### Common Issues
1. **Version file not found**: Ensure `VERSION` file exists in project root
2. **Invalid version format**: Ensure version follows SemVer format (X.Y.Z)
3. **Tag conflicts**: Delete existing tag if recreating release
4. **CHANGELOG format**: Follow Keep a Changelog format strictly

### Version Validation
The CI pipeline validates:
- Version format compliance
- CHANGELOG.md format
- Version consistency across files
- Git tag format

## References

- [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html)
- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- [Conventional Commits](https://www.conventionalcommits.org/) 