FROM ubuntu:18.04 as builder

RUN apt-get update && apt-get install -yq unzip
WORKDIR /tk4/
ADD http://wotho.ethz.ch/tk4-/tk4-_v1.00_current.zip /tk4/
RUN unzip tk4-_v1.00_current.zip && \
    rm -rf /tk4/tk4-_v1.00_current.zip
RUN echo "CONSOLE">/tk4/unattended/mode
RUN rm -rf /tk4/hercules/darwin && \
    rm -rf /tk4/hercules/windows && \
    rm -rf /tk4/hercules/source 

FROM ubuntu:18.04
WORKDIR /tk4/
COPY --from=builder /tk4/ .
CMD ["/tk4/mvs"]
EXPOSE 3270 8038