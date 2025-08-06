# TKX-Hercules

A Docker containerized IBM MVS 3.8j mainframe emulator supporting both TK4- and TK5- systems using Hercules for educational mainframe computing and historical preservation.

[![Docker Build](https://github.com/skunklabz/tkx-hercules/workflows/Build%20Docker%20Image/badge.svg)](https://github.com/skunklabz/tkx-hercules/actions)
[![GitHub Container Registry](https://img.shields.io/badge/GHCR-ghcr.io%2Fskunklabz%2Ftkx--hercules-blue)](https://ghcr.io/skunklabz/tkx-hercules)

## Quick Start

### Multi-Version Support

This project supports both TK4- and TK5- MVS systems:

```bash
# Run TK4- (default)
make start-tk4

# Run TK5-
make start-tk5

# Run TK5- External (AMD64 compatible)
make start-tk5-external

# Or use Docker Compose directly
MVS_VERSION=tk4 docker-compose up -d  # TK4- system
MVS_VERSION=tk5 docker-compose up -d  # TK5- system
MVS_VERSION=tk5-external docker-compose up -d  # TK5- external system
```

### Using GitHub Container Registry (Recommended)

```bash
# Pull and run TK4- (default)
docker run -d \
  --name tkx-hercules-tk4 \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tkx-hercules:tk4-latest

# Pull and run TK5-
docker run -d \
  --name tkx-hercules-tk5 \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tkx-hercules:tk5-latest
```

### Connect to the Mainframe

```bash
# Connect via telnet (3270 terminal)
telnet localhost 3270

# Or access the web console
open http://localhost:8038
```

### ARM64 Compatibility

If you're running on ARM64 (Apple Silicon Macs, ARM servers), you may encounter symbol relocation errors. Use the AMD64 platform for better compatibility:

```bash
# Force AMD64 platform for ARM64 systems
PLATFORM=linux/amd64 docker-compose up -d

# Or set environment variable
export PLATFORM=linux/amd64
make start-tk4  # or make start-tk5
```

For detailed troubleshooting, see [ARM64 Troubleshooting Guide](docs/ARM64_TROUBLESHOOTING.md).

## Version Comparison

| Feature | TK4- | TK5- |
|---------|------|------|
| **DASD Volumes** | 8 volumes | 15 volumes |
| **Hercules Version** | 4.4.1 | 4.60 (Hyperion) |
| **System Structure** | Traditional | Fully restructured |
| **New Features** | Basic MVS | ISPF 2.2, INTERCOMM, LUA370, SLIM, STF |
| **Update Strategy** | Full system updates | Selective volume updates |
| **Volume Isolation** | Shared volumes | Separate namespaces |

## What are TK4- and TK5-?

### TK4- (Turnkey 4-)
TK4- is a pre-configured IBM MVS 3.8j system created by Jürgen Winkelmann, based on Volker Bandke's original TK3. It's designed for educational purposes and historical preservation of mainframe computing.

### TK5- (Turnkey 5-)
TK5- is the latest evolution by Rob Prins, featuring a streamlined architecture with 15 DASD volumes (reduced from 28 in TK4+) and enhanced functionality including modern tools and applications.

### Features

- **IBM MVS 3.8j**: Complete mainframe operating system from 1981
- **Hercules Emulator**: Industry-standard mainframe emulation
- **3270 Terminal Support**: Authentic mainframe terminal experience
- **Web Console**: Modern web interface for system monitoring
- **Educational Tools**: Pre-loaded with learning materials and examples
- **Persistent Storage**: Volume isolation between versions
- **Multi-Version Support**: Run TK4- and TK5- simultaneously

### System Specifications

- **OS**: IBM MVS 3.8j Service Level 8505
- **Emulator**: Hercules 4.4.1 (TK4-) / 4.60 (TK5-)
- **Base Image**: Ubuntu 22.04
- **Architecture**: Multi-platform (x86_64, ARM64) (emulating System/370)
- **Memory**: Configurable (default: 1-2GB)
- **Storage**: 8 volumes (TK4-) / 15 volumes (TK5-)

## Available Images

### GitHub Container Registry (GHCR)

- **TK4- Latest**: `ghcr.io/skunklabz/tkx-hercules:tk4-latest`
- **TK5- Latest**: `ghcr.io/skunklabz/tkx-hercules:tk5-latest`
- **Versioned**: `ghcr.io/skunklabz/tkx-hercules:v1.2.0-tk4`, `ghcr.io/skunklabz/tkx-hercules:v1.2.0-tk5`

## Development

### Prerequisites

- Docker and Docker Compose
- Git
- Make (optional, for convenience commands)

### Building Locally

```bash
# Clone the repository
git clone https://github.com/skunklabz/tkx-hercules.git
cd tkx-hercules

# Build the image
make build

# Start the container
make start
```

### ARM64 Support

TKX-Hercules now supports ARM64 architecture, including Apple Silicon Macs and ARM-based servers. The image automatically detects your platform and uses the appropriate Hercules binary.

**Note:** ARM64 support currently uses x86_64 emulation due to limitations in the TK4- distribution. Native ARM64 binaries are planned for future releases.

```bash
# Build multi-platform images (AMD64 + ARM64)
make build-multi

# Test ARM64 support
make test-arm64

# Build for your current platform
make build-platform
```

For detailed ARM64 documentation, see [docs/ARM64_SUPPORT.md](docs/ARM64_SUPPORT.md).

### Git Hooks (Quality Assurance)

This repository includes Git hooks to ensure code quality before pushing:

#### Pre-Push Hook (Default)
Automatically runs before each `git push`:
- Quick validation checks
- Exercise content validation  
- Docker build test

**Enable**: Already enabled by default

#### Comprehensive Pre-Push Hook (Optional)
Runs full test suite including container startup and connectivity tests:

```bash
# Enable comprehensive pre-push checks
ln -sf .git/hooks/pre-push-comprehensive .git/hooks/pre-push

# Disable (back to default)
ln -sf .git/hooks/pre-push .git/hooks/pre-push
```

**Note**: Comprehensive tests take 2-3 minutes but catch more issues before they reach CI.

### Automated Releases

The project uses automated releases triggered by pushes to the main branch:

- **Push to main**: Automatically creates a new release
- **Version bump**: Patch version is incremented (1.1.0 → 1.1.1)
- **Docker build**: Multi-platform image is built and pushed to GHCR
- **GitHub release**: Release is created with changelog notes

For major or minor version bumps, use the manual workflow in GitHub Actions.

### Development Commands

```bash
# Build and push to GHCR
make push-ghcr

# Run tests
make test

# Clean up
make clean

# Show all available commands
make help
```

## Documentation

- **[Learning Guide](docs/LEARNING_GUIDE.md)**: Educational content and tutorials
- **[Registry Setup](docs/REGISTRY_SETUP.md)**: GitHub Container Registry configuration
- **[Testing Guide](docs/TESTING.md)**: Testing procedures and validation
- **[Project Structure](docs/PROJECT_STRUCTURE.md)**: Repository organization
- **[Contributing](CONTRIBUTING.md)**: How to contribute to the project

## Examples and Exercises

The `examples/` directory contains educational materials:

- **[Getting Started](examples/start-here.md)**: First steps with the mainframe
- **[File Systems](examples/02-file-systems.md)**: Understanding MVS file systems
- **[JCL Jobs](examples/03-first-jcl-job.md)**: Job Control Language examples
- **[Challenges](examples/challenges/)**: Advanced exercises and projects

## Ports and Services

- **3270**: Mainframe terminal protocol (telnet)
- **8038**: Web console interface (HTTP)

## Volume Mounts

The container uses 8 persistent volume mounts:

- `/tk4-/conf`: Master configuration
- `/tk4-/local_conf`: Initialization scripts
- `/tk4-/local_scripts`: User modifications
- `/tk4-/prt`: Line printer output
- `/tk4-/pch`: Card punch output
- `/tk4-/dasd`: Disk volumes
- `/tk4-/jcl`: Job control files
- `/tk4-/log`: System logs

## Security

- Non-root user execution (where possible)
- Resource limits for CPU and memory
- Security options enabled
- Regular base image updates

## Support

- **Issues**: [GitHub Issues](https://github.com/skunklabz/tkx-hercules/issues)
- **Discussions**: [GitHub Discussions](https://github.com/skunklabz/tkx-hercules/discussions)
- **Documentation**: [docs/](docs/) directory

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **TK4-**: The original Turnkey 4- system by Jürgen Winkelmann
- **TK5-**: The latest evolution by Rob Prins
- **Patrick Raths**: Docker implementation for TK5- (https://github.com/patrickraths/MVS-TK5)
- **Hercules**: The mainframe emulator by Jay Maynard and contributors
- **IBM**: For the original MVS 3.8j operating system
- **Mainframe Community**: For preserving and sharing mainframe knowledge

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and changes.

---

**Note**: This is an educational project for learning mainframe computing concepts. The MVS 3.8j system is a historical artifact and should be used for educational purposes only.
