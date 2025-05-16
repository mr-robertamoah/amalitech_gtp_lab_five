#!/bin/bash
# File Backup System Script

# Usage: ./file_backup_system.sh <source_directory> <backup_directory> [options]
# Example: ./file_backup_system.sh /path/to/source /path/to/backup --full --compress

# Function to display usage information
usage() {
    echo "Usage: $0 <source_directory> <backup_directory> [options]"
    echo "Options:"
    echo "  --full        Perform a full backup"
    echo "  --partial     Perform a partial backup"
    echo "  --compress    Compress the backup"
    echo "  --schedule    Schedule the backup (requires cron)"
    exit 1
}
# Function to perform a full backup
full_backup() {
    src=$1
    dest=$2
    # Check if the source directory exists
    if [ ! -d "$src" ]; then
        echo "Source directory $src does not exist."
        exit 1
    fi
    # Create the backup directory if it doesn't exist
    mkdir -p "$dest"
    # Copy files from source to destination
    cp -r "$src"/* "$dest"
    echo "Full backup completed from $src to $dest."
}
# Function to perform a partial backup
partial_backup() {
    src=$1
    dest=$2
    # Check if the source directory exists
    if [ ! -d "$src" ]; then
        echo "Source directory $src does not exist."
        exit 1
    fi
    # Create the backup directory if it doesn't exist
    mkdir -p "$dest"
    # Copy only modified files from source to destination
    rsync -av --update "$src"/ "$dest"
    echo "Partial backup completed from $src to $dest."
}
# Function to compress the backup
compress_backup() {
    dest=$1
    # Check if the backup directory exists
    if [ ! -d "$dest" ]; then
        echo "Backup directory $dest does not exist."
        exit 1
    fi
    # Compress the backup directory
    tar -czf "${dest}.tar.gz" -C "$dest" .
    echo "Backup compressed to ${dest}.tar.gz."
}
# Function to schedule the backup using cron
schedule_backup() {
    src=$1
    dest=$2
    shift 2
    options=("$@")
    # Check if the source directory exists
    if [ ! -d "$src" ]; then
        echo "Source directory $src does not exist."
        exit 1
    fi

    # Prompt user for cron schedule entries
    echo "Enter the minute (0-59) for the cron schedule:"
    read minute
    echo "Enter the hour (0-23) for the cron schedule:"
    read hour
    echo "Enter the day of month (1-31) for the cron schedule:"
    read day_of_month
    echo "Enter the month (1-12) for the cron schedule:"
    read month
    echo "Enter the day of week (0-7, 0 or 7 is Sunday) for the cron schedule:"
    read day_of_week

    # Validate inputs and set defaults if empty
    minute=${minute:-0}
    hour=${hour:-2}
    day_of_month=${day_of_month:-*}
    month=${month:-*}
    day_of_week=${day_of_week:-*}

    # Build options string for cron job
    opts=""
    for opt in "${options[@]}"; do
        opts+=" $opt"
    done

    # Create a cron job with user-defined schedule
    (crontab -l 2>/dev/null; echo "$minute $hour $day_of_month $month $day_of_week $0 $src $dest$opts") | crontab -
    echo "Backup scheduled with cron schedule: $minute $hour $day_of_month $month $day_of_week and options:$opts"
}
# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    usage
fi
# Parse command-line arguments
src_dir=$1
backup_dir=$2
shift 2
# Collect options for scheduling if --schedule is present
schedule_opts=()
schedule_flag=0
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --full) full_backup "$src_dir" "$backup_dir"; shift ;;
        --partial) partial_backup "$src_dir" "$backup_dir"; shift ;;
        --compress) compress_backup "$backup_dir"; shift ;;
        --schedule)
            schedule_flag=1
            shift
            # Collect remaining options for scheduling
            while [[ "$#" -gt 0 ]]; do
                schedule_opts+=("$1")
                shift
            done
            ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# If schedule flag is set, call schedule_backup with collected options
if [[ $schedule_flag -eq 1 ]]; then
    schedule_backup "$src_dir" "$backup_dir" "${schedule_opts[@]}"
fi
