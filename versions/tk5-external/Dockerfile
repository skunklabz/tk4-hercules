# *********************************************************************
# Run TK5 (MVS 3.8j) in Docker container - LOCAL VERSION
# *********************************************************************
#
# Use Ubuntu base with Hercules for AMD64 compatibility
#
FROM ubuntu:22.04

# Install Hercules and dependencies
RUN apt-get update && apt-get install -y \
    hercules \
    libncurses5 \
    libssl3 \
    zlib1g \
    libbz2-1.0 \
    liblzma5 \
    libreadline8 \
    libsqlite3-0 \
    libcurl4 \
    libpcap0.8 \
    libsdl2-2.0-0 \
    libsdl2-image-2.0-0 \
    libsdl2-ttf-2.0-0 \
    libsdl2-mixer-2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set environment
ARG HERCULES=/usr/local
ARG TK5=/opt/tk5

# Copy TK5 and Hercules from submodule
COPY ./external/mvs-tk5/mvs-tk5 $TK5
RUN mkdir -p $TK5/hercules

# Make Hercules web Interface available inside TK5 as reference by
# the default configuration scripts
RUN ln -s $HERCULES/share/hercules $TK5/hercules/httproot

# Make required Ports available
EXPOSE 3270/tcp
EXPOSE 8038/tcp

# Set working directory and define the default entrypoint into the
# container to launch TK5 when starting the container
VOLUME $TK5/dasd.usr
WORKDIR $TK5
ENTRYPOINT [ "./mvs" ] 