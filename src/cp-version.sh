#!/bin/bash

# Check for mandatory arguments
if [ $# -ne 2 ]; then
    exit 1
fi

# Extract source file and target folder
source_file="$1"
target_folder="$2"

# Check if source file exists
if [ ! -f "$source_file" ]; then
    exit 1
fi

# Create target folder with .version subfolder if they don't exist
target_version_folder="$target_folder/.version"
if [ ! -d "$target_version_folder" ]; then
    mkdir -p "$target_version_folder" || exit 1
fi

# Get target filename from source filename
target_file=$(basename "$source_file")

# Check if target file exists and create version
if [ -f "$target_folder/$target_file" ]; then
    # Get current timestamp in desired format
    timestamp=$(date +%Y%m%d-%H%M%S)
    cp -a "$target_folder/$target_file" "$target_version_folder/$version_file_name/$source_file.$timestamp.version"
fi

if ! cp -a "$source_file" "$target_folder/$target_file"; then
    exit 1
fi

# Script successful execution (no echo)
exit 0

