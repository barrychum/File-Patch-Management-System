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

# Create target folder with .patch subfolder if they don't exist
target_patch_folder="$target_folder/.patch"
if [ ! -d "$target_patch_folder" ]; then
    mkdir -p "$target_patch_folder" || exit 1
fi

# Get target filename from source filename
target_file=$(basename "$source_file")

# Check if target file exists and create patch
if [ -f "$target_folder/$target_file" ]; then
    # Get current timestamp in desired format
    timestamp=$(date +%Y%m%d-%H%M%S)

    # Create patch file name with format
    patch_file_name="$target_file.$timestamp.patch"

    # Generate patch file using diff
    diff -u "$source_file" "$target_folder/$target_file" >"$target_patch_folder/$patch_file_name"

    if [ $? -eq 0 ]; then
        rm -f "$target_patch_folder/$patch_file_name"
        exit 2 # Exit with code 2 to signal no difference
    fi

    # Check if patch file was created successfully
    if [ ! -f "$target_patch_folder/$patch_file_name" ]; then
        exit 1
    fi
fi

# Copy source file to target folder (check for success)
if ! cp "$source_file" "$target_folder/$target_file"; then
    # Remove patch file on copy failure
    rm -f "$target_patch_folder/$patch_file_name"
    exit 1
fi

# Script successful execution (no echo)
exit 0

