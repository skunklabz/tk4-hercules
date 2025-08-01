# Multi-stage build to minimize final image size
FROM ubuntu:22.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tk5-/

# Download TK5- distribution from prince-webdesign.nl
# Complete system with Update 4 included
RUN wget --no-check-certificate -O mvs-tk5.zip https://www.prince-webdesign.nl/images/downloads/mvs-tk5.zip && \
    unzip mvs-tk5.zip && \
    rm mvs-tk5.zip

# Final stage
FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    file \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /tk5-/

# Copy TK5- distribution from builder stage
COPY --from=builder /tk5-/ .

# Set up Hercules 4.60 binary for the correct architecture
RUN chmod +x hercules/linux/64/bin/hercules

# Ensure mvs script exists and is executable
RUN chmod +x mvs

# Create 15 volume mount points for TK5-
RUN mkdir -p tk5res tk5cat tk5dlb tk5001 tk5002 \
    tso001 tso002 tso003 work01 work02 work03 work04 \
    int001 page00 spool0

# Create non-root user for security
RUN groupadd -g 1000 hercules && \
    useradd -m -s /bin/bash -u 1000 -g hercules hercules && \
    chown -R hercules:hercules .

# Define volume mount points for TK5- (15 volumes)
VOLUME [ "tk5res", "tk5cat", "tk5dlb", "tk5001", "tk5002", \
         "tso001", "tso002", "tso003", "work01", "work02", \
         "work03", "work04", "int001", "page00", "spool0" ]

# Expose ports for 3270 terminal and web console
EXPOSE 3270 8038

# Monitor MVS process health
HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
    CMD ps aux | grep -v grep | grep mvs || exit 1

# Create a startup script for MVS
RUN echo '#!/bin/bash' > startup.sh && \
    echo 'set -e' >> startup.sh && \
    echo '' >> startup.sh && \
    echo 'echo "=== TK5- Hercules Startup ==="' >> startup.sh && \
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