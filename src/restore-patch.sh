#!/bin/bash

# Check for mandatory argument
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input_file> [timestamp | all | last]"
    exit 1
fi

# Extract input arguments
input_file="$1"
mode="${2:-all}"  # Default to 'all' if the second argument is not provided

# Check if input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file does not exist."
    exit 1
fi

# Define patch folder and get base filename
patch_folder="$(dirname "$input_file")/.patch"
base_filename=$(basename "$input_file")

# Check if patch folder exists
if [ ! -d "$patch_folder" ]; then
    echo "Patch folder does not exist."
    exit 1
fi

# Collect relevant patch files
patch_files=()
case "$mode" in
    all)
        patch_files=("$patch_folder/$base_filename".*.patch)
        ;;
    last)
        patch_files=($(ls -t "$patch_folder/$base_filename".*.patch 2>/dev/null | head -n 1))
        ;;
    *)
        # Assume mode is a timestamp
        timestamp="${mode:0:4}-${mode:4:2}-${mode:6:2} ${mode:9:2}:${mode:11:2}:${mode:13:2}"
        patch_files=($(find "$patch_folder" -name "$base_filename.*.patch" -newermt "$timestamp" -o -newermt "$timestamp" 2>/dev/null))
        ;;
esac

# Check if any patch files were found
if [ ${#patch_files[@]} -eq 0 ]; then
    echo "No patch files found for the given mode."
    exit 1
fi

# Sort patch files in reverse order
patch_files=($(printf "%s\n" "${patch_files[@]}" | sort -r))

# List selected patch files and ask for confirmation
echo "The following patch files will be applied in reverse order:"
for patch_file in "${patch_files[@]}"; do
    echo "$patch_file"
done

read -p "Do you want to proceed? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "Operation aborted."
    exit 0
fi

# Create a restore file
restore_file="${input_file}.restore"
cp "$input_file" "$restore_file" || exit 1

# Apply patches in reverse order accumulatively
for patch_file in "${patch_files[@]}"; do
    echo 
    echo "Applying $patch_file ..."
    # Apply patch in reverse
    patch -R "$restore_file" < "$patch_file" || {
        echo "Failed to apply patch $patch_file"
        exit 1
    }
done

echo "Restoration complete. Created file: $restore_file"
exit 0
