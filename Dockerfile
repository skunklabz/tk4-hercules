# Multi-stage build to minimize final image size
FROM ubuntu:22.04 AS builder

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install build dependencies with security updates
RUN apt-get update && apt-get upgrade -yq && apt-get install -yq \
    unzip \
    wget \
    ca-certificates \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tk4-/

# Download TK4- distribution from the official source
RUN echo "Downloading TK4- distribution from https://wotho.pebble-beach.ch/tk4-/" && \
    wget --no-check-certificate -O tk4-_v1.00_current.zip https://wotho.pebble-beach.ch/tk4-/tk4-_v1.00_current.zip && \
    echo "Verifying download..." && \
    ls -la tk4-_v1.00_current.zip && \
    unzip tk4-_v1.00_current.zip && \
    rm -rf tk4-_v1.00_current.zip

# Configure for console mode operation
RUN if [ -d /tk4-/unattended ]; then \
        echo "CONSOLE" > /tk4-/unattended/mode; \
    fi

# Remove unnecessary platform-specific binaries to reduce image size
RUN if [ -d /tk4-/hercules ]; then \
        rm -rf /tk4-/hercules/darwin && \
        rm -rf /tk4-/hercules/windows && \
        rm -rf /tk4-/hercules/source; \
    fi

# Final runtime image
FROM ubuntu:22.04

# Prevent interactive prompts and set version information
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV HERCULES_VERSION="4.4.1"
ENV MVS_VERSION="3.8j"

# Install runtime libraries for cross-platform compatibility
RUN apt-get update && apt-get install -yq \
    libc6 \
    libstdc++6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Metadata
LABEL maintainer="SKUNKLABZ"
LABEL version="1.01"
LABEL description="OS/VS2 MVS 3.8j Service Level 8505, Tur(n)key Level 4- Version 1.00 on Ubuntu 22.04 LTS"
LABEL org.opencontainers.image.source="https://github.com/skunklabz/tk4-hercules"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="${MVS_VERSION}"
LABEL org.opencontainers.image.title="TK4- Hercules Mainframe Emulator"

WORKDIR /tk4-/

# Copy TK4- distribution from builder stage
COPY --from=builder /tk4-/ .

# Create non-root user for security (Hercules may require root for some operations)
RUN groupadd -r hercules && useradd -r -g hercules -s /bin/bash hercules \
    && chown -R hercules:hercules /tk4-/

# Create persistence directories and set ownership
RUN mkdir -p /tk4-/conf /tk4-/local_conf /tk4-/local_scripts /tk4-/prt /tk4-/dasd /tk4-/pch /tk4-/jcl /tk4-/log \
    && chown -R hercules:hercules /tk4-/

# Define volume mount points for persistence
# These correspond to the 8 key directories that need to persist
VOLUME [ "/tk4-/conf", "/tk4-/local_conf", "/tk4-/local_scripts", "/tk4-/prt", "/tk4-/dasd", "/tk4-/pch", "/tk4-/jcl", "/tk4-/log" ]

# Expose ports for 3270 terminal and web console
EXPOSE 3270 8038

# Monitor MVS process health
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
    CMD ps aux | grep -v grep | grep mvs || exit 1

# Hercules may require root access for device emulation
# USER hercules

CMD ["/tk4-/mvs"]
