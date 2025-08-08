# SDL-Hercules-390 Migration

This document describes the migration from building Hercules from source to using the SDL-Hercules-390 submodule, and the cleanup that was performed.

## Overview

The project has been migrated from building Hercules from source to using the SDL-Hercules-390 submodule. This change simplifies the build process and provides better performance and compatibility.

## What Changed

### Architecture Changes

1. **SDL-Hercules-390 Submodule**: Now using `external/sdl-hercules-390/` instead of building Hercules from source
2. TK5 content removed; repository is TK4-only
3. Dockerfile uses a multi-stage build to set up TK4 distribution

### Removed Components

#### Build Scripts Removed
- `scripts/build/download-tk4.sh` - No longer needed since we use submodules
- `scripts/build/fix-arm64.sh` - ARM64 workarounds no longer needed
- `scripts/test/test-arm64.sh` - ARM64-specific tests removed
- `scripts/start-arm64.sh` - ARM64 workaround script removed

#### Makefile Updates
- Removed ARM64-specific commands (`fix-arm64`, `start-arm64`, `test-arm64`)
- Updated repository to TK4-only
- Updated help text to reflect SDL-Hercules-390 architecture
- Simplified build process descriptions

### Updated Components

#### Build Scripts
- `scripts/build/build.sh` - Updated to check for submodules and focus on Docker builds
- `scripts/test/test-exercises.sh` - Updated for TK4-only

#### Configuration Files
- `docker-compose.yml` - TK4-only configuration
- `Makefile` - Updated commands and defaults

#### Documentation
- `README.md` - Updated to reflect SDL-Hercules-390 architecture
- Removed ARM64-specific troubleshooting references

## Benefits of the Migration

### Simplified Build Process
- No more complex Hercules compilation from source
- Submodule-based approach provides version control
- Cleaner separation of concerns

### Better Performance
- SDL-Hercules-390 is optimized for x86_64 architecture
- Enhanced performance compared to standard Hercules
- Better compatibility with modern systems

### Reduced Maintenance
- Fewer build scripts to maintain
- No ARM64-specific workarounds needed
- Cleaner codebase structure

## Current Architecture

```
TKX-Hercules Project (TK4-only)
├── external/
│   └── sdl-hercules-390/ # SDL-Hercules-390 emulator
├── versions/
│   └── tk4/
└── scripts/
    ├── build/            # Docker build scripts
    └── test/             # TK4 functionality tests
```

## Build Process

1. **Submodule Check**: Verify SDL-Hercules-390 submodule is initialized
2. **Multi-stage Build**: 
   - Stage 1: Prepare base image
   - Stage 2: Set up TK4 distribution
3. **Container Setup**: Configure ports, volumes, and environment

## Testing

The test suite now focuses on:
- Exercise file structure validation
- Submodule availability
- Docker build process
- Container startup and connectivity
- Basic TK4 functionality

## Migration Checklist

- [x] Remove Hercules build-specific scripts
- [x] Update build scripts to use submodules
- [x] Remove ARM64-specific workarounds
- [x] Update Makefile commands and defaults
- [x] Update documentation to reflect new architecture
- [x] Update test scripts for TK4 functionality

## Future Considerations

1. **Performance Monitoring**: Monitor SDL-Hercules-390 performance across different systems
2. **Submodule Updates**: Regular updates to SDL-Hercules-390 submodule for latest features
3. **Documentation**: Keep documentation updated as SDL-Hercules-390 evolves
4. **Testing**: TK4-only coverage

## Troubleshooting

### Submodule Issues
```bash
# Initialize submodules
git submodule update --init --recursive

# Update submodules
git submodule update --remote
```

### Build Issues
```bash
# Clean and rebuild
make clean
make build

# Check submodule status
git submodule status
```

### Container Issues
```bash
# Check container logs
docker compose logs

# Restart container
make restart
```

## References

- [SDL-Hercules-390 Documentation](https://sdl-hercules-390.github.io/html/)
- [SDL-Hercules-390 GitHub Repository](https://github.com/SDL-Hercules-390/hyperion)
 