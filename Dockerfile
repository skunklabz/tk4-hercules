# Multi-stage build to minimize final image size
FROM alpine:3.19 AS builder

# Install build dependencies
RUN apk add --no-cache \
    wget \
    unzip \
    ca-certificates

WORKDIR /tk4-/

# Download TK4- distribution from the official source
RUN wget --no-check-certificate -O tk4-_v1.00_current.zip https://wotho.pebble-beach.ch/tk4-/tk4-_v1.00_current.zip && \
    unzip tk4-_v1.00_current.zip && \
    rm tk4-_v1.00_current.zip

# Configure for console mode operation
RUN if [ -d /tk4-/unattended ]; then \
        echo "CONSOLE" > /tk4-/unattended/mode; \
    fi

# Remove unnecessary platform-specific binaries and files to reduce image size
RUN if [ -d /tk4-/hercules ]; then \
        rm -rf /tk4-/hercules/darwin && \
        rm -rf /tk4-/hercules/windows && \
        rm -rf /tk4-/hercules/source && \
        rm -rf /tk4-/hercules/*.txt && \
        rm -rf /tk4-/hercules/*.md; \
    fi

# Remove unnecessary architecture binaries (keep only appropriate binaries for current platform)
RUN if [ -d /tk4-/hercules/linux ]; then \
        rm -rf /tk4-/hercules/linux/32; \
        # Keep appropriate binaries based on architecture \
        if [ "$(uname -m)" = "x86_64" ]; then \
            echo "Removing ARM binaries for x86_64 build"; \
            rm -rf /tk4-/hercules/linux/arm && \
            rm -rf /tk4-/hercules/linux/arm_softfloat; \
        elif [ "$(uname -m)" = "aarch64" ]; then \
            echo "Keeping x86_64 binaries for ARM64 build (will use emulation)"; \
            rm -rf /tk4-/hercules/linux/arm && \
            rm -rf /tk4-/hercules/linux/arm_softfloat; \
        fi; \
    fi

# Remove documentation and unnecessary files
RUN find /tk4-/ -name "*.txt" -delete && \
    find /tk4-/ -name "*.md" -delete && \
    find /tk4-/ -name "*.pdf" -delete && \
    find /tk4-/ -name "*.doc" -delete && \
    find /tk4-/ -name "*.docx" -delete && \
    find /tk4-/ -name "README*" -delete && \
    find /tk4-/ -name "*.html" -delete && \
    find /tk4-/ -name "*.htm" -delete

# Remove unnecessary demo files and documentation
RUN rm -rf /tk4-/ctca_demo && \
    rm -rf /tk4-/doc

# Final runtime image - using Alpine for minimal size
FROM alpine:3.19

# Set version information
ENV HERCULES_VERSION="4.4.1"
ENV MVS_VERSION="3.8j"

# Install only essential runtime libraries
RUN apk add --no-cache \
    libc6-compat \
    libstdc++ \
    bash \
    bzip2 \
    libbz2 \
    binutils \
    file \
    && rm -rf /var/cache/apk/*

# Install QEMU for ARM emulation on ARM64 builds
RUN if [ "$(uname -m)" = "aarch64" ]; then \
        echo "Installing QEMU for ARM emulation on ARM64..."; \
        apk add --no-cache \
            qemu-arm \
            && rm -rf /var/cache/apk/*; \
    fi

# Create symlinks for missing libraries
RUN ln -sf /lib/libc.so.6 /lib/libnsl.so.1 || true

# Metadata
LABEL maintainer="SKUNKLABZ"
LABEL version="1.1.0"
LABEL description="OS/VS2 MVS 3.8j Service Level 8505, Tur(n)key Level 4- Version 1.00 on Alpine Linux"
LABEL org.opencontainers.image.source="https://github.com/skunklabz/tk4-hercules"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="${MVS_VERSION}"
LABEL org.opencontainers.image.title="TK4- Hercules Mainframe Emulator"

WORKDIR /tk4-/

# Copy TK4- distribution from builder stage
COPY --from=builder /tk4-/ .

# Set up Hercules binary for the correct architecture
RUN if [ "$(uname -m)" = "x86_64" ]; then \
        echo "Setting up Hercules for x86_64"; \
        ln -sf /tk4-/hercules/linux/64/bin/hercules /tk4-/hercules; \
    elif [ "$(uname -m)" = "aarch64" ]; then \
        echo "Setting up Hercules for ARM64 (using x86_64 binaries with emulation)"; \
        ln -sf /tk4-/hercules/linux/64/bin/hercules /tk4-/hercules; \
    else \
        echo "Unknown architecture $(uname -m), using 64-bit x86"; \
        ln -sf /tk4-/hercules/linux/64/bin/hercules /tk4-/hercules; \
    fi

# Note: ARM64 support uses x86_64 binaries with emulation
# The startup script will automatically detect architecture and use appropriate binaries

# Create non-root user for security
RUN addgroup -g 1000 hercules && \
    adduser -D -s /bin/sh -u 1000 -G hercules hercules && \
    chown -R hercules:hercules /tk4-/

# Create persistence directories and set ownership
RUN mkdir -p /tk4-/conf /tk4-/local_conf /tk4-/local_scripts /tk4-/prt /tk4-/dasd /tk4-/pch /tk4-/jcl /tk4-/log && \
    chown -R hercules:hercules /tk4-/

# Define volume mount points for persistence
VOLUME [ "/tk4-/conf", "/tk4-/local_conf", "/tk4-/local_scripts", "/tk4-/prt", "/tk4-/dasd", "/tk4-/pch", "/tk4-/jcl", "/tk4-/log" ]

# Expose ports for 3270 terminal and web console
EXPOSE 3270 8038

# Monitor MVS process health
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
    CMD ps aux | grep -v grep | grep mvs || exit 1

# Hercules may require root access for device emulation
# USER hercules

CMD ["./mvs"]
