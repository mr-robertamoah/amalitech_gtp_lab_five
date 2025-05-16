#!/bin/bash
# File Synchronization Utility Script with Interactive Conflict Resolution

# Usage: ./file_sync_utility_refactored.sh <source_directory> <destination_directory> [options]
# Example: ./file_sync_utility_refactored.sh /path/to/source /path/to/destination --sync

# Function to display usage information
usage() {
    echo "Usage: $0 <source_directory> <destination_directory> [options]"
    echo "Options:"
    echo "  --sync        Perform synchronization"
    echo "  --delete      Delete files not present in source"
    echo "  --help        Display this help message"
    exit 1
}

# Function to prompt user for yes/no response
prompt_yes_no() {
    while true; do
        read -rp "$1 [y/n]: " -t 10 yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo "Please answer yes (y) or no (n)." ;;
        esac
    done
}

# Function to synchronize files between two directories with interactive conflict resolution
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

    # Find files in source
    mapfile -t src_files < <(find "$src" -type f)

    for src_file in "${src_files[@]}"; do
        # Get relative path
        rel_path="${src_file#$src/}"
        dest_file="$dest/$(basename $rel_path)"

        if [ -f "$dest_file" ]; then
            # File exists in destination, check if different
            if ! cmp -s "$src_file" "$dest_file"; then
                # Files differ, prompt user
                if prompt_yes_no "File '$rel_path' differs. Overwrite destination file?"; then
                    # Create destination directory if needed
                    mkdir -p "$(dirname "$dest_file")"
                    cp -p "$src_file" "$dest_file"
                    echo "Overwritten: $rel_path"
                else
                    echo "Skipped: $rel_path"
                fi
            else
                # Files are the same, no action needed
                :
            fi
        else
            # File does not exist in destination, copy it
            mkdir -p "$(dirname "$dest_file")"
            cp -p "$src_file" "$dest_file"
            echo "Copied new file: $rel_path"
        fi
    done

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

    # Find files in destination
    mapfile -t dest_files < <(find "$dest" -type f)

    for dest_file in "${dest_files[@]}"; do
        # Get relative path
        rel_path="${dest_file#$dest/}"
        src_file="$src/$(basename $rel_path)"

        if [ ! -f "$src_file" ]; then
            if prompt_yes_no "File '$rel_path' is not present in source. Delete from destination?"; then
                rm -f "$dest_file"
                echo "Deleted: $rel_path"
            else
                echo "Skipped deletion: $rel_path"
            fi
        fi
    done

    echo "Deletion process completed in $dest."
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

if [ "$sync_flag" -eq 1 ] && [ "$delete_flag" -eq 1 ]; then
    if prompt_yes_no "Both --sync and --delete options provided. Do you want to synchronize first?"; then
        synchronize_files "$source_directory" "$destination_directory"
        delete_files "$source_directory" "$destination_directory"
    else
        delete_files "$source_directory" "$destination_directory"
    fi
# If no options are provided, prompt user for action
elif [ "$sync_flag" -eq 0 ] && [ "$delete_flag" -eq 0 ]; then
    if prompt_yes_no "No options provided. Do you want to synchronize?"; then
        synchronize_files "$source_directory" "$destination_directory"
    else
        delete_files "$source_directory" "$destination_directory"
    fi
# If only --sync is provided, perform synchronization
elif [ "$sync_flag" -eq 1 ] && [ "$delete_flag" -eq 0 ]; then
    synchronize_files "$source_directory" "$destination_directory"
# If both options are provided, prompt user for action
elif [ "$delete_flag" -eq 1 ]; then
    delete_files "$source_directory" "$destination_directory"
fi
