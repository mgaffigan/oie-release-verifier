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

# Strip build-environment metadata (tool/JDK used to build) from jar manifests
# and unwrap continuation lines (wrap column varies between jar tools)
find "$directory" -type f -name "MANIFEST.MF" | while read -r file; do
    perl -i.bak -0pe 's/\r?\n //g' "$file"
    sed -i.bak2 \
        -e '/^Ant-Version:/d' \
        -e '/^Created-By:/d' \
        -e '/^Built-By:/d' \
        -e '/^Build-Jdk:/d' \
        "$file"
    rm "${file}.bak" "${file}.bak2"
    [ -n "$VERBOSE" ] && echo "Processed: $file"
done
