#!/bin/bash

# Automatic File Sorter Script
# This script sorts files in the current directory into subdirectories based on their file types.
# Usage: ./automatic_file_sorter.sh <directory:optional>

# Check if a directory is provided as an argument and change to that directory otherwise use the current directory
if [ $# -eq 1 ]; then
    cd "$1" || { echo "Directory not found"; exit 1; }
else
    cd "$(pwd)" || { echo "Current directory not found"; exit 1; }
fi

# Function to create a directory if it doesn't exist
create_directory() {
    dir_name=$1
    # Check if the directory already exists
    if [ ! -d "$dir_name" ]; then
        mkdir "$dir_name"
    fi
}
# Function to move files to the appropriate directory
move_files() {
    file_type=$1
    dir_name=$2
    # For each file type, check if files exist and move them
    for file in *.$file_type; do
        if [ -e "$file" ]; then
            mv "$file" "$dir_name/"
            echo "Moved $file to $dir_name/"
        fi
    done
}
# Define directories and their associated file extensions
declare -A file_types
file_types=(
    ["Images"]="jpg jpeg png gif bmp"
    ["Documents"]="txt pdf doc docx xls xlsx ppt pptx"
    ["Videos"]="mp4 mkv avi mov"
    ["Audio"]="mp3 wav flac"
    ["Archives"]="zip tar gz rar 7z"
)

# Create directories
for dir in "${!file_types[@]}"; do
    create_directory "$dir"
done

# Move files to the appropriate directories
for dir in "${!file_types[@]}"; do
    for ext in ${file_types[$dir]}; do
        move_files "$ext" "$dir"
    done
done

# Create Others directory
create_directory "Others"
# Move any other files to the "Others" directory
for file in *; do
    if [ -f "$file" ]; then
        mv "$file" "Others/"
        echo "Moved $file to Others/"
    fi
done

# Print completion message
echo "File sorting completed!"
