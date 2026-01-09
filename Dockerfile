# TK4-Hercules Docker Image

FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tk4-

RUN wget --no-check-certificate -O tk4.zip https://wotho.pebble-beach.ch/tk4-/tk4-_v1.00_current.zip && \
    unzip tk4.zip && \
    rm tk4.zip

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tk4-

COPY --from=builder /tk4- .

RUN chmod +x hercules/linux/64/bin/hercules && \
    mv mvs mvs.original

COPY scripts/startup.sh .
RUN chmod +x startup.sh

RUN mkdir -p conf dasd log
VOLUME ["/tk4-/conf", "/tk4-/dasd", "/tk4-/log"]

EXPOSE 3270 8038

CMD ["./startup.sh"]

