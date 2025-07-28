# TK4-Hercules

A Docker containerized IBM MVS 3.8j (Turnkey 4-) mainframe emulator using Hercules for educational mainframe computing and historical preservation.

[![Docker Build](https://github.com/skunklabz/tk4-hercules/workflows/Build%20and%20Push%20Docker%20Image/badge.svg)](https://github.com/skunklabz/tk4-hercules/actions)
[![GitHub Container Registry](https://img.shields.io/badge/GHCR-ghcr.io%2Fskunklabz%2Ftk4--hercules-blue)](https://ghcr.io/skunklabz/tk4-hercules)

## Quick Start

### Using GitHub Container Registry (Recommended)

```bash
# Pull and run the latest image
docker run -d \
  --name tk4-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  ghcr.io/skunklabz/tk4-hercules:latest

# Or use Docker Compose
docker-compose up -d
```

### Using Docker Hub

```bash
# Pull and run from Docker Hub
docker run -d \
  --name tk4-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  skunklabz/tk4-hercules:latest
```

### Connect to the Mainframe

```bash
# Connect via telnet (3270 terminal)
telnet localhost 3270

# Or access the web console
open http://localhost:8038
```

## What is TK4-?

TK4- is a pre-configured IBM MVS 3.8j (Multiple Virtual Storage) system that runs on the Hercules mainframe emulator. It's designed for educational purposes and historical preservation of mainframe computing.

### Features

- **IBM MVS 3.8j**: Complete mainframe operating system from 1981
- **Hercules Emulator**: Industry-standard mainframe emulation
- **3270 Terminal Support**: Authentic mainframe terminal experience
- **Web Console**: Modern web interface for system monitoring
- **Educational Tools**: Pre-loaded with learning materials and examples
- **Persistent Storage**: 8 volume mount points for data persistence

### System Specifications

- **OS**: IBM MVS 3.8j Service Level 8505
- **Emulator**: Hercules 4.4.1
- **Base Image**: Ubuntu 22.04 LTS
- **Architecture**: x86_64 (emulating System/370)
- **Memory**: Configurable (default: 1-2GB)
- **Storage**: Multiple DASD volumes

## Available Images

### GitHub Container Registry (GHCR)

- **Latest**: `ghcr.io/skunklabz/tk4-hercules:latest`
- **Versioned**: `ghcr.io/skunklabz/tk4-hercules:v1.01`
- **Branch**: `ghcr.io/skunklabz/tk4-hercules:main`

### Docker Hub

- **Latest**: `skunklabz/tk4-hercules:latest`
- **Versioned**: `skunklabz/tk4-hercules:v1.01`

## Development

### Prerequisites

- Docker and Docker Compose
- Git
- Make (optional, for convenience commands)

### Building Locally

```bash
# Clone the repository
git clone https://github.com/skunklabz/tk4-hercules.git
cd tk4-hercules

# Build the image
make build

# Start the container
make start
```

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

- **Issues**: [GitHub Issues](https://github.com/skunklabz/tk4-hercules/issues)
- **Discussions**: [GitHub Discussions](https://github.com/skunklabz/tk4-hercules/discussions)
- **Documentation**: [docs/](docs/) directory

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **TK4-**: The original Turnkey 4- system by Volker Bandke
- **Hercules**: The mainframe emulator by Jay Maynard and contributors
- **IBM**: For the original MVS 3.8j operating system
- **Mainframe Community**: For preserving and sharing mainframe knowledge

## Version History

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and changes.

---

**Note**: This is an educational project for learning mainframe computing concepts. The MVS 3.8j system is a historical artifact and should be used for educational purposes only.
