# GitHub Actions Workflows

This directory contains GitHub Actions workflows for the tk4-hercules project. These workflows provide automated testing, linting, security scanning, and deployment capabilities.

## Workflow Overview

### 1. CI (`ci.yml`)
**Triggers**: Push to `main`/`develop`, Pull Requests to `main`

Comprehensive continuous integration workflow that runs:
- **Linting and Code Quality**: Shell script linting, YAML validation, documentation checks
- **Testing**: Docker build, container startup tests, comprehensive exercise tests
- **Security Checks**: Vulnerability scanning with Trivy, secret detection
- **Documentation Checks**: Markdown link validation, CHANGELOG format validation

### 2. Pull Request Checks (`pr-checks.yml`)
**Triggers**: Pull Requests to `main`/`develop`

Fast validation workflow for pull requests that:
- Runs shellcheck only on changed files
- Validates YAML syntax
- Checks script permissions
- Runs quick validation tests
- Validates documentation changes

### 3. Nightly Build and Test (`nightly.yml`)
**Triggers**: Daily at 2 AM UTC, Manual dispatch

Comprehensive nightly testing that:
- Builds Docker image
- Runs all validation and test scripts
- Tests container stability (10-minute runtime test)
- Tests all Makefile commands
- Monitors system resource usage
- Generates test reports

### 4. Dependency Check (`dependency-check.yml`)
**Triggers**: Weekly on Sundays at 3 AM UTC, Manual dispatch

Dependency and security monitoring that:
- Checks for Docker base image updates
- Scans for security vulnerabilities
- Identifies outdated GitHub Actions
- Detects deprecated features
- Performs security audits
- Generates dependency reports

### 5. Release (`release.yml`)
**Triggers**: Release creation

Handles release automation including:
- Docker image building and pushing
- Release artifact creation
- Documentation updates

## Local Testing

You can test the CI pipeline locally using the Makefile commands:

```bash
# Run full CI pipeline
make ci-full

# Run individual CI components
make ci-lint      # Linting checks
make ci-validate  # Validation tests
make ci-test      # Full tests
```

## Workflow Dependencies

- **CI**: Runs all jobs in parallel (lint, test, security, documentation)
- **PR Checks**: Runs quick-checks and documentation jobs in parallel
- **Nightly**: Runs nightly-test and security-scan jobs in parallel
- **Dependency Check**: Runs dependency-check and security-audit jobs in parallel

## Artifacts

The workflows generate several artifacts:
- `nightly-test-report`: Comprehensive test results from nightly runs
- `dependency-report`: Dependency analysis and update recommendations
- `security-report`: Security audit findings
- `trivy-results.sarif`: Vulnerability scan results (uploaded to GitHub Security tab)

## Security Features

- **Trivy Vulnerability Scanning**: Scans Docker images and filesystem for vulnerabilities
- **CodeQL Analysis**: Static code analysis for security issues
- **Secret Detection**: Scans for potential secrets in code
- **File Permission Checks**: Ensures proper file permissions
- **Dependency Monitoring**: Tracks outdated dependencies

## Performance Optimizations

- **Docker Layer Caching**: Reduces build times for Docker images
- **Parallel Job Execution**: Runs independent jobs simultaneously
- **Incremental Testing**: PR checks only test changed files
- **Timeout Limits**: Prevents hanging jobs from consuming resources

## Troubleshooting

### Common Issues

1. **Shellcheck Failures**: Fix shell script linting issues by running `shellcheck scripts/**/*.sh`
2. **Permission Errors**: Ensure all shell scripts are executable with `chmod +x scripts/**/*.sh`
3. **YAML Validation Errors**: Check YAML syntax in workflow files and docker-compose.yml
4. **Docker Build Failures**: Verify Dockerfile syntax and base image availability

### Debugging

- Check workflow logs in the GitHub Actions tab
- Use `make ci-full` to test locally before pushing
- Review artifact files for detailed reports
- Check the Security tab for vulnerability scan results

## Maintenance

### Updating Workflows

1. Test changes locally using `make ci-full`
2. Create a feature branch for workflow changes
3. Test the workflow on the feature branch
4. Create a pull request with workflow changes
5. Monitor the workflow execution in the PR

### Monitoring

- Review nightly test reports for trends
- Check dependency reports for update recommendations
- Monitor security scan results in the Security tab
- Track workflow execution times and success rates

## Contributing

When adding new workflows or modifying existing ones:

1. Follow the established naming conventions
2. Include appropriate triggers and conditions
3. Add proper error handling and timeouts
4. Document the workflow purpose and requirements
5. Test thoroughly before merging

For more information about GitHub Actions, see the [official documentation](https://docs.github.com/en/actions). 