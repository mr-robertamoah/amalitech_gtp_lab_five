#!/bin/bash
# Disk Space Analyzer Script
# Write a tool to show which folders and files use the most space. Create a tree-like
# structure to display disk usage and offer options to sort and filter results.
# Skills: Recursion, data sorting, output formatting, data visualization
# Usage: ./disk_space_analyzer.sh <directory> [options]
# Example: ./disk_space_analyzer.sh /path/to/directory --sort-by-size --filter-by-type txt
# Function to display usage information
usage() {
    echo "Usage: $0 <directory>"
    exit 1
}
# Function to analyze disk space usage with tree format if available
analyze_disk_space() {
    dir=$1
    # Check if the directory exists
    if [ ! -d "$dir" ]; then
        echo "Directory $dir does not exist."
        exit 1
    fi
    # Check if tree command is available
    if command -v tree >/dev/null 2>&1; then
        # Use tree with human-readable sizes and file sizes
        tree -h "$dir"
    else
        # Fallback to du with indentation
        du -ah "$dir"
    fi
}
# Function to sort disk usage by size, reads from stdin
sort_by_size() {
    # Sort by the first field (size) in human-readable format, reverse order
    sort -k1,1hr
}
# Function to filter disk usage by file type, reads from stdin
filter_by_type() {
    file_type=$1
    # Filter lines matching the file type extension without altering the line
    grep -E "\.${file_type}$"
}
# Check if the correct number of arguments is provided
if [ "$#" -lt 1 ]; then
    usage
fi
# Check if the first argument is a directory
if [ ! -d "$1" ]; then
    echo "Error: $1 is not a directory."
    usage
fi
# Get the directory to analyze
directory=$1
shift

# Initialize pipeline command with analyze_disk_space output
pipeline_cmd="analyze_disk_space \"$directory\""

# Variables to track options
sort_flag=0
filter_flag=0
filter_type=""

# Parse options and set flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --sort-by-size)
            sort_flag=1
            ;;
        --filter-by-type)
            filter_flag=1
            filter_type=$2
            shift
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
    shift
done

# Build and execute the pipeline using flags
if [[ $filter_flag -eq 1 && $sort_flag -eq 1 ]]; then
    analyze_disk_space "$directory" | filter_by_type "$filter_type" | sort_by_size
elif [[ $filter_flag -eq 1 ]]; then
    analyze_disk_space "$directory" | filter_by_type "$filter_type"
elif [[ $sort_flag -eq 1 ]]; then
    analyze_disk_space "$directory" | sort_by_size
else
    analyze_disk_space "$directory"
fi
