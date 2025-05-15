#!/bin/bash

# Automatic File Sorter Script
# This script sorts files in the current directory into subdirectories based on their file types.
# Usage: ./automatic_file_sorter.sh

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
# Create directories for different file types
create_directory "Images"
create_directory "Documents"
create_directory "Videos"
create_directory "Audio"
create_directory "Archives"
create_directory "Others"
# Move files to the appropriate directories
move_files "jpg" "Images"
move_files "jpeg" "Images"
move_files "png" "Images"
move_files "gif" "Images"
move_files "bmp" "Images"
move_files "txt" "Documents"
move_files "pdf" "Documents"
move_files "doc" "Documents"
move_files "docx" "Documents"
move_files "xls" "Documents"
move_files "xlsx" "Documents"
move_files "ppt" "Documents"
move_files "pptx" "Documents"
move_files "mp4" "Videos"
move_files "mkv" "Videos"
move_files "avi" "Videos"
move_files "mov" "Videos"
move_files "mp3" "Audio"
move_files "wav" "Audio"
move_files "flac" "Audio"
move_files "zip" "Archives"
move_files "tar" "Archives"
move_files "gz" "Archives"
move_files "rar" "Archives"
move_files "7z" "Archives"
# Move any other files to the "Others" directory
for file in *; do
    if [ -f "$file" ]; then
        mv "$file" "Others/"
        echo "Moved $file to Others/"
    fi
done

# Print completion message
echo "File sorting completed!"