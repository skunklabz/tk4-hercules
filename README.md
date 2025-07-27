# Docker tk4-hercules
## The MVS 3.8j Tur(n)key 4- System on the Hercules Mainframe Emulator running inside a Docker container

This project containerizes the Hercules mainframe emulator running IBM MVS 3.8j (Turnkey 4-), providing an educational platform for learning about mainframe computing and historical IBM System/370 architecture.

## What is this?

**Hercules** is an open source software implementation of the mainframe System/370 and ESA/390 architectures, in addition to the latest 64-bit z/Architecture. Hercules runs under Linux, Windows, Solaris, FreeBSD, and Mac OS X.

**MVS 3.8j Tur(n)key 4- ("TK4-")** is a ready-to-use OS/VS2 MVS 3.8j system built specifically to run under the Hercules System/370, ESA/390, and z/Architecture Emulator. It is an extension of the original MVS Tur(n)key Version 3 System ("TK3") created by Volker Bandke in 2002.

## Prerequisites

Before running the container, you'll need a 3270 terminal emulator to connect to the mainframe:

### Linux
```bash
# Ubuntu/Debian
sudo apt-get install c3270

# CentOS/RHEL/Fedora
sudo yum install c3270
```

### macOS
```bash
brew install c3270
```

### Windows
Download and install [x3270](http://x3270.bgp.nu/) or use a web-based 3270 emulator.

## Quick Start

### Prerequisites: Obtaining TK4- Distribution

The TK4- distribution is available from the official source. You have several options:

1. **Option A: Automatic Download (Recommended)**
   - The Dockerfile will automatically download the distribution during build
   - Simply run `./build.sh` and the download will happen automatically

2. **Option B: Manual Download**
   - Download from: https://wotho.pebble-beach.ch/tk4-/tk4-_v1.00_current.zip (~238MB)
   - Place the file in the project root directory before building
   - Use `./download-tk4.sh` for additional download options

3. **Option C: Use Pre-built Image**
   - Use the pre-built Docker image: `docker pull skunklabz/tk4-hercules:latest`
   - Skip the build step and go directly to running the container

### Option 1: Using Docker Compose (Recommended)
The easiest way to get started with persistence:

```bash
# Clone the repository
git clone https://github.com/skunklabz/tk4-hercules.git
cd tk4-hercules

# Build the image (will automatically download TK4- distribution):
./build.sh

# Test the container:
./test.sh

# Start the container with persistence
docker-compose up -d

# View logs
docker-compose logs -f
```

### Option 2: Basic Usage (No Persistence)
To run this on your local machine simply run:

```bash
docker run -ti -p 3270:3270 -p 8038:8038 skunklabz/tk4-hercules
```

After about 5 minutes, you'll see the MVS console prompt where you can start learning about MVS 3.8j.

### Connecting to Your Mainframe

1. **Using 3270 Terminal Emulator:**
   ```bash
   c3270 localhost:3270
   ```

2. **Using Web Console:**
   Open your browser and navigate to `http://localhost:8038/`

### Logging into MVS

1. When you connect via 3270, you'll see the TSO login screen
2. Press Enter once
3. Use `herc01` as the username
4. Use `CUL8TR` as the password
5. Press Enter twice

Congratulations! You've successfully started a mainframe emulator, booted an operating system, and logged into your new mainframe environment.

## Running Your First Job

MVS 3.8j comes with several compilers including COBOL. Here's how to run a sample COBOL job:

> **Note**: The following step-by-step instructions are adapted from the excellent tutorial by [Bradrico Rigg](https://bradricorigg.medium.com/run-your-own-mainframe-using-hercules-mainframe-emulator-and-mvs-3-8j-tk4-55fa7c982553) on Medium.

1. From the TSO Applications screen, select `1` and press Enter to launch RFE
2. Select `3` and press Enter to launch the UTILITIES menu
3. Select `4` and press Enter to launch the RFE DSLIST menu
4. Type `SYS2` and press Enter to show files and directories
5. Navigate to `SYS2.JCLLIB` and type `V` then Enter
6. Use F8 to find the `TESTCOB` file
7. Navigate to the file and type `V` (all the way to the left), then press Enter
8. Type `submit` and press Enter to submit the job
9. Press Enter to return to the editor, then F3 six times to return to the main menu

The job output will be displayed on the Hercules console.

## Persistence Setup

To run with persistence so that you don't lose your data after stopping the docker container, use the following command:

```bash
docker run -d \
--mount source=tk4-conf,target=/tk4-/conf \
--mount source=tk4-local_conf,target=/tk4-/local_conf \
--mount source=tk4-local_scripts,target=/tk4-/local_scripts \
--mount source=tk4-prt,target=/tk4-/prt \
--mount source=tk4-dasd,target=/tk4-/dasd \
--mount source=tk4-pch,target=/tk4-/pch \
--mount source=tk4-jcl,target=/tk4-/jcl \
--mount source=tk4-log,target=/tk4-/log \
-p 3270:3270 \
-p 8038:8038 skunklabz/tk4-hercules
```

### Description of Persisted Directories

- **/tk4-/conf**
  - Master configuration file tk4-.cnf is stored here
- **/tk4-/local_conf**
  - Scripts for initialization and unattended operations
- **/tk4-/local_scripts**
  - 10 files for user-applied modifications, run after Hercules initialization
- **/tk4-/prt**
  - Simulated line printer devices output
- **/tk4-/pch**
  - Card punch devices output
- **/tk4-/dasd**
  - All simulated CKD DASD volumes (Count Key Data - direct-access storage device)
- **/tk4-/jcl**
  - SYSGEN Job Control Files
- **/tk4-/log**
  - Log files created during sysgen

## Educational Resources

### YouTube Videos
- **Containerizing the Mainframe**: https://youtu.be/uRf6A6_GWzw
- **Running on Azure Cloud Container Instances**: https://youtu.be/Y-JDRwk_wFY

### Additional Learning Resources
- [Hercules Main Page](http://www.hercules-390.eu/) - The main Hercules website
- [TK4- Download Page](http://wotho.ethz.ch/tk4-/) - Official TK4- distribution
- [Mosix Channel](https://www.youtube.com/user/mosix5760) - Excellent resource for MVS learning
- [Jay Moseley's Site](http://www.jaymoseley.com/) - Invaluable resource for MVS programming and system maintenance
- [Bradrico Rigg's MVS Tutorial](https://bradricorigg.medium.com/run-your-own-mainframe-using-hercules-mainframe-emulator-and-mvs-3-8j-tk4-55fa7c982553) - Comprehensive step-by-step guide for getting started with MVS 3.8j

## Troubleshooting

### Common Issues

1. **Container won't start**: Ensure ports 3270 and 8038 are not already in use
2. **Can't connect via 3270**: Verify your terminal emulator is properly installed
3. **Slow startup**: The system takes about 5 minutes to fully boot - this is normal
4. **Permission errors**: Ensure Docker has proper permissions to create volumes
5. **Architecture compatibility issues**: If you encounter binary compatibility errors:
   - On Apple Silicon (M1/M2): Try building with `docker build --platform linux/amd64`
   - On x86_64: Use the default build process
   - The TK4- distribution includes binaries for multiple architectures

### Logging Off

To properly log off from MVS:
1. Press F3 at the main TSO Applications menu
2. Type `logoff` and press Enter

### Stopping the Container

**If using Docker Compose:**
```bash
docker-compose down
```

**If using Docker run:**
```bash
# Find the container ID
docker ps

# Stop the container
docker stop <container-id>
```

## Technical Details

- **Base Image**: Ubuntu 22.04 LTS
- **Hercules Version**: 4.4.1
- **MVS Version**: 3.8j Service Level 8505
- **Architecture**: System/370 emulation
- **Terminal Protocol**: 3270
- **Web Console**: Port 8038
- **Resource Limits**: 2GB RAM, 2 CPU cores (configurable)
- **Security**: Non-root user creation, no-new-privileges flag
- **Logging**: JSON format with rotation (10MB max, 3 files)

## Build Process

### Available Scripts

- **`./download-tk4.sh`** - Helper script to find TK4- distribution sources
- **`./build.sh`** - Builds the Docker image with proper tagging
- **`./build-platform.sh`** - Platform-aware build script (recommended for Apple Silicon)
- **`./test.sh`** - Tests the container functionality and health

### Building from Source

1. **Build the Image (Recommended)**
   ```bash
   # For Apple Silicon (M1/M2) - Platform-aware build
   ./build-platform.sh
   
   # For x86_64 or standard build
   ./build.sh
   ```
   The Dockerfile will automatically download the TK4- distribution during the build process.

2. **Alternative: Manual Download**
   ```bash
   ./download-tk4.sh
   # Follow the instructions to download tk4-_v1.00_current.zip manually
   ./build.sh
   ```

3. **Test the Container**
   ```bash
   ./test.sh
   ```

4. **Run with Docker Compose**
   ```bash
   docker-compose up -d
   ```

## Recent Improvements (v1.01)

### Security Enhancements
- **LTS Upgrade**: Migrated from Ubuntu 18.04 to Ubuntu 22.04 LTS for extended security support
- **Non-root User**: Created dedicated `hercules` user for improved security
- **Security Options**: Added `no-new-privileges` flag to prevent privilege escalation
- **Certificate Updates**: Included `ca-certificates` package for secure downloads

### Performance & Resource Management
- **Resource Limits**: Configurable CPU and memory limits (2GB RAM, 2 CPU cores default)
- **Multi-stage Build**: Optimized Docker build process for smaller image size
- **Log Rotation**: JSON logging with automatic rotation (10MB max, 3 files)
- **Build Optimization**: Added `.dockerignore` for faster builds

### Container Best Practices
- **Health Checks**: Improved reliability with better process monitoring
- **Environment Variables**: Added version tracking and timezone configuration
- **Metadata**: Enhanced container labels for better management
- **Error Handling**: Better download verification and error reporting

### Architecture Compatibility
- **Platform Support**: Enhanced support for ARM64 (Apple Silicon) and x86_64 architectures
- **Cross-platform Builds**: Improved build process for different CPU architectures

## Contributing

This project follows trunk-based development:
- Create feature branches from `main`
- Use descriptive branch names: `feature/description` or `fix/description`
- Submit pull requests for all changes
- Ensure thorough testing before merging

## License

This project is open source and follows the licensing terms of the original Hercules and TK4- distributions.
