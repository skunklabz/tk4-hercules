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

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    file \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /tk4-/

# Copy TK4- distribution from builder stage
COPY --from=builder /tk4-/ .

# Set up Hercules binary for the correct architecture
RUN chmod +x hercules/linux/64/bin/hercules

# Ensure mvs script exists and is executable
RUN chmod +x mvs

# Fix mvs script for ARM64 compatibility
COPY mvs.fixed mvs

# Ensure mvs script is executable
RUN chmod +x mvs

# Verify Hercules binary exists and is executable
RUN chmod +x hercules/linux/64/bin/hercules

# Ubuntu already has proper glibc libraries for x86_64

# Create non-root user for security
RUN groupadd -g 1000 hercules && \
    useradd -m -s /bin/bash -u 1000 -g hercules hercules && \
    chown -R hercules:hercules .

# Create persistence directories and set ownership
RUN mkdir -p conf local_conf local_scripts prt dasd pch jcl log && \
    chown -R hercules:hercules .

# Define volume mount points for persistence
VOLUME [ "conf", "local_conf", "local_scripts", "prt", "dasd", "pch", "jcl", "log" ]

# Expose ports for 3270 terminal and web console
EXPOSE 3270 8038

# Monitor MVS process health
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
    CMD ps aux | grep -v grep | grep mvs || exit 1

# Create a startup script for MVS
RUN echo '#!/bin/bash' > startup.sh && \
    echo 'set -e' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "=== TK4- Hercules Startup ==="' >> startup.sh && \
    echo 'echo "Starting MVS mainframe system..."' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "Checking mvs script..."' >> startup.sh && \
    echo 'if [ -f "./mvs" ]; then' >> startup.sh && \
    echo '    echo "mvs script found and executable"' >> startup.sh && \
    echo 'else' >> startup.sh && \
    echo '    echo "ERROR: mvs script not found!"' >> startup.sh && \
    echo '    exit 1' >> startup.sh && \
    echo 'fi' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "Checking Hercules binary..."' >> startup.sh && \
    echo 'if [ -f "./hercules/linux/64/bin/hercules" ]; then' >> startup.sh && \
    echo '    echo "Hercules binary found"' >> startup.sh && \
    echo 'else' >> startup.sh && \
    echo '    echo "ERROR: Hercules binary not found!"' >> startup.sh && \
    echo '    exit 1' >> startup.sh && \
    echo 'fi' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "Starting MVS..."' >> startup.sh && \
    echo 'exec ./mvs' >> startup.sh

RUN chmod +x startup.sh

# Use the startup script for proper MVS execution
# This starts the actual MVS mainframe system
CMD ["./startup.sh"]
