#!/bin/bash
# TK4- MVS Startup Script

set -e

echo "Starting TK4- MVS..."
echo "Architecture: $(uname -m)"

# Verify Hercules binary exists
if [ ! -f "./hercules/linux/64/bin/hercules" ]; then
    echo "ERROR: Hercules binary not found"
    exit 1
fi

chmod +x ./hercules/linux/64/bin/hercules

# Verify original mvs script exists
if [ ! -f "./mvs.original" ]; then
    echo "ERROR: mvs.original script not found"
    exit 1
fi

chmod +x ./mvs.original

exec ./mvs.original
