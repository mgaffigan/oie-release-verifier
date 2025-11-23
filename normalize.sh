#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

# Get our script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$1"

${SCRIPT_DIR}/normalize-version-properties.sh "$DIR"
${SCRIPT_DIR}/normalize-javadocs.sh "$DIR"
[ -n "$IGNORE_JAVADOCS" ] && rm -rf "$DIR/docs"
