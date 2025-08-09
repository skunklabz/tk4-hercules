# TK4-Hercules Dockerfile (version-specific)

FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tk4-/

# Download TK4- distribution
RUN wget --no-check-certificate -O tk4-_v1.00_current.zip https://wotho.pebble-beach.ch/tk4-/tk4-_v1.00_current.zip && \
    unzip tk4-_v1.00_current.zip && \
    rm tk4-_v1.00_current.zip

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    file \
    qemu-user-static \
    libc6 \
    coreutils \
    passwd \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tk4-/

COPY --from=builder /tk4-/ .

# Ensure binaries are executable
RUN chmod +x hercules/linux/64/bin/hercules && \
    chmod +x mvs || true

# Replace mvs script with fixed version
COPY config/mvs.fixed mvs
RUN chmod +x mvs

# Create persistence directories
RUN mkdir -p conf local_conf local_scripts prt dasd pch jcl log

VOLUME [ "conf", "local_conf", "local_scripts", "prt", "dasd", "pch", "jcl", "log" ]

EXPOSE 3270 8038

HEALTHCHECK --interval=30s --timeout=10s --start-period=300s --retries=3 \
    CMD ps aux | grep -v grep | grep mvs || exit 1

RUN echo '#!/bin/bash' > startup.sh && \
    echo 'set -e' >> startup.sh && \
    echo 'exec ./mvs' >> startup.sh && \
    chmod +x startup.sh

CMD ["./startup.sh"]

