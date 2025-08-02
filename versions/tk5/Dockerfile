# Use patrickraths' working TK5- implementation
# Based on https://github.com/patrickraths/MVS-TK5
FROM praths/sdl-hercules-390:latest

# Set environment
ARG HERCULES=/opt/hercules
ARG TK5=/opt/tk5

# Copy TK5 from patrickraths submodule
COPY external/mvs-tk5/mvs-tk5 $TK5
RUN mkdir -p $TK5/hercules

# Make Hercules web Interface available inside TK5- as reference by
# the default configuration scripts
RUN ln -s $HERCULES/share/hercules $TK5/hercules/httproot

# Create additional volume mount points for our extended structure
RUN mkdir -p $TK5/tk5res $TK5/tk5cat $TK5/tk5dlb $TK5/tk5001 $TK5/tk5002 \
    $TK5/tso001 $TK5/tso002 $TK5/tso003 $TK5/work01 $TK5/work02 $TK5/work03 $TK5/work04 \
    $TK5/int001 $TK5/page00 $TK5/spool0

# Make required Ports available
EXPOSE 3270/tcp
EXPOSE 8038/tcp

# Set working directory and define the default entrypoint
WORKDIR $TK5
ENTRYPOINT [ "./mvs" ] 