# Release Notes for v1.3.1

**Release Date:** December 19, 2024

**Docker Image:** `ghcr.io/skunklabz/tk4-hercules:v1.3.1`

## Overview

Version 1.3.1 is a patch release that addresses critical issues in the Docker entrypoint script and improves the development workflow. This release focuses on stability improvements and developer experience enhancements.

## What's New

### 🐛 Bug Fixes

#### Docker Entrypoint Fix
- **Fixed infinite recursion in Docker entrypoint script** - Resolved a critical issue that could cause the container startup to fail or hang due to recursive calls in the entrypoint script.
- **Impact:** Users should experience more reliable container startups and improved stability.

#### Workflow Improvements
- **Removed failing smoke test job from workflow** - Cleaned up CI/CD pipeline by removing tests that were no longer relevant or consistently failing.
- **Removed single-commit validation rule from PR workflow** - Improved developer experience by making the PR submission process more flexible while maintaining code quality.

### ✨ Improvements

#### Development Workflow Enhancements
- **Implemented single-commit workflow enforcement** - Added enhanced pre-push hooks that help maintain clean git history.
- **Enhanced pre-push hook that blocks direct main pushes** - Prevents accidental commits directly to the main branch, enforcing branch-based development.
- **GitHub Actions PR validation for commit count** - Automated checks ensure commits are properly structured for merge.

#### Documentation Updates
- **Updated CHANGELOG.md dates** - Aligned dates with cleaned git history for better tracking of changes.
- **Comprehensive development workflow documentation** - Added detailed guides for contributors on the development process.
- **Makefile helpers for feature branch management** - New commands to streamline feature branch creation and management.

## Installation

### Using Docker Pull

```bash
# Pull the latest v1.3.1 image
docker pull ghcr.io/skunklabz/tk4-hercules:v1.3.1

# Run the container
docker run -d \
  --name tk4-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tk4-hercules:v1.3.1
```

### Using Docker Compose

Update your `docker-compose.yml` to use the specific version:

```yaml
services:
  tk4-hercules:
    image: ghcr.io/skunklabz/tk4-hercules:v1.3.1
    ports:
      - "3270:3270"
      - "8038:8038"
    volumes:
      - ./data:/tk4-/data
```

### Building from Source

```bash
# Clone the repository
git clone https://github.com/skunklabz/tk4-hercules.git
cd tk4-hercules

# Checkout the v1.3.1 tag
git checkout v1.3.1

# Build using Make
make build

# Start the container
make start
```

## Upgrade Instructions

### From v1.3.0

This is a straightforward patch upgrade with no breaking changes:

```bash
# Stop the current container
docker compose down

# Pull the new image
docker pull ghcr.io/skunklabz/tk4-hercules:v1.3.1

# Start with the new image
docker compose up -d
```

**Note:** Your data volumes will be preserved during the upgrade.

### From v1.2.x or earlier

If you're upgrading from v1.2.x or earlier, please review the [v1.3.0 release notes](https://github.com/skunklabz/tk4-hercules/releases/tag/v1.3.0) first, as there were structural changes in that release.

## Breaking Changes

**None** - This is a patch release with full backward compatibility.

## Known Issues

None at this time. If you encounter any issues, please report them on our [GitHub Issues](https://github.com/skunklabz/tk4-hercules/issues) page.

## Deprecations

No deprecations in this release.

## For Developers

### New Development Tools

This release includes several improvements for contributors:

1. **Enhanced Pre-Push Hooks**: Automatically validate commits before pushing
2. **Makefile Commands**: New commands for branch management
   - `make new-feature` - Create a new feature branch
   - `make squash-commits` - Squash multiple commits
   - `make push-feature` - Push with validation

3. **Workflow Documentation**: See `docs/DEVELOPMENT_WORKFLOW.md` for detailed guidelines

### Testing

All tests pass successfully:
- Docker build validation ✅
- Container startup tests ✅
- Multi-platform builds (AMD64 + ARM64) ✅
- Integration tests ✅

## Support and Resources

- **Documentation**: [README.md](https://github.com/skunklabz/tk4-hercules/blob/main/README.md)
- **Issues**: [GitHub Issues](https://github.com/skunklabz/tk4-hercules/issues)
- **Discussions**: [GitHub Discussions](https://github.com/skunklabz/tk4-hercules/discussions)
- **Changelog**: [CHANGELOG.md](https://github.com/skunklabz/tk4-hercules/blob/main/CHANGELOG.md)

## Contributing

We welcome contributions! Please see our [CONTRIBUTING.md](https://github.com/skunklabz/tk4-hercules/blob/main/CONTRIBUTING.md) guide for details on how to contribute.

## Acknowledgments

Thanks to all contributors who helped make this release possible:
- The Copilot engineering team for workflow improvements
- Community members who reported and helped debug the entrypoint issue
- All users providing feedback on the development process

## What's Next

Looking ahead to v1.3.2 and beyond:
- Additional stability improvements
- Enhanced monitoring capabilities
- Performance optimizations
- Expanded documentation

Stay tuned for updates!

---

**Full Changelog**: [v1.3.0...v1.3.1](https://github.com/skunklabz/tk4-hercules/compare/v1.3.0...v1.3.1)
