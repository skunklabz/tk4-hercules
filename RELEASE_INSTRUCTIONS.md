# Release Instructions for v1.3.1

This document provides step-by-step instructions for creating the v1.3.1 release targeting the `version-bump` branch.

## Pre-Release Checklist

- [x] VERSION file updated to 1.3.1 on `version-bump` branch
- [x] CHANGELOG.md updated with v1.3.1 changes
- [x] Release notes created (RELEASE_NOTES_v1.3.1.md)
- [ ] Merge `version-bump` branch to `main`
- [ ] Automated release workflow triggers

## Release Overview

**Version:** 1.3.1  
**Type:** Patch Release  
**Branch:** version-bump  
**Docker Image:** `ghcr.io/skunklabz/tk4-hercules:v1.3.1`

## Changes in This Release

This is a patch release focusing on bug fixes and workflow improvements:

### Fixed
- Fixed infinite recursion in Docker entrypoint script
- Removed failing smoke test job from workflow
- Removed single-commit validation rule from PR workflow

### Changed
- Implemented single-commit workflow enforcement with enhanced pre-push hooks
- Updated CHANGELOG.md dates to align with cleaned git history

### Added
- Comprehensive development workflow documentation
- Makefile helpers for feature branch management
- Enhanced pre-push hook that blocks direct main pushes
- GitHub Actions PR validation for commit count

## Release Process

### Option 1: Automated Release (Recommended)

The repository uses an automated release workflow that triggers on pushes to the `main` branch.

**Steps:**

1. **Merge the `version-bump` branch to `main`:**
   ```bash
   git checkout main
   git pull origin main
   git merge version-bump
   git push origin main
   ```

2. **The workflow automatically:**
   - Reads version from VERSION file (1.3.1)
   - Builds multi-platform Docker images (AMD64 + ARM64)
   - Pushes images to GitHub Container Registry with tags:
     - `ghcr.io/skunklabz/tk4-hercules:latest`
     - `ghcr.io/skunklabz/tk4-hercules:v1.3.1`
   - Creates Git tag `v1.3.1`
   - Creates GitHub Release with the following body:
     ```markdown
     ## Release v1.3.1
     
     Docker image: `ghcr.io/skunklabz/tk4-hercules:v1.3.1`
     
     See CHANGELOG.md for detailed changes.
     ```

3. **Verify the release:**
   - Check GitHub Releases: https://github.com/skunklabz/tk4-hercules/releases
   - Verify Docker image: https://github.com/skunklabz/tk4-hercules/pkgs/container/tk4-hercules
   - Test the image: `docker pull ghcr.io/skunklabz/tk4-hercules:v1.3.1`

### Option 2: Manual Release (Alternative)

If the automated workflow needs to be triggered manually:

1. **Navigate to GitHub Actions:**
   - Go to: https://github.com/skunklabz/tk4-hercules/actions
   - Select "Release" workflow

2. **Run workflow:**
   - Click "Run workflow"
   - Select branch: `main` (after merging version-bump)
   - Click "Run workflow"

3. **Monitor the workflow:**
   - Watch the workflow execution
   - Verify all steps complete successfully

## Post-Release Tasks

After the release is created:

1. **Update Release Notes on GitHub:**
   - Go to the newly created release: https://github.com/skunklabz/tk4-hercules/releases/tag/v1.3.1
   - Click "Edit release"
   - Replace the auto-generated body with content from `RELEASE_NOTES_v1.3.1.md`
   - Save the release

2. **Verify Docker Image:**
   ```bash
   # Pull and test the image
   docker pull ghcr.io/skunklabz/tk4-hercules:v1.3.1
   
   # Run the container
   docker run -d \
     --name tk4-hercules-test \
     -p 3270:3270 \
     -p 8038:8038 \
     ghcr.io/skunklabz/tk4-hercules:v1.3.1
   
   # Verify it's running
   docker ps | grep tk4-hercules-test
   
   # Check logs
   docker logs tk4-hercules-test
   
   # Cleanup
   docker stop tk4-hercules-test
   docker rm tk4-hercules-test
   ```

3. **Announce the Release:**
   - Update README.md if needed
   - Post announcement in GitHub Discussions
   - Update any external documentation

4. **Monitor for Issues:**
   - Watch GitHub Issues for any reports related to v1.3.1
   - Monitor Docker image pull metrics
   - Check for any workflow failures

## Release Workflow Details

The release workflow (`.github/workflows/release.yml`) performs:

1. **Version Management:**
   - Reads version from `VERSION` file
   - Creates version-specific tags

2. **Docker Build:**
   - Sets up QEMU for multi-arch support
   - Configures Docker Buildx
   - Builds for platforms: linux/amd64, linux/arm64
   - Pushes to GitHub Container Registry

3. **GitHub Release:**
   - Creates Git tag `v1.3.1`
   - Creates GitHub Release with changelog reference
   - Links to Docker image

## Verification Checklist

After release creation, verify:

- [ ] Git tag `v1.3.1` exists
- [ ] GitHub Release v1.3.1 is published
- [ ] Docker image `ghcr.io/skunklabz/tk4-hercules:v1.3.1` is available
- [ ] Docker image `ghcr.io/skunklabz/tk4-hercules:latest` is updated
- [ ] Release notes are complete and accurate
- [ ] CHANGELOG.md is up to date
- [ ] Image can be pulled and run successfully

## Rollback Procedure

If issues are discovered after release:

1. **Immediate Rollback:**
   ```bash
   # Tag previous version as latest
   docker pull ghcr.io/skunklabz/tk4-hercules:v1.3.0
   docker tag ghcr.io/skunklabz/tk4-hercules:v1.3.0 ghcr.io/skunklabz/tk4-hercules:latest
   docker push ghcr.io/skunklabz/tk4-hercules:latest
   ```

2. **Mark Release as Pre-release:**
   - Edit the GitHub Release
   - Check "This is a pre-release"
   - Add warning to description

3. **Create Hotfix:**
   - Create hotfix branch from v1.3.0
   - Apply fixes
   - Release as v1.3.2

## Support

For questions or issues during the release process:

- **GitHub Issues:** https://github.com/skunklabz/tk4-hercules/issues
- **Discussions:** https://github.com/skunklabz/tk4-hercules/discussions
- **Documentation:** See `docs/SEMVER.md` for versioning guidelines

## Additional Resources

- **Semantic Versioning:** https://semver.org/
- **Keep a Changelog:** https://keepachangelog.com/
- **GitHub Releases:** https://docs.github.com/en/repositories/releasing-projects-on-github
- **Docker Multi-Platform:** https://docs.docker.com/build/building/multi-platform/
