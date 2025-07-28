# ARM64 Support for TK4-Hercules

This document describes the ARM64 support added to the TK4-Hercules project.

## Overview

TK4-Hercules now supports ARM64 architecture, including Apple Silicon Macs and ARM-based servers. However, due to limitations in the TK4- distribution (which only includes 32-bit ARM binaries), ARM64 support currently works through emulation of x86_64 binaries.

**Current Status:**
- ✅ ARM64 builds work correctly
- ✅ Architecture detection is functional
- ⚠️ Hercules binaries require emulation on ARM64
- 🔄 Future: Native ARM64 binaries planned

## Supported Platforms

- **Apple Silicon Macs** (M1, M2, M3, etc.)
- **ARM64 Linux servers** (AWS Graviton, Azure ARM, etc.)
- **ARM64 development boards** (Raspberry Pi 4 with 64-bit OS, etc.)

## Architecture Detection

The Docker image automatically detects the target architecture and uses the appropriate Hercules binary:

- **x86_64/AMD64**: Uses `hercules/linux/64/bin/hercules` (native)
- **ARM64/aarch64**: Uses `hercules/linux/64/bin/hercules` (emulated via Rosetta on macOS, or x86_64 emulation on Linux)

**Note**: ARM64 support currently uses x86_64 binaries with emulation due to limitations in the TK4- distribution. Native ARM64 binaries are planned for future releases.

## Building Multi-Platform Images

### Local Development

```bash
# Build for your current platform
make build-platform

# Build multi-platform images (AMD64 + ARM64)
make build-multi

# Build for GitHub Container Registry
make build-ghcr
```

### Using Docker Buildx

```bash
# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t tk4-hercules:latest .

# Build and push to registry
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/skunklabz/tk4-hercules:latest --push .
```

## Running on ARM64

### Using Docker Compose

```bash
# The image will automatically use the correct architecture
docker-compose up -d
```

### Using Docker Run

```bash
# Pull the latest multi-platform image
docker pull ghcr.io/skunklabz/tk4-hercules:latest

# Run the container
docker run -d \
  --name tk4-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tk4-hercules:latest
```

## Testing ARM64 Support

```bash
# Test ARM64 build and functionality
make test-arm64

# Or run the test script directly
./scripts/test/test-arm64.sh
```

## Performance Considerations

### Current ARM64 Implementation

- **ARM64 with x86_64 emulation**: Reduced performance due to emulation layer
- **Native x86_64**: Optimal performance
- **Future native ARM64**: Will provide optimal performance on ARM64 systems

### Why Emulation?

The TK4- distribution only includes 32-bit ARM binaries (ARMv7), which cannot run natively on ARM64 systems without additional compatibility layers. The current solution uses x86_64 binaries with emulation to provide compatibility.

**Note**: The TK4- distribution includes `hercules/linux/arm/bin/hercules` (ARMv7) but this cannot run natively on ARM64 systems. Therefore, we use x86_64 binaries with emulation for ARM64 support.

### Recommended Setup

For ARM64 systems, we recommend using the native ARM64 image:

```bash
# This will automatically pull the ARM64 version
docker pull ghcr.io/skunklabz/tk4-hercules:latest
```

## Troubleshooting

### Platform Mismatch Warnings

If you see warnings about platform mismatch, ensure you're using the multi-platform image:

```bash
# Check image platform
docker image inspect ghcr.io/skunklabz/tk4-hercules:latest | grep Architecture

# Pull fresh multi-platform image
docker pull ghcr.io/skunklabz/tk4-hercules:latest
```

### Build Issues

If you encounter build issues on ARM64:

1. Ensure Docker buildx is available:
   ```bash
   docker buildx version
   ```

2. Create a new builder instance:
   ```bash
   docker buildx create --name tk4-hercules-builder --use
   ```

3. Build with explicit platform:
   ```bash
   docker build --platform linux/arm64 -t tk4-hercules:arm64 .
   ```

## Technical Details

### Hercules Binary Selection

The Dockerfile includes logic to select the appropriate Hercules binary:

```dockerfile
RUN if [ "$(uname -m)" = "x86_64" ]; then \
        ln -sf /tk4-/hercules/linux/64/bin/hercules /tk4-/hercules; \
    elif [ "$(uname -m)" = "aarch64" ]; then \
        ln -sf /tk4-/hercules/linux/64/bin/hercules /tk4-/hercules; \
    fi
```

**Note**: Both x86_64 and ARM64 architectures use the same x86_64 Hercules binary. ARM64 systems run this binary through emulation (Rosetta on macOS, QEMU on Linux).

### Multi-Platform Build Process

1. **Download**: TK4- distribution includes x86_64 and ARMv7 binaries
2. **Filter**: Remove unnecessary architecture binaries (keep only x86_64 for both platforms)
3. **Link**: Create appropriate symlinks for target architecture (both use x86_64 binaries)
4. **Build**: Use Docker buildx for multi-platform builds
5. **Emulation**: ARM64 builds include QEMU for x86_64 emulation

### Registry Support

The GitHub Container Registry (GHCR) supports multi-platform images, allowing automatic platform selection when pulling images.

## Contributing

When contributing to ARM64 support:

1. Test on both AMD64 and ARM64 platforms
2. Use the multi-platform build scripts
3. Update documentation for any platform-specific changes
4. Run ARM64 tests before submitting PRs

## References

- [Docker Multi-Platform Builds](https://docs.docker.com/build/building/multi-platform/)
- [Hercules Emulator](http://www.hercules-390.org/)
- [TK4- Distribution](https://wotho.pebble-beach.ch/tk4-/) 