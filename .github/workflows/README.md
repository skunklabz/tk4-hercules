# GitHub Actions Workflows

This directory contains the CI/CD workflows for the TK4-Hercules project.

## Workflow Overview

### 🔄 Release Workflow (`release.yml`)
**Triggers**: Push to main, manual dispatch, release events
**Purpose**: Automated version management and releases

**Features**:
- ✅ Automatic patch version bump on main branch pushes
- ✅ Manual version bump (patch/minor/major) via workflow dispatch
- ✅ Multi-platform Docker builds (AMD64 + ARM64)
- ✅ GitHub Container Registry integration
- ✅ Automatic Git tagging and GitHub releases
- ✅ Changelog management

**Usage**:
```bash
# Automatic release (push to main)
git push origin main

# Manual release (GitHub Actions UI)
# Go to Actions → Release → Run workflow
```

### 🐳 Docker Build Workflow (`docker-build.yml`)
**Triggers**: Pull requests, manual dispatch
**Purpose**: PR testing and validation

**Features**:
- ✅ PR-specific Docker image builds
- ✅ Multi-platform testing
- ✅ Container health checks
- ✅ PR-specific image tags

### 🧪 CI Workflow (`ci.yml`)
**Triggers**: Push to main, pull requests
**Purpose**: Comprehensive testing and validation

**Features**:
- ✅ Code quality checks
- ✅ Documentation validation
- ✅ Security scanning
- ✅ Dependency checks

### 🔒 Security Workflow (`dependency-check.yml`)
**Triggers**: Weekly, manual dispatch
**Purpose**: Security and dependency monitoring

**Features**:
- ✅ Dependency vulnerability scanning
- ✅ Container image security analysis
- ✅ License compliance checks

### ✅ PR Checks Workflow (`pr-checks.yml`)
**Triggers**: Pull requests
**Purpose**: PR-specific validation

**Features**:
- ✅ Quick validation tests
- ✅ Documentation checks
- ✅ Code formatting validation

## Release Process

### Automated Release (Main Branch)
1. **Push to main** → Triggers release workflow
2. **Version bump** → Patch version incremented
3. **Docker build** → Multi-platform image built
4. **Registry push** → Image pushed to GHCR
5. **Git tag** → Version tag created
6. **GitHub release** → Release with changelog

### Manual Release
1. **GitHub Actions** → Release workflow
2. **Select version type** → patch/minor/major
3. **Run workflow** → Complete release process

## Workflow Permissions

- **Contents**: Write access for version bumps and releases
- **Packages**: Write access for Docker image pushes
- **Security Events**: Read access for security scanning

## Troubleshooting

### Common Issues
1. **Permission Denied**: Check workflow permissions
2. **Build Failures**: Review Docker build logs
3. **Version Conflicts**: Ensure VERSION file is up to date
4. **Registry Issues**: Verify GHCR authentication

### Debug Steps
1. Check workflow run logs
2. Verify file permissions
3. Test Docker builds locally
4. Review GitHub token permissions 