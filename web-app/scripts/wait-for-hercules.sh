#!/bin/bash

# Wait for Hercules emulator to be ready
# This script waits for the 3270 port to be available

set -e

HOST=${1:-"hercules-tk4"}
PORT=${2:-"3270"}
TIMEOUT=${3:-"300"}

echo "Waiting for Hercules emulator at $HOST:$PORT..."

# Function to check if port is open
check_port() {
    timeout 1 bash -c "</dev/tcp/$HOST/$PORT" 2>/dev/null
}

# Wait for the port to be available
elapsed=0
while ! check_port; do
    if [ $elapsed -ge $TIMEOUT ]; then
        echo "Timeout waiting for Hercules emulator after ${TIMEOUT}s"
        exit 1
    fi
    
    echo "Waiting for Hercules emulator... (${elapsed}s/${TIMEOUT}s)"
    sleep 5
    elapsed=$((elapsed + 5))
done

echo "Hercules emulator is ready at $HOST:$PORT" 