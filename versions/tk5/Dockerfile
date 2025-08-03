# *********************************************************************
# Run TK5- (MVS 3.8j) in Docker container
# *********************************************************************
#
# Use SDL Hercules 4.5 as base container
#
FROM praths/sdl-hercules-390:latest
#
# Set environment
#
ARG HERCULES=/opt/hercules
ARG TK5=/opt/tk5
#
# Copy TK5 and Hercules
#
COPY external/mvs-tk5/mvs-tk5 $TK5
RUN mkdir -p $TK5/hercules
#
# Make Hercules web Interface available inside TK5- as reference by
# the default configuration scripts
#
RUN ln -s $HERCULES/share/hercules $TK5/hercules/httproot
#
# Make required Ports available
#
EXPOSE 3270/tcp
EXPOSE 8038/tcp
#
# Set working directory and define the default entrypoint into the
# container to launch TK5- when starting the container
VOLUME $TK5/dasd.usr
WORKDIR $TK5
ENTRYPOINT [ "./mvs" ] 