# Security Policy

## Supported Versions

Use this section to tell people about which versions of your project are
currently being supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability in TK4-Hercules, please follow these steps:

### 1. **DO NOT** create a public GitHub issue
Security vulnerabilities should be reported privately to avoid potential exploitation.

### 2. Report the vulnerability
Please email your findings to [INSERT SECURITY EMAIL] with the following information:

- **Subject**: `[SECURITY] TK4-Hercules Vulnerability Report`
- **Description**: Detailed description of the vulnerability
- **Steps to reproduce**: Clear steps to reproduce the issue
- **Impact**: Potential impact of the vulnerability
- **Suggested fix**: If you have any suggestions for fixing the issue

### 3. What to expect
- You will receive an acknowledgment within 48 hours
- We will investigate the report and provide updates
- Once confirmed, we will work on a fix
- We will coordinate disclosure with you

### 4. Disclosure timeline
- **Critical vulnerabilities**: Fixed within 7 days
- **High severity**: Fixed within 14 days
- **Medium severity**: Fixed within 30 days
- **Low severity**: Fixed in next regular release

## Security Considerations

### Container Security
- This project runs in Docker containers
- Base images are regularly updated for security patches
- Non-root user is used when possible
- Minimal attack surface through containerization

### Mainframe Security
- TK4- is an educational system, not production-ready
- Default passwords are used for educational purposes
- No sensitive data should be stored in this environment
- Network access is limited to local development

### Best Practices
- Keep Docker and dependencies updated
- Run containers in isolated networks
- Don't expose unnecessary ports
- Regularly review and update base images
- Follow principle of least privilege

## Security Updates

Security updates will be released as patch versions (e.g., 1.0.1, 1.0.2) and will be clearly marked in the [CHANGELOG.md](CHANGELOG.md).

## Responsible Disclosure

We appreciate security researchers who follow responsible disclosure practices. We will:

- Acknowledge your contribution in our security advisories
- Work with you to coordinate disclosure
- Provide appropriate credit in our documentation
- Ensure fixes are properly tested before release

## Contact Information

For security-related issues, please contact:
- **Email**: [INSERT SECURITY EMAIL]
- **PGP Key**: [INSERT PGP KEY IF AVAILABLE]

For general questions about security, please use the regular issue tracker or discussion forums. 