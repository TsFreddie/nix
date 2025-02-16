#!/usr/bin/env bash

# This is a helper to setup direnv for niv-direnv. It simply copies a template to the current directory
# Templates are located in the ./develop directory

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ "$1" == "" ]]; then
    echo "Usage: niv <NAME>"
    exit 1
fi

# check if there is already direnv files
if [[ -d ".niv" || -f ".envrc" ]]; then
    echo "Error: direnv files already exist, please remove them if you want to recreate them"
    exit 1
fi

mkdir -p .niv
cp -rT "$script_dir/develop/$1" .niv
printf "watch_file .niv\nuse flake path:./.niv\n" > .envrc
