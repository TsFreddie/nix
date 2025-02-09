#!/usr/bin/env bash

# Ensure a path is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <path>"
  exit 1
fi

# Resolve the full, absolute path and handle '~' shorthand
FULL_PATH=$(realpath -m "$1")

# Check if the path is within the home directory
if [[ "$FULL_PATH" != "$HOME"* ]]; then
  echo "Error: The given path is not inside the home directory."
  exit 1
fi

# Check if the target exists
if [ ! -e "$FULL_PATH" ]; then
  echo "Error: The file or directory does not exist."
  exit 1
fi

# Strip the home directory path and attach to the destination root ./files
REL_PATH="${FULL_PATH#$HOME/}"

# Put cwd to script path
cd "$(dirname "$0")"

DEST_DIR="./files"

# Create the destination directory if it's part of a directory structure
mkdir -p "$DEST_DIR/$(dirname "$REL_PATH")"

# Copy the file or directory to the destination
cp -r "$FULL_PATH" "$DEST_DIR/$REL_PATH"

# If not success, exit
if [[ "$?" -ne 0 ]]; then
    exit $?
fi

echo -e "Pinned \033[1;34m$FULL_PATH\033[0m to \033[1;32m$DEST_DIR/$REL_PATH\033[0m"
