# TK5 External - Local Version

This is a local version of the TK5 (MVS 3.8j) Docker implementation that uses Ubuntu 22.04 as the base image and installs Hercules from the package manager, ensuring AMD64 compatibility.

## Differences from Original

- **Base Image**: Uses `ubuntu:22.04` instead of `praths/sdl-hercules-390:latest`
- **Hercules Installation**: Installs Hercules from Ubuntu package manager instead of using a pre-built image
- **Platform Compatibility**: Designed for AMD64 architecture (no ARM64 dependencies)
- **Submodule Usage**: Copies content from the `external/mvs-tk5` submodule without modifying it

## Usage

### Using docker-compose (recommended)

```bash
# Build and start the container
MVS_VERSION=tk5-external docker-compose up -d

# Stop the container
docker-compose down
```

### Using Docker directly

```bash
# Build the image
docker build --platform linux/amd64 -f versions/tk5-external/Dockerfile -t tkx-hercules:tk5-external .

# Run the container
docker run -d --name tk5-external -p 3270:3270 -p 8038:8038 tkx-hercules:tk5-external
```

## Features

- ✅ AMD64 compatibility
- ✅ Uses Ubuntu 22.04 base image
- ✅ Hercules installed from package manager
- ✅ All TK5 functionality preserved
- ✅ Submodule content remains untouched
- ✅ Same volume structure as original TK5

## Ports

- **3270**: 3270 terminal access
- **8038**: Web console access

## Volumes

The same volume structure as the original TK5 implementation is supported:

- `tk5-dasd-usr`: User DASD volumes
- `tk5-log`: System logs
- `tk5-tape`: Tape devices
- `tk5-prt`: Printers
- `tk5-pch`: Card readers
- `tk5-jcl`: JCL files

## Environment Variables

- `TZ=UTC`: Timezone setting
- `HERCULES_VERSION=4.60`: Hercules version
- `MVS_VERSION=3.8j-tk5-external`: MVS version identifier 