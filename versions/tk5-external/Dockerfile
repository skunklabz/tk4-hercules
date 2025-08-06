FROM ubuntu:22.04

# Install build dependencies and SDL Hercules
RUN apt-get update && \
    apt-get install -y git build-essential autoconf automake libtool gawk libcap2-bin libbz2-dev zlib1g-dev libssl-dev && \
    git clone https://github.com/SDL-Hercules-390/hyperion.git /tmp/hercules && \
    cd /tmp/hercules && \
    ./autogen.sh && \
    ./configure --prefix=/opt/hercules && \
    make && \
    make install && \
    rm -rf /tmp/hercules && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment
ARG HERCULES=/opt/hercules
ARG TK5=/opt/tk5

# Copy TK5 system
COPY ./external/mvs-tk5/mvs-tk5 $TK5

# Make Hercules web Interface available inside TK5 as referenced by config
RUN ln -s $HERCULES/share/hercules $TK5/hercules/httproot

# Expose required ports
EXPOSE 3270/tcp
EXPOSE 8038/tcp

# Set working directory and define the default entrypoint
VOLUME $TK5/dasd.usr
WORKDIR $TK5
ENTRYPOINT ["./mvs"]

# Copy Hercules config file for TK5
COPY ./external/mvs-tk5/mvs-tk5/conf/tk5.cnf /opt/hercules/hercules.cnf