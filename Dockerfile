# Multi-stage build to minimize final image size
FROM ubuntu:18.04 as builder

# Install required packages for building
RUN apt-get update && apt-get install -yq \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /tk4-/

# Download TK4- distribution with better error handling
RUN wget -O tk4-_v1.00_current.zip http://wotho.ethz.ch/tk4-/tk4-_v1.00_current.zip \
    && unzip tk4-_v1.00_current.zip \
    && rm -rf tk4-_v1.00_current.zip

# Configure for console mode operation
RUN echo "CONSOLE" > /tk4-/unattended/mode

# Remove unnecessary platform-specific binaries to reduce image size
RUN rm -rf /tk4-/hercules/darwin \
    && rm -rf /tk4-/hercules/windows \
    && rm -rf /tk4-/hercules/source

# Final runtime image
FROM ubuntu:18.04

# Metadata
LABEL maintainer="Ken Godoy - skunklabz"
LABEL version="1.00"
LABEL description="OS/VS2 MVS 3.8j Service Level 8505, Tur(n)key Level 4- Version 1.00"
LABEL org.opencontainers.image.source="https://github.com/skunklabz/tk4-hercules"
LABEL org.opencontainers.image.licenses="MIT"

# Set working directory
WORKDIR /tk4-/

# Copy built application from builder stage
COPY --from=builder /tk4-/ .

# Create non-root user for security (optional - Hercules may require root)
# RUN useradd -r -s /bin/bash hercules
# USER hercules

# Define volume mount points for persistence
# These correspond to the 8 key directories that need to persist
VOLUME [ "/tk4-/conf", "/tk4-/local_conf", "/tk4-/local_scripts", "/tk4-/prt", "/tk4-/dasd", "/tk4-/pch", "/tk4-/jcl", "/tk4-/log" ]

# Expose ports for 3270 terminal and web console
EXPOSE 3270 8038

# Health check to verify the container is running properly
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
    CMD ps aux | grep -v grep | grep mvs || exit 1

# Start the MVS system
CMD ["/tk4-/mvs"]
