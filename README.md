# Scripts Directory README

This README provides an overview and usage instructions for the scripts available in the `scripts` directory. Each script serves a specific purpose and includes options to customize its behavior.

---

## Getting Started

To get started with these scripts, follow these steps:

1. **Clone the repository:**

```bash
git clone <repository_url>
cd <repository_directory>
```

2. **Set execute permissions on the scripts:**

```bash
chmod +x scripts/*.sh
```

3. **Run the scripts as needed using the usage instructions provided above.**

---

## 1. Automatic File Sorter (`automatic_file_sorter.sh`)

**Description:**  
Automatically sorts files in the current directory or a specified directory into subdirectories based on their file types. It organizes files into folders such as Images, Documents, Videos, Audio, Archives, and Others.

**Usage:**  
```bash
./automatic_file_sorter.sh [directory]
```
- `directory` (optional): The directory to sort files in. If not provided, the script sorts files in the current directory.

**What to Expect:**  
- The script creates directories for different file types if they do not exist.
- Moves files into their respective directories based on file extensions.
- Prints messages indicating which files were moved and to where.
- If a directory argument is provided, the script sorts files in that directory; otherwise, it sorts files in the current directory.

---

## 2. Bulk File Renamer (`bulk_file_renamer.sh`)

**Description:**  
Renames multiple files in a specified directory based on a pattern. Users can specify naming conventions, including prefixes and counters, to rename files systematically.

**Usage:**  
```bash
./bulk_file_renamer.sh <directory> <pattern> <new_name>
```

**Example:**  
```bash
./bulk_file_renamer.sh /path/to/directory "file_*.txt" "new_file_"
```

**Options and Impact:**  
- `<directory>`: The directory containing files to rename.  
- `<pattern>`: Pattern to match files (e.g., `file_*.txt`).  
- `<new_name>`: New prefix for renamed files; files will be renamed with this prefix followed by a counter and original extension.  
- The script renames matching files sequentially and prints each rename action.

---

## 3. File Backup System (`file_backup_system.sh`)

**Description:**  
Backs up files from a source directory to a backup directory. Supports full and partial backups, compression, and scheduling backups via cron.

**Usage:**  
```bash
./file_backup_system.sh <source_directory> <backup_directory> [options]
```

**Options:**  
- `--full`: Perform a full backup (copies all files).  
- `--partial`: Perform a partial backup (copies only modified files).  
- `--compress`: Compress the backup directory into a `.tar.gz` archive.  
- `--schedule`: Schedule the backup to run daily at 2 AM using cron. Additional options can be specified after `--schedule` to customize the scheduled backup.

**What to Expect:**  
- The script checks for the existence of source and backup directories.  
- Creates backup directories if they do not exist.  
- Performs the specified backup operation and prints status messages.  
- When scheduling, it creates a cron job with the specified options.

---

## 4. Disk Space Analyzer (`disk_space_analyzer.sh`)

**Description:**  
Analyzes disk space usage in a directory and displays a tree-like structure showing which folders and files use the most space. Offers options to sort results by size and filter by file type.

**Usage:**  
```bash
./disk_space_analyzer.sh <directory> [options]
```

**Options:**  
- `--sort-by-size`: Sort the output by file/folder size in descending order.  
- `--filter-by-type <extension>`: Filter the output to show only files of the specified type (e.g., `txt`).

**What to Expect:**  
- The script outputs a tree view of the directory with file sizes if the `tree` command is available; otherwise, it falls back to a `du` listing.  
- Options can be combined and used in any order.  
- Sorting and filtering are applied to the output accordingly.

---

## 5. File Encryption Tool (`file_encryption_tool.sh`)

**Description:**  
Encrypts and decrypts files using a password with AES-256-CBC encryption. Password input is requested securely and hidden during entry. For encryption, password confirmation is required.

**Usage:**  
```bash
./file_encryption_tool.sh <encrypt|decrypt> <file>
```

**What to Expect:**  
- The script prompts for a password securely (input hidden).  
- For encryption, the password must be confirmed to avoid typos.  
- Encrypts the specified file to `<file>.enc` and deletes the original file upon successful encryption.  
- Decrypts the specified encrypted file and deletes the encrypted file upon successful decryption.  
- Prints status messages for each operation.

---

# Summary

These scripts provide utilities for file organization, renaming, backup, disk usage analysis, and encryption. Each script includes usage instructions and options to customize behavior. Users should ensure they have the necessary permissions and dependencies (e.g., `openssl`, `tree`, `cron`) installed for full functionality.

For any questions or issues, please refer to the script comments or contact the maintainer.
