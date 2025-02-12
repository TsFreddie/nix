#!/usr/bin/env bash

# This is a nix develop wrapper so it is easier to call any develop nix file located in the develop directory
# e.g. `nd c` will run `nix develop path:./develop/c.nix`

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ "$1" == "" ]]; then
    echo "Usage:"
    echo " $0 <file> to run a develop file"
    echo " $0 --create=<file> to create a new develop file"
    exit 1
fi

if [[ "$1" == "--create="* ]]; then
    create_file=${1#*=}
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

# if there is more than one name, call this script inside nix develop again
if [[ "$2" != "" ]]; then
    # concat rest of the
    NID_SHELL=$nid_shell NID_NAME=$nid_name nix develop path:$dev_path -c "$script_dir/nid.sh" "${@:2}"
    exit $?
fi

NID_SHELL=$nid_shell NID_NAME=$nid_name nix develop path:$dev_path -c "$nid_shell"
exit $?
