#!/bin/bash
# File Encryption Tool Script
# Create a script to encrypt and decrypt files using a password. Implement a safe
# encryption method and handle key management securely.
# Skills: Cryptography basics, input/output redirection, secure coding
# Usage: ./file_encryption_tool.sh <encrypt|decrypt> <file>
# Example: ./file_encryption_tool.sh encrypt myfile.txt
# Function to encrypt a file
encrypt_file() {
    file=$1
    password=$2
    # Check if the file exists
    if [ ! -f "$file" ]; then
        echo "File $file does not exist."
        exit 1
    fi
    # Encrypt the file using openssl with AES-256-CBC
    if openssl enc -aes-256-cbc -salt -in "$file" -out "${file}.enc" -pass pass:"$password"; then
        echo "File $file encrypted to ${file}.enc."
        # Delete the original file after successful encryption
        rm -f "$file"
        echo "Original file $file deleted."
    else
        echo "Encryption failed."
        exit 1
    fi
}
# Function to decrypt a file
decrypt_file() {
    file=$1
    password=$2
    # Check if the encrypted file exists
    if [ ! -f "$file" ]; then
        echo "File $file does not exist."
        exit 1
    fi
    # Decrypt the file using openssl with AES-256-CBC
    if openssl enc -d -aes-256-cbc -in "$file" -out "${file%.enc}" -pass pass:"$password"; then
        echo "File $file decrypted from ${file%.enc}."
        # Delete the encrypted file after successful decryption
        rm -f "$file"
        echo "Encrypted file $file deleted."
    else
        echo "Decryption failed."
        exit 1
    fi
}
# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <encrypt|decrypt> <file>"
    exit 1
fi
# Get the action (encrypt/decrypt) and file from arguments
action=$1
file=$2
# Prompt for password securely
echo -n "Enter password: "
read -s password
echo
# For encryption, confirm password
if [ "$action" == "encrypt" ]; then
    echo -n "Confirm password: "
    read -s password_confirm
    echo
    if [ "$password" != "$password_confirm" ]; then
        echo "Passwords do not match. Exiting."
        exit 1
    fi
fi
# Perform the action based on the first argument
case $action in
    encrypt)
        encrypt_file "$file" "$password"
        ;;
    decrypt)
        decrypt_file "$file" "$password"
        ;;
    *)
        echo "Invalid action. Use 'encrypt' or 'decrypt'."
        exit 1
        ;;
esac
