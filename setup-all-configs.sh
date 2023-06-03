#!/bin/sh


DIR="$( dirname "$0" )"

# Find and execute setup-config.sh files recursively
find "$DIR" -name "setup-config.sh" -type f -exec chmod +x {} \; -exec sh -c 'echo "Executing {}"; {}' \;
