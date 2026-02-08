#!/usr/bin/env bash

# This is a nix develop/nix-shell wrapper so it is easier to call any develop nix file located in the develop directory
# e.g. `nid c` will run `nix-shell ./develop/c/shell.nix` or `nix develop path:./develop/c` depending on what's available
# Supports both shell.nix (preferred) and flake.nix files

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Function to detect the type of nix file in a directory
detect_nix_type() {
    local dir="$1"
    if [[ -f "$dir/default.nix" ]]; then
        echo "default"
    elif [[ -f "$dir/flake.nix" ]]; then
        echo "flake"
    else
        echo "none"
    fi
}

if [[ "$1" == "" ]]; then
    echo "Usage: nid [COMMANDS]"
    echo ""
    echo "Example: nid golang -- code . # run vscode in the golang develop environment"
    echo ""
    echo "Commands:"
    echo "  create <NAME>               Create a develop file with the specified name (creates default.nix)"
    echo "  setup <NAME>                Setup a direnv in the current directory"
    echo "  reset                    Remove direnv files (.nid, .envrc, .direnv) from current directory"
    echo "  <NAME> [-- <COMMAND_ARGS>]  Launch shell or run a command in the specified develop environment"
    echo ""
    echo "Note: Supports default.nix and flake.nix files"
    exit 1
fi

if [[ "$1" == "create" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Usage: nid create <NAME>"
        exit 1
    fi

    create_file=$2
    # check if the develop file already exists
    if [[ -d "$script_dir/develop/$create_file" ]]; then
        echo "Error: $script_dir/develop/$create_file already exists"
        exit 1
    fi

    # duplicate the empty develop template
    cp -r "$script_dir/develop/empty" "$script_dir/develop/$create_file"
    echo "Created $script_dir/develop/$create_file/default.nix"
    exit 0
fi

if [[ "$1" == "setup" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Usage: nid setup <NAME>"
        exit 1
    fi

    # check if there is already direnv files
    if [[ -d ".nid" || -f ".envrc" ]]; then
        echo "Error: direnv files already exist, please remove the following if you want to recreate one:"
        if [[ -d ".nid" ]]; then
            echo "  .nid"
        fi
        if [[ -f ".envrc" ]]; then
            echo "  .envrc"
        fi
        exit 1
    fi

    # check what type of nix file the source has
    source_type=$(detect_nix_type "$script_dir/develop/$2")
    if [[ "$source_type" == "none" ]]; then
        echo "Error: $script_dir/develop/$2 does not contain default.nix or flake.nix"
        exit 1
    fi

    mkdir -p .nid
    cp -rT "$script_dir/develop/$2" .nid
    if [[ "$?" != "0" ]]; then
        echo "Error: failed to copy $script_dir/develop/$2 to .nid"
        exit 1
    fi

    # Replace $NID_NAME with direnv in all files in .nid
    find .nid -type f -exec sed -i 's/\$NID_NAME/direnv/g' {} \;

    # create appropriate .envrc based on file type
    if [[ "$source_type" == "default" ]]; then
        printf "watch_file .nid/*\nuse nix ./.nid\n" > .envrc
    else
        printf "watch_file .nid/*\nuse flake path:./.nid\n" > .envrc
    fi

    if [[ "$?" != "0" ]]; then
        echo "Error: failed to create .envrc"
        exit 1
    fi
    exit 0
fi

if [[ "$1" == "reset" ]]; then
    # Helper function to convert bytes to human readable
    bytes_to_human() {
        local bytes=$1
        if [[ $bytes -gt 1073741824 ]]; then
            echo "$((bytes / 1073741824))G"
        elif [[ $bytes -gt 1048576 ]]; then
            echo "$((bytes / 1048576))M"
        elif [[ $bytes -gt 1024 ]]; then
            echo "$((bytes / 1024))K"
        else
            echo "${bytes}B"
        fi
    }

    # Check for direnv-related files and directories
    found_files=()
    total_size=0

    if [[ -d ".nid" ]]; then
        size_bytes=$(du -sb .nid 2>/dev/null | cut -f1)
        size_human=$(bytes_to_human $size_bytes)
        found_files+=(".nid (directory, $size_human)")
        total_size=$((total_size + size_bytes))
    fi

    if [[ -f ".envrc" ]]; then
        size_bytes=$(du -sb .envrc 2>/dev/null | cut -f1)
        size_human=$(bytes_to_human $size_bytes)
        found_files+=(".envrc (file, $size_human)")
        total_size=$((total_size + size_bytes))
    fi

    if [[ -d ".direnv" ]]; then
        size_bytes=$(du -sb .direnv 2>/dev/null | cut -f1)
        size_human=$(bytes_to_human $size_bytes)
        found_files+=(".direnv (directory, $size_human)")
        total_size=$((total_size + size_bytes))
    fi

    if [[ ${#found_files[@]} -eq 0 ]]; then
        echo "No direnv files found in current directory."
        exit 0
    fi

    echo "Found the following direnv files:"
    for file in "${found_files[@]}"; do
        echo "  $file"
    done

    # Convert total size to human readable
    total_human=$(bytes_to_human $total_size)

    echo "Total size: $total_human"
    echo ""
    read -p "Do you want to delete these files? [y/N]: " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi

    # Run direnv disallow to clean up direnv state before deletion
    if [[ -f ".envrc" ]] && command -v direnv >/dev/null 2>&1; then
        echo "Running direnv disallow..."
        direnv disallow 2>/dev/null || true
    fi

    # Delete the files
    deleted_count=0
    if [[ -d ".nid" ]]; then
        rm -rf .nid && echo "Deleted .nid" && ((deleted_count++))
    fi
    if [[ -f ".envrc" ]]; then
        rm -f .envrc && echo "Deleted .envrc" && ((deleted_count++))
    fi
    if [[ -d ".direnv" ]]; then
        rm -rf .direnv && echo "Deleted .direnv" && ((deleted_count++))
    fi

    echo "Successfully deleted $deleted_count item(s)."
    exit 0
fi

dev_path="$script_dir/develop/$1"
nid_name=$NID_NAME

# check if the develop environment exists and what type it is
if [[ ! -d "$dev_path" ]]; then
    echo "Error: $dev_path does not exist"
    exit 1
fi

dev_type=$(detect_nix_type "$dev_path")
if [[ "$dev_type" == "none" ]]; then
    echo "Error: $dev_path does not contain default.nix or flake.nix"
    exit 1
fi

# concat |file#name to NID_NAME
if [[ "$nid_name" != "" ]]; then
    nid_name="$nid_name|$1"
else
    nid_name="$1"
fi

nid_shell=$NID_SHELL
if [[ "$nid_shell" == "" ]]; then
    nid_shell=$SHELL
fi

# Function to execute command based on dev type
execute_nix_command() {
    local command_args=("$@")

    if [[ "$dev_type" == "default" ]]; then
        # Use nix-shell for default.nix files
        if [[ ${#command_args[@]} -eq 0 ]]; then
            # No command, start interactive shell
            NID_SHELL=$nid_shell NID_NAME=$nid_name nix-shell "$dev_path/default.nix" --run "$nid_shell"
        else
            # Run command
            NID_SHELL=$nid_shell NID_NAME=$nid_name nix-shell "$dev_path/default.nix" --run "${command_args[*]}"
        fi
    else
        # Use nix develop for flake.nix files
        if [[ ${#command_args[@]} -eq 0 ]]; then
            # No command, start interactive shell
            NID_SHELL=$nid_shell NID_NAME=$nid_name nix develop path:$dev_path -c "$nid_shell"
        else
            # Run command
            NID_SHELL=$nid_shell NID_NAME=$nid_name nix develop path:$dev_path -c "${command_args[@]}"
        fi
    fi
}

# if $2 is --, then pass them as arguments
if [[ "$2" == "--" ]]; then
    execute_nix_command "${@:3}"
    exit $?
fi

# if there is more than one name, call this script inside the environment again
if [[ "$2" != "" ]]; then
    execute_nix_command "$script_dir/nid.sh" "${@:2}"
    exit $?
fi

# no additional arguments, start interactive shell
execute_nix_command
exit $?
