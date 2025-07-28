# Contributing to TK4-Hercules

Thank you for your interest in contributing to TK4-Hercules! This project aims to provide an educational mainframe computing environment using the Hercules emulator and IBM MVS 3.8j (Turnkey 4-).

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style Guidelines](#code-style-guidelines)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Standards](#documentation-standards)
- [Pull Request Process](#pull-request-process)
- [Mainframe Knowledge](#mainframe-knowledge)

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Git
- Basic understanding of mainframe concepts (MVS, JCL, TSO)
- Familiarity with shell scripting (Bash)

### Development Environment Setup

1. Fork and clone the repository:
   ```bash
   git clone https://github.com/your-username/tk4-hercules.git
   cd tk4-hercules
   ```

2. Build the container:
   ```bash
   ./scripts/build/build.sh
   ```

3. Start the mainframe:
   ```bash
   docker-compose up -d
   ```

4. Connect to the mainframe:
   - Terminal: `telnet localhost 3270`
   - Web console: http://localhost:8038

## Development Workflow

### Branch Strategy

We follow a **trunk-based development** approach:

- **main**: Production-ready code
- **feature/***: New features and improvements
- **fix/***: Bug fixes and patches
- **docs/***: Documentation updates

### Creating a Feature Branch

```bash
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

### Commit Message Format

Use conventional commit format:

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions/changes
- `chore`: Maintenance tasks

Examples:
```
feat(docker): add multi-stage build for smaller image size
fix(exercises): correct JCL syntax in exercise 03
docs(readme): update installation instructions
```

## Code Style Guidelines

### Shell Scripts

- Use `#!/bin/bash` shebang
- Set `set -e` for error handling
- Use meaningful variable names
- Add comments for complex logic
- Follow shellcheck recommendations

### Docker

- Use multi-stage builds when possible
- Pin base image versions
- Use COPY instead of ADD
- Set non-root USER when possible
- Add meaningful labels

### Documentation

- Use Markdown format
- Include code examples
- Add screenshots for UI changes
- Keep documentation up-to-date

## Testing Guidelines

### Running Tests

```bash
# Run all tests
./scripts/test/test-exercises.sh

# Run validation
./scripts/validation/validate-exercises.sh

# Quick validation
./scripts/validation/quick-validate.sh
```

### Test Requirements

- All new features must include tests
- Tests should be deterministic
- Include both positive and negative test cases
- Test mainframe connectivity and functionality
- Validate exercise content and structure

## Documentation Standards

### File Organization

- **docs/**: Project documentation
- **examples/**: Educational exercises and examples
- **scripts/**: Build, test, and utility scripts
- **config/**: Configuration files
- **assets/**: Images and static resources

### Documentation Types

- **README.md**: Project overview and quick start
- **CONTRIBUTING.md**: This file
- **docs/LEARNING_GUIDE.md**: Educational content
- **docs/TESTING.md**: Testing procedures
- **examples/**: Step-by-step exercises

## Pull Request Process

### Before Submitting

1. Ensure all tests pass
2. Update documentation if needed
3. Follow code style guidelines
4. Test your changes thoroughly

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring

## Testing
- [ ] All tests pass
- [ ] Manual testing completed
- [ ] Documentation updated

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes
```

### Review Process

1. Automated tests must pass
2. Code review by maintainers
3. Documentation review
4. Final approval and merge

## Mainframe Knowledge

### Key Concepts

- **MVS 3.8j**: IBM Multiple Virtual Storage operating system (1981)
- **JCL**: Job Control Language for batch processing
- **TSO**: Time Sharing Option for interactive sessions
- **DASD**: Direct Access Storage Device (disk storage)
- **3270**: Mainframe terminal protocol
- **Hercules**: Open-source mainframe emulator

### Educational Focus

This project emphasizes:
- Historical preservation of mainframe computing
- Educational value for learning mainframe concepts
- Accessibility through containerization
- Practical hands-on experience

### Resources

- [IBM MVS Documentation](https://www.ibm.com/support/knowledgecenter/)
- [Hercules Emulator](http://www.hercules-390.org/)
- [TK4- System](http://www.jaymoseley.com/hercules/tk4-/)

## Questions or Issues?

- Create an issue for bugs or feature requests
- Join discussions in existing issues
- Contact maintainers for complex questions

Thank you for contributing to TK4-Hercules! 