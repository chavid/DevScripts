#!/bin/bash
set -e

# 1. Source the bashrc or environment file
if [ -f "/mydevtools/bashrc" ]; then
    source /mydevtools/bashrc
fi

echo $PS1

# 2. Execute the CMD passed from Docker
# "$@" represents all arguments passed to the entrypoint
exec "$@"