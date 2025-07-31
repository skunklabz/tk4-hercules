# ARM64 Troubleshooting Guide

This guide helps resolve ARM64 compatibility issues with TK4-Hercules, particularly the symbol relocation errors you may encounter.

## Common Issues

### Symbol Relocation Errors

If you see errors like:
```
Error relocating hercules/linux/64/lib/libhercu.so: argz_create_sep: symbol not found
Error relocating hercules/linux/64/lib/libhercu.so: argz_stringify: symbol not found
Error relocating hercules/linux/64/lib/libhercu.so: argz_insert: symbol not found
```

This indicates that the x86_64 libraries are missing required symbols for ARM64 emulation.

## Solutions

### Solution 1: Use AMD64 Platform (Recommended)

Force the container to run on the AMD64 platform for better compatibility:

```bash
# Set environment variable to force AMD64 platform
export PLATFORM=linux/amd64

# Start the container
make start
```

Or run directly with docker-compose:

```bash
PLATFORM=linux/amd64 docker-compose up -d
```

### Solution 2: Use Docker Run with Platform Specification

```bash
# Stop any running containers
docker-compose down

# Run with explicit AMD64 platform
docker run -d \
  --platform linux/amd64 \
  --name tk4-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tk4-hercules:latest
```

### Solution 3: Build Local Image with ARM64 Fixes

If the above solutions don't work, try building a local image with ARM64 fixes:

```bash
# Build multi-platform image locally
make build-multi

# Test ARM64 compatibility
make test-arm64

# Start with local image
docker-compose up -d
```

### Solution 4: Use ARM64 Fix Script

Run the ARM64 fix script to resolve compatibility issues:

```bash
# Run the ARM64 fix script
make fix-arm64

# Start the container
make start
```

## Platform-Specific Solutions

### macOS (Apple Silicon)

On macOS with Apple Silicon, Rosetta 2 should handle x86_64 emulation automatically. If you're still having issues:

1. **Ensure Rosetta 2 is installed:**
   ```bash
   softwareupdate --install-rosetta
   ```

2. **Use AMD64 platform explicitly:**
   ```bash
   PLATFORM=linux/amd64 make start
   ```

3. **Check Docker Desktop settings:**
   - Open Docker Desktop
   - Go to Settings > General
   - Ensure "Use the new Virtualization framework" is enabled

### Linux ARM64

On Linux ARM64 systems:

1. **Install QEMU for x86_64 emulation:**
   ```bash
   sudo apt-get install qemu-user-static
   ```

2. **Register QEMU for x86_64 binaries:**
   ```bash
   docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
   ```

3. **Use AMD64 platform:**
   ```bash
   PLATFORM=linux/amd64 make start
   ```

## Testing Your Setup

### Test ARM64 Compatibility

```bash
# Run the ARM64 test
make test-arm64
```

### Test Container Functionality

```bash
# Start the container
make start

# Check container status
make status

# View logs
make logs

# Test connectivity
telnet localhost 3270
```

## Troubleshooting Steps

### Step 1: Check System Architecture

```bash
uname -m
```

Expected output:
- `arm64` or `aarch64` for ARM64 systems
- `x86_64` for AMD64 systems

### Step 2: Check Docker Platform Support

```bash
docker buildx ls
```

Ensure you have multi-platform build support.

### Step 3: Check Image Platform

```bash
docker image inspect ghcr.io/skunklabz/tk4-hercules:latest | grep Architecture
```

### Step 4: Test QEMU Emulation

```bash
docker run --rm --platform linux/amd64 alpine:latest uname -m
```

Should return `x86_64`.

## Environment Variables

You can control the platform behavior with these environment variables:

- `PLATFORM`: Set to `linux/amd64` to force AMD64 platform
- `IMAGE_NAME`: Override the default image name
- `DOCKER_DEFAULT_PLATFORM`: Set default platform for Docker

## Example Usage

### For ARM64 Systems (Recommended)

```bash
# Set platform to AMD64 for better compatibility
export PLATFORM=linux/amd64

# Start the mainframe
make start

# Check status
make status

# Connect to mainframe
telnet localhost 3270
```

### For Development

```bash
# Build and test locally
make build-multi
make test-arm64

# Start development environment
make dev-setup
```

## Performance Considerations

- **AMD64 emulation on ARM64**: Reduced performance due to emulation layer
- **Native ARM64**: Optimal performance (when available)
- **Memory usage**: Emulation may require more memory

## Getting Help

If you're still experiencing issues:

1. **Check the logs:**
   ```bash
   make logs
   ```

2. **Run diagnostics:**
   ```bash
   make test-arm64
   ```

3. **Check system resources:**
   ```bash
   docker system df
   ```

4. **Clean up and retry:**
   ```bash
   make clean
   make build-multi
   make start
   ```

## References

- [Docker Multi-Platform Builds](https://docs.docker.com/build/building/multi-platform/)
- [QEMU User Mode Emulation](https://wiki.qemu.org/Documentation/UserModeEmulation)
- [Rosetta 2 Documentation](https://developer.apple.com/documentation/apple_silicon/about_the_rosetta_translation_environment) 