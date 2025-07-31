# GitHub Actions Workflows

This directory contains the essential CI/CD workflows for the tk4-hercules project.

## Workflows

### `docker-build.yml`
**Purpose**: Build and test Docker images on pull requests and pushes to main branch.

**Triggers**:
- Pull requests to main branch
- Pushes to main branch  
- Manual workflow dispatch

**What it does**:
- Builds multi-platform Docker image (amd64, arm64)
- Pushes to GitHub Container Registry with `latest` and `main` tags
- Runs basic container startup test
- Uses GitHub Actions cache for faster builds

### `release.yml`
**Purpose**: Create releases with versioned Docker images.

**Triggers**:
- Pushes to main branch
- GitHub releases (published)
- Manual workflow dispatch

**What it does**:
- Builds Docker image with version tag from VERSION file
- Pushes to GitHub Container Registry with `latest` and `v{version}` tags
- Creates GitHub release with version tag
- Includes Docker image reference in release notes

## Simplified Approach

We've removed unnecessary complexity and focused on what's essential:

❌ **Removed**:
- Extensive linting and validation checks
- Duplicate PR checks
- Weekly dependency scanning
- Automated version bumping
- Complex metadata extraction

✅ **Kept**:
- Docker image building and testing
- Multi-platform support (amd64, arm64)
- Basic container validation
- Release creation with versioned images
- GitHub Container Registry integration

## Usage

### Building Images
Images are automatically built on:
- Every PR to main branch
- Every push to main branch
- Manual trigger via GitHub Actions UI

### Creating Releases
1. Update the VERSION file with the new version
2. Push to main branch
3. The workflow will automatically create a GitHub release with the versioned Docker image

### Manual Release
1. Go to Actions → Release workflow
2. Click "Run workflow"
3. The workflow will use the current VERSION file

## Docker Images

All images are pushed to: `ghcr.io/skunklabz/tk4-hercules`

Available tags:
- `latest` - Latest build from main branch
- `main` - Latest build from main branch  
- `v{version}` - Versioned releases (e.g., `v1.0.0`)

## Cache Strategy

The workflows use GitHub Actions cache to speed up builds:
- Build cache is shared between workflows
- Cache is automatically managed by Docker Buildx
- No manual cache management required 