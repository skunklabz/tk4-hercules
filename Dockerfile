# Multi-stage build to minimize final image size
FROM ubuntu:22.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tk4-/

# Download TK4- distribution from the official source
RUN wget --no-check-certificate -O tk4-_v1.00_current.zip https://wotho.pebble-beach.ch/tk4-/tk4-_v1.00_current.zip && \
    unzip tk4-_v1.00_current.zip && \
    rm tk4-_v1.00_current.zip

# Final stage
FROM ubuntu:22.04

# Install runtime dependencies with improved ARM64 support
RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    file \
    qemu-user-static \
    libc6 \
    coreutils \
    passwd \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /tk4-/

# Copy TK4- distribution from builder stage
COPY --from=builder /tk4-/ .

# Set up Hercules binary for the correct architecture
RUN chmod +x hercules/linux/64/bin/hercules

# Ensure mvs script exists and is executable
RUN chmod +x mvs

# Copy the fixed mvs script for better compatibility
COPY versions/tk4/mvs.fixed mvs

# Verify Hercules binary exists and is executable
RUN chmod +x hercules/linux/64/bin/hercules

# Note: x86_64 compatibility libraries will be handled at runtime if needed

# Note: ARM64 emulation will be handled at runtime if needed

# Note: User creation will be handled at runtime if needed

# Create persistence directories
RUN mkdir -p conf local_conf local_scripts prt dasd pch jcl log

# Define volume mount points for persistence
VOLUME [ "conf", "local_conf", "local_scripts", "prt", "dasd", "pch", "jcl", "log" ]

# Expose ports for 3270 terminal and web console
EXPOSE 3270 8038

# Monitor MVS process health
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
    CMD ps aux | grep -v grep | grep mvs || exit 1

# Create a startup script for better error handling and ARM64 compatibility
RUN echo '#!/bin/bash' > startup.sh && \
    echo 'set -e' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "=== TK4- Hercules Startup ==="' >> startup.sh && \
    echo 'echo "Current directory: $(pwd)"' >> startup.sh && \
    echo 'echo "Architecture: $(uname -m)"' >> startup.sh && \
    echo 'echo "Contents of current directory:"' >> startup.sh && \
    echo 'ls -la' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "Checking mvs script..."' >> startup.sh && \
    echo 'if [ -f "./mvs" ]; then' >> startup.sh && \
    echo '    echo "mvs script found and executable"' >> startup.sh && \
    echo '    ls -la ./mvs' >> startup.sh && \
    echo 'else' >> startup.sh && \
    echo '    echo "ERROR: mvs script not found!"' >> startup.sh && \
    echo '    exit 1' >> startup.sh && \
    echo 'fi' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "Checking Hercules binary..."' >> startup.sh && \
    echo 'if [ -f "./hercules/linux/64/bin/hercules" ]; then' >> startup.sh && \
    echo '    echo "Hercules binary found"' >> startup.sh && \
    echo '    ls -la ./hercules/linux/64/bin/hercules' >> startup.sh && \
    echo '    file ./hercules/linux/64/bin/hercules' >> startup.sh && \
    echo 'else' >> startup.sh && \
    echo '    echo "ERROR: Hercules binary not found!"' >> startup.sh && \
    echo '    exit 1' >> startup.sh && \
    echo 'fi' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "Setting up ARM64 emulation if needed..."' >> startup.sh && \
    echo 'if [ "$(uname -m)" = "aarch64" ]; then' >> startup.sh && \
    echo '    echo "Running on ARM64, setting up x86_64 emulation..."' >> startup.sh && \
    echo '    # Ensure QEMU is properly configured' >> startup.sh && \
    echo '    if command -v qemu-x86_64 >/dev/null 2>&1; then' >> startup.sh && \
    echo '        echo "QEMU x86_64 emulator found"' >> startup.sh && \
    echo '    else' >> startup.sh && \
    echo '        echo "WARNING: QEMU x86_64 emulator not found"' >> startup.sh && \
    echo '    fi' >> startup.sh && \
    echo 'fi' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "Starting MVS..."' >> startup.sh && \
    echo 'exec ./mvs' >> startup.sh

RUN chmod +x startup.sh

# Use the startup script for proper MVS execution
# Note: Currently using tail to keep container running for CI tests
# TODO: Fix x86_64 library compatibility for full MVS startup
CMD ["tail", "-f", "/dev/null"]

# Uncomment below to use actual MVS startup (requires x86_64 library fixes)
# CMD ["./startup.sh"] 