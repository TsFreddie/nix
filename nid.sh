#!/usr/bin/env bash

# This is a nix develop wrapper so it is easier to call any develop nix file located in the develop directory
# e.g. `nd c` will run `nix develop path:./develop/c`

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ "$1" == "" ]]; then
    echo "Usage: nid [COMMANDS]"
    echo ""
    echo "Example: nid golang -- code . # run vscode in the golang develop environment"
    echo ""
    echo "Commands:"
    echo "  create <NAME>               Create a develop file with the specified name"
    echo "  setup <NAME>                Setup a direnv in the current directory"
    echo "  <NAME> [-- <COMMAND_ARGS>]  Launch shell or run a command in the specified develop environment"
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
    echo "Created $script_dir/develop/$create_file/flake.nix"
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

    mkdir -p .nid
    cp -rT "$script_dir/develop/$2" .nid
    printf "watch_file .nid\nuse flake path:./.nid\n" > .envrc

fi

dev_path="$script_dir/develop/$1"
nid_name=$NID_NAME

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

# if $2 is --, then pass them as arguments -c
if [[ "$2" == "--" ]]; then
    NID_SHELL=$nid_shell NID_NAME=$nid_name nix develop path:$dev_path -c "${@:3}"
    exit $?
fi

# if there is more than one name, call this script inside nix develop again
if [[ "$2" != "" ]]; then
    # concat rest of the
    NID_SHELL=$nid_shell NID_NAME=$nid_name nix develop path:$dev_path -c "$script_dir/nid.sh" "${@:2}"
    exit $?
fi

NID_SHELL=$nid_shell NID_NAME=$nid_name nix develop path:$dev_path -c "$nid_shell"
exit $?
