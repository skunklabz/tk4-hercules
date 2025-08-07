# TK5 with SDL-Hercules-390 (x86_64)

This directory contains the Docker setup for running MVS TK5 using SDL-Hercules-390 (Hyperion) instead of the standard Hercules emulator. This version is specifically built for x86_64/AMD64 architecture.

## What is SDL-Hercules-390?

SDL-Hercules-390 is a modern, actively maintained fork of the Hercules mainframe emulator. It includes:

- Enhanced performance and stability
- Better ARM64 support
- Modern build system
- Active development community

For more information, visit:
- [SDL-Hercules-390 Documentation](https://sdl-hercules-390.github.io/html/)
- [SDL-Hercules-390 GitHub Repository](https://github.com/SDL-Hercules-390/hyperion)

## Files

- `Dockerfile.sdl-hercules` - Multi-stage Dockerfile that builds SDL-Hercules-390 and sets up TK5
- `docker-compose.sdl-hercules.yml` - Docker Compose configuration for the SDL-Hercules-390 version
- `README-SDL-Hercules.md` - This documentation file

## Building and Running

### Using Docker Compose (Recommended)

```bash
# Build and start the SDL-Hercules-390 version
docker-compose -f versions/tk5/docker-compose.sdl-hercules.yml up --build

# Run in background
docker-compose -f versions/tk5/docker-compose.sdl-hercules.yml up -d --build

# Stop the container
docker-compose -f versions/tk5/docker-compose.sdl-hercules.yml down
```

### Using Docker directly

```bash
# Build the image
docker build -f versions/tk5/Dockerfile.sdl-hercules -t tk5-sdl-hercules .

# Run the container
docker run -it --name tk5-sdl-hercules \
  -p 3270:3270 \
  -p 8038:8038 \
  --cap-add=SYS_NICE \
  tk5-sdl-hercules
```

## Differences from Standard TK5

1. **Build Process**: Uses a multi-stage build to compile SDL-Hercules-390 from source
2. **Architecture**: Specifically built for x86_64/AMD64 architecture
3. **Performance**: Potentially better performance and compatibility on x86_64 systems
4. **Capabilities**: Includes additional system capabilities for better emulation
5. **Dependencies**: Includes additional runtime dependencies for SDL-Hercules-390

## Ports

- `3270` - Mainframe 3270 terminal access
- `8038` - Hercules web interface

## Volumes

- `tk5-dasd-usr` - Persistent storage for user DASD volumes

## Troubleshooting

### Build Issues

If you encounter build issues:

1. Ensure you have sufficient disk space (build requires several GB)
2. Check that all submodules are properly initialized:
   ```bash
   git submodule update --init --recursive
   ```
3. Verify the SDL-Hercules-390 submodule is present:
   ```bash
   ls -la external/sdl-hercules-390/
   ```

### Runtime Issues

1. **Permission Issues**: The container requires `SYS_NICE` capability for optimal performance
2. **Port Conflicts**: Ensure ports 3270 and 8038 are not in use by other services
3. **Memory**: SDL-Hercules-390 may require more memory than standard Hercules

## Comparison with Standard TK5

| Feature | Standard TK5 | TK5 with SDL-Hercules-390 |
|---------|--------------|---------------------------|
| Build Time | Fast | Slower (compiles from source) |
| Image Size | Smaller | Larger (includes build tools) |
| Performance | Good | Potentially better |
| Architecture | Multi-arch | x86_64/AMD64 specific |
| Maintenance | Package-based | Source-based |

## Contributing

To contribute to the SDL-Hercules-390 integration:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This integration follows the same license as the main project. SDL-Hercules-390 is licensed under the Q Public License. 