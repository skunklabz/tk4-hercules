FROM praths/sdl-hercules-390:latest

# Set environment
ARG HERCULES=/opt/hercules
ARG TK5=/opt/tk5

# Copy TK5 and Hercules
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