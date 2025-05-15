#!/bin/bash
# File Synchronization Utility Script
# Develop a program to keep files in sync between two folders. Implement two-way
# synchronization and handle conflict resolution.
# Skills: File comparison, error handling, logging, conflict management
# Usage: ./file_sync_utility.sh <source_directory> <destination_directory> [options]
# Example: ./file_sync_utility.sh /path/to/source /path/to/destination --sync
# Function to display usage information
usage() {
    echo "Usage: $0 <source_directory> <destination_directory> [options]"
    echo "Options:"
    echo "  --sync        Perform synchronization"
    echo "  --delete      Delete files not present in source"
    echo "  --help        Display this help message"
    exit 1
}
# Function to synchronize files between two directories
synchronize_files() {
    src=$1
    dest=$2
    # Check if the source directory exists
    if [ ! -d "$src" ]; then
        echo "Source directory $src does not exist."
        exit 1
    fi
    # Check if the destination directory exists
    if [ ! -d "$dest" ]; then
        echo "Destination directory $dest does not exist."
        exit 1
    fi
    # Synchronize files from source to destination using rsync
    rsync -av --delete "$src"/ "$dest"
    echo "Synchronization completed from $src to $dest."
}
# Function to delete files not present in source
delete_files() {
    src=$1
    dest=$2
    # Check if the source directory exists
    if [ ! -d "$src" ]; then
        echo "Source directory $src does not exist."
        exit 1
    fi
    # Check if the destination directory exists
    if [ ! -d "$dest" ]; then
        echo "Destination directory $dest does not exist."
        exit 1
    fi
    # Delete files in destination not present in source using rsync
    rsync -av --delete "$src"/ "$dest"
    echo "Files not present in source deleted from $dest."
}
# Function to display help message
display_help() {
    echo "File Synchronization Utility"
    echo "This script synchronizes files between two directories."
    echo "Options:"
    echo "  --sync        Perform synchronization"
    echo "  --delete      Delete files not present in source"
    echo "  --help        Display this help message"
}
# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    usage
fi
# Check if the first argument is a directory
if [ ! -d "$1" ]; then
    echo "Error: $1 is not a directory."
    usage
fi
# Get the source and destination directories
source_directory=$1
destination_directory=$2
# Shift the arguments to process options
shift 2
# Get the options
options=("$@")
# Initialize flags
sync_flag=0
delete_flag=0
# Parse options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --sync)
            sync_flag=1
            ;;
        --delete)
            delete_flag=1
            ;;
        --help)
            display_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
    shift
done
# Perform synchronization if --sync or no option is provided
if [ "$sync_flag" -eq 1 ] || [ "$#" -eq 0 ]; then
    synchronize_files "$source_directory" "$destination_directory"
fi
# Perform deletion if --delete is provided
if [ "$delete_flag" -eq 1 ]; then
    delete_files "$source_directory" "$destination_directory"
fi