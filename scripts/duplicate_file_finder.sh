#!/bin/bash
# Duplicate File Finder Script
# Make a script to find and list duplicate files in a folder. Use file size and content
# comparison to spot duplicates and offer choices to delete or move them.
# Skills: File comparison, hashing, arrays, user interaction
# Usage: ./duplicate_file_finder.sh <directory>
# Example: ./duplicate_file_finder.sh /path/to/directory
# Function to find duplicate files in a directory
find_duplicates() {
    dir=$1
    # Check if the directory exists
    if [ ! -d "$dir" ]; then
        echo "Directory $dir does not exist."
        exit 1
    fi
    # Change to the specified directory
    cd "$dir" || exit
    # Create an associative array to store file hashes with arrays of files
    declare -A file_hashes
    # Loop through files in the directory
    for file in *; do
        # Check if it's a regular file
        if [ -f "$file" ]; then
            # Calculate the hash of the file
            hash=$(md5sum "$file" | awk '{ print $1 }')
            # Check if the hash already exists in the array
            if [[ -n "${file_hashes[$hash]}" ]]; then
                # If it exists, append the file to the array (using a delimiter)
                file_hashes[$hash]+=$'\n'"$file"
            else
                # If it doesn't exist, create a new entry in the array
                file_hashes[$hash]="$file"
            fi
        fi
    done
    # Print duplicate files found
    echo "Duplicate files found:"
    for hash in "${!file_hashes[@]}"; do
        IFS=$'\n' read -r -d '' -a files_array < <(printf '%s\0' "${file_hashes[$hash]}")
        if [[ ${#files_array[@]} -gt 1 ]]; then
            echo "Files: ${files_array[*]}"
            # Ask user for action on duplicates
            echo "Do you want to delete the duplicate files (excluding the first one)? (y/n)"
            read -r answer
            if [[ "$answer" == "y" ]]; then
                # Skip the first file and delete duplicates
                for ((i=1; i<${#files_array[@]}; i++)); do
                    rm -- "${files_array[i]}"
                    echo "Deleted ${files_array[i]}"
                done
            fi

            # Ask user if they want to move duplicates to a different directory if they don't want to delete them
            if [[ "$answer" != "y" ]]; then
                echo "Do you want to move the duplicate files (excluding the first one) to a different directory? (y/n)"
                read -r move_answer
                if [[ "$move_answer" == "y" ]]; then
                    echo "Enter the destination directory:"
                    read -r dest_dir
                    # Check if the destination directory exists
                    if [ ! -d "$dest_dir" ]; then
                        mkdir -p "$dest_dir"
                    fi
                    # Skip the first file and move duplicates
                    for ((i=1; i<${#files_array[@]}; i++)); do
                        mv -- "${files_array[i]}" "$dest_dir/"
                        echo "Moved ${files_array[i]} to $dest_dir/"
                    done
                fi
            fi
        fi
    done
}
# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi
# Call the find_duplicates function with the provided argument
find_duplicates "$1"