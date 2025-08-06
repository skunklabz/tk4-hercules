
FROM ubuntu:22.04

# Install build dependencies (layered for cache efficiency)
RUN apt-get update && \
    apt-get install -y git build-essential autoconf automake libtool gawk libcap2-bin libbz2-dev zlib1g-dev libssl-dev libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libsdl2-mixer-dev libncurses5-dev libpcap-dev libcurl4-openssl-dev

# Clone and build SDL Hercules (separate layer)
RUN git clone https://github.com/SDL-Hercules-390/hyperion.git /tmp/hercules && \
    cd /tmp/hercules && \
    ./autogen.sh && \
    ./configure --prefix=/opt/hercules && \
    make && \
    make install && \
    rm -rf /tmp/hercules

# Clean up apt cache (separate layer)
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# Set environment
ARG HERCULES=/opt/hercules
ARG TK5=/opt/tk5


# Copy TK5 system (app code changes most often)
COPY ./external/mvs-tk5/mvs-tk5 $TK5


# Make Hercules web Interface available inside TK5 as referenced by config
RUN mkdir -p $TK5/hercules && ln -s $HERCULES/share/hercules $TK5/hercules/httproot


# Copy Hercules config file for TK5
COPY ./external/mvs-tk5/mvs-tk5/conf/tk5.cnf /opt/hercules/hercules.cnf

# Expose required ports
EXPOSE 3270/tcp
EXPOSE 8038/tcp


# Set working directory and define the default entrypoint
VOLUME $TK5/dasd.usr
WORKDIR $TK5
ENTRYPOINT ["./mvs"]

# Copy Hercules config file for TK5
COPY ./external/mvs-tk5/mvs-tk5/conf/tk5.cnf /opt/hercules/hercules.cnf