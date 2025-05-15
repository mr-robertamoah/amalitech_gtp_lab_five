#!/bin/bash
# Automatic File Renamer Script
# Build a tool to rename many files using patterns or rules. Let users specify naming
# conventions, add prefixes or suffixes, and use counters or dates in filenames.
# Skills: Loops, regular expressions, command-line inputs, string formatting
# Usage: ./bulk_file_renamer.sh <directory> <pattern> <new_name>
# Example: ./bulk_file_renamer.sh /path/to/directory "file_*.txt" "new_file_"
# Function to rename files based on a pattern
rename_files() {
    dir=$1
    pattern=$2
    new_name=$3
    # Check if the directory exists
    if [ ! -d "$dir" ]; then
        echo "Directory $dir does not exist."
        exit 1
    fi
    # Change to the specified directory
    cd "$dir" || exit
    # Initialize a counter for renaming
    counter=1
    # Loop through files matching the pattern
    for file in $pattern; do
        # Check if the file exists
        if [ -e "$file" ]; then
            # Extract the file extension
            ext="${file##*.}"
            # Create the new filename with a counter and extension
            new_file="${new_name}${counter}.${ext}"
            # Rename the file
            mv "$file" "$new_file"
            echo "Renamed $file to $new_file"
            ((counter++))
        else
            echo "No files matching pattern $pattern found."
        fi
    done
}
# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <directory> <pattern> <new_name>"
    exit 1
fi
# Call the rename_files function with the provided arguments
rename_files "$1" "$2" "$3"