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

### Manual Release
1. **Bump version**: Use appropriate `make bump-*` command
2. **Update CHANGELOG.md**: Add new version entry with changes
3. **Commit changes**: `git add VERSION CHANGELOG.md && git commit -m "chore: bump version to X.Y.Z"`
4. **Create tag**: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
5. **Push**: `git push origin main && git push origin vX.Y.Z`

### Automated Release
Use GitHub Actions workflow for automated releases:

1. Go to Actions → Release workflow
2. Click "Run workflow"
3. Select version bump type (patch/minor/major)
4. The workflow will:
   - Bump version automatically
   - Update CHANGELOG.md
   - Build and push Docker image
   - Create Git tag
   - Create GitHub release

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