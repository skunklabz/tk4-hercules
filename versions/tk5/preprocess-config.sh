#!/bin/bash

# Pre-process TK5 configuration file by substituting environment variables
# This script will create a processed version of the configuration file

set -e

# Set default values for environment variables
export EXPLICIT_LOG=${EXPLICIT_LOG:-"#"}
export MAINSIZE=${MAINSIZE:-"16"}
export CNSLPORT=${CNSLPORT:-"3270"}
export HTTPPORT=${HTTPPORT:-"8038"}
export NUMCPU=${NUMCPU:-"2"}
export MAXCPU=${MAXCPU:-"2"}
export TK5CRLF=${TK5CRLF:-"CRLF"}
export RDRPORT=${RDRPORT:-"3505"}
export TK5CONS=${TK5CONS:-"intcons"}
export CNF101A=${CNF101A:-"conf"}
export REP101A=${REP101A:-"default"}
export CMD101A=${CMD101A:-""}
export LOCALCNF=${LOCALCNF:-"INCLUDE conf/local.cnf"}

# Process the configuration file
envsubst < /opt/tk5/conf/tk5.cnf > /opt/tk5/conf/tk5_processed.cnf

# Use the processed configuration file
exec hercules -f /opt/tk5/conf/tk5_processed.cnf 