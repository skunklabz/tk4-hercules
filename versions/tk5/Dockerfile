# Use AMD64-compatible Hercules base image
FROM mainframed767/hercules:latest

# Set environment
ARG HERCULES=/home/hercules/herctest/herc4x
ARG TK5=/home/hercules/tk5

# Switch to hercules user for file operations
USER hercules

# Copy TK5 from patrickraths submodule to user's home directory
COPY --chown=hercules:hercules external/mvs-tk5/mvs-tk5 $TK5

# Create hercules directory
RUN mkdir -p $TK5/hercules

# Make Hercules web Interface available inside TK5- as reference by
# the default configuration scripts
RUN ln -s $HERCULES $TK5/hercules/bin

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