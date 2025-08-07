# GitHub Container Registry Setup

This document explains how to set up and use the GitHub Container Registry (GHCR) for the TKX-Hercules project.

## Overview

The TKX-Hercules Docker image is now available on GitHub Container Registry at:
`ghcr.io/skunklabz/tkx-hercules`

## Benefits of GHCR

- **Free for public repositories**: No storage or bandwidth limits for public images
- **Integrated with GitHub**: Seamless integration with GitHub Actions and workflows
- **Security**: Built-in vulnerability scanning and security features
- **Versioning**: Automatic versioning based on Git tags and branches

## Quick Start

### Pull and Run the Image

```bash
# Pull the latest image
docker pull ghcr.io/skunklabz/tkx-hercules:latest

# Run the container
docker run -d \
  --name tkx-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tk4-hercules:latest
```

### Using Docker Compose

The `docker-compose.yml` file is already configured to use the GHCR image:

```bash
# Start the mainframe
docker compose up -d

# Connect to the mainframe
telnet localhost 3270
```

## Available Tags

- `ghcr.io/skunklabz/tkx-hercules:latest` - Latest stable version
- `ghcr.io/skunklabz/tkx-hercules:v1.2.0` - Specific version
- `ghcr.io/skunklabz/tkx-hercules:main` - Latest from main branch
- `ghcr.io/skunklabz/tkx-hercules:pr-*` - Pull request builds

## Building and Pushing

### Prerequisites

1. **GitHub Token**: Create a personal access token with `write:packages` permission
2. **Docker**: Ensure Docker is installed and running
3. **Repository Access**: Ensure you have write access to the repository

### Manual Build and Push

```bash
# Build for GHCR
make build-ghcr

# Build and push to GHCR
make push-ghcr

# Or use the script directly
./scripts/build/build-ghcr.sh
```

### Authentication

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u skunklabz --password-stdin

# Or use the make command
make login-ghcr
```

## Automated Builds

The project includes GitHub Actions workflows that automatically build and push images:

- **On push to main**: Builds and pushes `latest` and `main` tags
- **On tag creation**: Builds and pushes versioned tags (e.g., `v1.1.0`)
- **On pull requests**: Builds but doesn't push (for testing)

### Workflow File

The workflow is defined in `.github/workflows/docker-build.yml` and includes:

- Multi-platform builds (linux/amd64)
- Automated testing
- Caching for faster builds
- Security scanning

## Local Development

### Using Local Images

For local development, you can still build and use local images:

```bash
# Build local image
make build

# Start with local image
docker compose up -d
```

### Switching Between Registries

To use a different image source, modify the `docker-compose.yml`:

```yaml
services:
  tkx-hercules:
    # Use GitHub Container Registry (default)
    image: ghcr.io/skunklabz/tkx-hercules:latest
    
    # Or use local image
    # image: tkx-hercules:latest
```

## Security and Permissions

### Repository Permissions

The GitHub Actions workflow requires these permissions:

```yaml
permissions:
  contents: read
  packages: write
```

### Token Permissions

Your GitHub token needs these scopes:
- `write:packages` - Push images to GHCR
- `read:packages` - Pull images from GHCR

## Troubleshooting

### Common Issues

1. **Authentication Failed**
   ```bash
   # Ensure token has correct permissions
   # Check token expiration
   # Verify username matches repository owner
   ```

2. **Push Permission Denied**
   ```bash
   # Ensure you have write access to the repository
   # Check token has 'write:packages' scope
   ```

3. **Image Not Found**
   ```bash
   # Check image name and tag
   # Ensure image was pushed successfully
   # Verify repository visibility settings
   ```

### Debug Commands

```bash
# Check authentication
docker info | grep ghcr.io

# List local images
docker images ghcr.io/skunklabz/tkx-hercules

# Check workflow status
# Visit: https://github.com/skunklabz/tkx-hercules/actions
```

## Registry URL

- **Web Interface**: https://ghcr.io/skunklabz/tkx-hercules
- **Docker Pull**: `ghcr.io/skunklabz/tkx-hercules:latest`
- **Package Settings**: https://github.com/skunklabz/tkx-hercules/packages

## Registry Information

The project uses GitHub Container Registry (GHCR) exclusively:

1. All images are published to GHCR
2. No Docker Hub images are maintained
3. All documentation references GHCR images

## Support

For issues with the registry setup:

1. Check the [GitHub Container Registry documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
2. Review the GitHub Actions workflow logs
3. Open an issue in the repository

## Related Documentation

- [Docker Setup](DOCKER_SETUP.md)
- [Development Guide](DEVELOPMENT.md)
- [Testing Guide](TESTING.md)
- [Contributing Guidelines](../CONTRIBUTING.md) 