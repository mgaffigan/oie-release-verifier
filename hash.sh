#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
    echo "Error: $DIR is not a directory" >&2
    exit 1
fi

cd "$DIR" || exit 1

find . -type f -print0 | sort -z | xargs -0 shasum
