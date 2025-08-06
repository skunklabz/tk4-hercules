# *********************************************************************
# Run TK5 (MVS 3.8j) in Docker container - AMD64 compatible version
# *********************************************************************
#
# Use Ubuntu 22.04 as a base and install Hercules
#
FROM ubuntu:22.04

# Install Hercules and its dependencies
RUN apt-get update && apt-get install -y hercules && rm -rf /var/lib/apt/lists/*

#
# Set some environment variables
#
ENV HERCULES_RC         /opt/hercules/hercules.rc
ENV HERCULES_CNF        /opt/hercules/hercules.cnf
ENV HERCULES_LOG        /opt/hercules/hercules.log
ENV TK5                 /opt/tk5

#
# Get the TK5 system
#
COPY ./external/mvs-tk5/mvs-tk5 $TK5

#
# Make Hercules web Interface available inside TK5 as reference by
# hercules.cnf
#
RUN ln -s /usr/share/hercules /opt/hercules

#
# Expose ports for 3270 and the web interface
#
EXPOSE 3270 8038

#
# Set working directory
#
WORKDIR $TK5

#
# Start Hercules (removed invalid -r option)
#
CMD /usr/bin/hercules -f $HERCULES_CNF 2>&1 | tee $HERCULES_LOG