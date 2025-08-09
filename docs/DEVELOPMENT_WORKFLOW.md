# Development Workflow

## Single Commit Policy

This repository enforces a **single commit per feature** policy to maintain a clean, linear history.

### ✅ Correct Workflow

```bash
# 1. Create feature branch
git checkout -b feat/add-new-feature

# 2. Make your changes (multiple commits are OK during development)
git add .
git commit -m "wip: initial implementation"
git commit -m "wip: add tests"
git commit -m "wip: fix edge case"

# 3. Squash into single commit before pushing
git rebase -i origin/main
# In editor: change 'pick' to 'squash' for all but first commit

# OR use reset method:
git reset --soft origin/main
git commit -m "feat: add new feature with comprehensive tests"

# 4. Push feature branch
git push origin feat/add-new-feature

# 5. Create PR on GitHub
# 6. Use "Squash and merge" when merging
```

### ❌ What NOT to Do

```bash
# DON'T: Push multiple commits and merge them all
git push origin feat/messy-branch  # with 10 commits
# Then merge without squashing = messy history

# DON'T: Push directly to main
git checkout main
git commit -m "quick fix"
git push origin main  # ❌ Will be blocked by pre-push hook
```

## Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types:
- `feat`: New feature
- `fix`: Bug fix  
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples:
```
feat(docker): add multi-architecture support
fix(hercules): resolve memory leak in emulator
docs(readme): update installation instructions
chore(deps): bump docker base image to alpine 3.19
```

## Branch Naming

Use descriptive branch names with prefixes:

- `feat/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `chore/` - Maintenance tasks
- `refactor/` - Code refactoring

Examples:
```
feat/add-3270-web-terminal
fix/resolve-arm64-compatibility
docs/update-learning-guide
chore/update-dependencies
```

## Pre-Push Validation

The repository includes pre-push hooks that will:

1. ✅ Block direct pushes to `main`
2. ⚠️  Warn about multiple commits on feature branches
3. ✅ Run validation scripts
4. ✅ Test Docker builds
5. ✅ Validate exercise content

## GitHub Settings

The repository is configured with:

- ✅ **Require pull requests** before merging
- ✅ **Require branches to be up to date**
- ✅ **Only allow squash merging**
- ✅ **Delete head branches automatically**

## Rollback Strategy

If you need to rollback the single-commit policy:

```bash
# Restore from backup (if needed)
git checkout backup/correct-2025-rewrite-20250809-121601
git checkout -b restore-complex-history
git push origin restore-complex-history
# Then create PR to restore old history
```

## Benefits of Single Commit Policy

1. **Clean History**: Easy to read `git log`
2. **Easy Rollback**: `git revert <commit>` removes entire feature
3. **Clear Releases**: Each commit represents a complete change
4. **Better Bisecting**: `git bisect` works more effectively
5. **Professional Appearance**: Clean history for open source projects

## Questions?

If you have questions about this workflow, please:

1. Check existing issues/discussions
2. Create a new discussion
3. Reach out to maintainers

Remember: The goal is a clean, maintainable history while keeping development flexible!
