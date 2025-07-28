# Contributing to TK4-Hercules

Thank you for your interest in contributing to the TK4-Hercules project! This document provides guidelines for contributing to this educational mainframe emulator project.

## Development Workflow

This project follows **trunk-based development** principles for efficient collaboration and continuous integration.

### Branching Strategy

- **`main`**: The primary branch containing stable, deployable code
- **Feature branches**: Short-lived branches for individual features/fixes
- **No long-lived development branches**: All work flows directly to `main`

### Workflow Steps

1. **Create a feature branch from `main`**:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/your-feature-name
   ```

2. **Make small, focused commits**:
   ```bash
   git add .
   git commit -m "feat: add new mainframe exercise"
   ```

3. **Push your branch and create a pull request**:
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Automated testing**: GitHub Actions will run tests and linting on your PR

5. **Code review**: Get approval from maintainers

6. **Merge to `main`**: Once approved, merge your PR to `main`

7. **Delete the feature branch**: Clean up after successful merge

### Best Practices

- **Small batches**: Keep changes small and focused
- **Frequent commits**: Commit at least once per day
- **Quick merges**: Merge feature branches within 1-2 days
- **Automated testing**: Ensure all tests pass before merging
- **Code review**: All changes require review before merging

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