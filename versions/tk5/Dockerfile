# Multi-stage build for AMD64-compatible TK5
FROM ubuntu:22.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    unzip \
    ca-certificates \
    libssl-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libz-dev \
    libbz2-dev \
    libltdl-dev \
    libtool \
    autoconf \
    automake \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Build Hercules from source
WORKDIR /tmp
RUN git clone https://github.com/SDL-Hercules-390/hyperion.git && \
    cd hyperion && \
    ./autogen.sh && \
    ./configure --enable-optimization --enable-cckd-bzip2 --enable-het-bzip2 && \
    make -j$(nproc) && \
    make install

# Final stage
FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    file \
    libssl3 \
    libncurses6 \
    libreadline8 \
    libz1 \
    libbz2-1.0 \
    libltdl7 \
    && rm -rf /var/lib/apt/lists/*

# Copy Hercules from builder stage
COPY --from=builder /usr/local/bin/hercules /usr/local/bin/
COPY --from=builder /usr/local/lib/libherc* /usr/local/lib/
COPY --from=builder /usr/local/share/hercules /usr/local/share/hercules

# Set environment
ARG TK5=/opt/tk5

# Copy TK5 from patrickraths submodule
COPY external/mvs-tk5/mvs-tk5 $TK5

# Create hercules directory and link
RUN mkdir -p $TK5/hercules/bin && \
    ln -s /usr/local/bin/hercules $TK5/hercules/bin/hercules

# Create additional volume mount points for our extended structure
RUN mkdir -p $TK5/tk5res $TK5/tk5cat $TK5/tk5dlb $TK5/tk5001 $TK5/tk5002 \
    $TK5/tso001 $TK5/tso002 $TK5/tso003 $TK5/work01 $TK5/work02 $TK5/work03 $TK5/work04 \
    $TK5/int001 $TK5/page00 $TK5/spool0

# Create non-root user for security
RUN groupadd -g 1000 hercules && \
    useradd -m -s /bin/bash -u 1000 -g hercules hercules && \
    chown -R hercules:hercules $TK5

# Make required Ports available
EXPOSE 3270/tcp
EXPOSE 8038/tcp

# Set working directory and define the default entrypoint
WORKDIR $TK5
USER hercules
ENTRYPOINT [ "./mvs" ] 