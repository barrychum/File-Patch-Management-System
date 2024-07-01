#!/bin/bash

# Check for mandatory arguments
if [ $# -ne 2 ]; then
    echo "provide source_file and target_folder" >&2
    exit 1
fi

# Check if source file exists
if [ ! -f "$1" ]; then
    echo "source file does not exist" >&2
    exit 1
fi

source_fullname=$(realpath "$1")
source_filename=$(basename "$source_fullname")
target_fullfolder=$(realpath "$2")

# Create target folder with .version subfolder if they don't exist
target_version_folder="$target_fullfolder/.version"
if [ ! -d "$target_version_folder" ]; then
    mkdir -p "$target_version_folder" || exit 1
fi

# Check if target file exists and create version
if [ -f "$target_fullfolder/$source_filename" ]; then
    # Get current timestamp in desired format
    timestamp=$(date +%Y%m%d-%H%M%S)
    cp -a "$target_fullfolder/$source_filename" "$target_version_folder/$source_filename.$timestamp.version"
    if [ $? -ne 0 ]; then
        printf "error backing up file.  Abort\n" >&2
        exit 1
    fi
fi

if ! cp -a "$source_fullname" "$target_fullfolder/$source_filename"; then
    printf "error copy file. Abort\n" >&2
    exit $?
fi
# Script successful execution (no echo)
exit 0
