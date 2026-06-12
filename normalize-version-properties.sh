#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist"
    exit 1
fi

find "$directory" -type f -name "version.properties" | while read -r file; do
    sed -i.bak \
        -e '/^#/d' \
        -e '/^[[:space:]]*$/d' \
        -e 's/^mirth\.version=.*$/mirth.version=0.0.0 # EXCLUDED FROM COMPARISON/' \
        -e 's/^mirth\.date=.*$/mirth.date=January 1, 2000 # EXCLUDED FROM COMPARISON/' \
        "$file"
    rm "${file}.bak"
    [ -n "$VERBOSE" ] && echo "Processed: $file"
done
