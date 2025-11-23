#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist"
    exit 1
fi

find "$DIR" -type f -name "*.jar" | while read -r jar_file; do
    jar_dir="${jar_file%.jar}_jar"
    # Print progress _if_ VERBOSE is set
    [ -n "$VERBOSE" ] && echo "Extracting $jar_file to $jar_dir"
    mkdir -p "$jar_dir"
    unzip -q "$jar_file" -d "$jar_dir"
    rm "$jar_file"
done
