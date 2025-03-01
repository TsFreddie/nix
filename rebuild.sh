#!/usr/bin/env bash

# define color
INFO_COLOR='\033[1;34m'
SUCCESS_COLOR='\033[1;32m'
WARNING_COLOR='\033[1;33m'
NC='\033[0m'

# function to print with INFO color
info_echo() { echo -e "${INFO_COLOR}$1${NC}"; }
success_echo() { echo -e "${SUCCESS_COLOR}$1${NC}"; }
warning_echo() { echo -e "${WARNING_COLOR}$1${NC}"; }

options_dry=false
options_upgrade=false
options_files_only=false
options_hostname=$(hostname)
options_create=""
options_sync_hardware=false

for i in "$@"; do
    case $i in
        --hostname=*)
            options_hostname="${i#*=}"
            ;;
        --dry)
            # does not build or commit
            options_dry=true
            ;;
        --upgrade)
            # upgrade runs nix flake update first
            options_upgrade=true
            ;;
        --files-only)
            # only copy files
            options_files_only=true
            ;;
        --sync)
            # sync hardware configuration
            options_sync_hardware=true
            ;;
        --create=*)
            # create a new machine
            options_create="${i#*=}"
            ;;
        *)
            echo "Unknown option: $i"
            exit 1
            ;;
    esac
done

# put cwd to script path
cd "$(dirname "$0")"

# try creating a new machine
if [[ "$options_create" != "" ]]; then
    # check if the machine already exists
    if [[ -d "./system/machines/$options_create" ]]; then
        warning_echo "Machine $options_create already exists. If you want to recreate it, please remove the directory ./system/machines/$options_create first."
        exit 1
    fi

    info_echo "Creating new machine"
    mkdir -p ./system/machines/$options_create
    echo "# Machine Template

{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # hostname
  networking.hostName = \"$options_create\";
}
" > ./system/machines/$options_create/default.nix
    cat /etc/nixos/hardware-configuration.nix > ./system/machines/$options_create/hardware-configuration.nix
    info_echo "Machine $options_create created. Please edit the configuration at ./system/machines/$options_create/default.nix"
    exit 0
fi

# generate nix variables
info_echo "Generating nix variables"
echo """
{
  pwd = \"$PWD\";
}
""" > ./system/generated.nix

# diff hardware configuration
diff /etc/nixos/hardware-configuration.nix ./system/machines/$options_hostname/hardware-configuration.nix
status="$?"

if [[ "$status" -ne 0 ]]; then
    if [[ "$status" -eq 2 ]]; then
        warning_echo "Hardware configuration does not exist. Run with --create=<hostname> to create a new machine."
        exit 1
    fi
    if [[ "$status" -eq 1 ]]; then
        if [[ "$options_sync_hardware" == true ]]; then
            info_echo "Syncing hardware configuration"
            cat /etc/nixos/hardware-configuration.nix > ./system/machines/$options_hostname/hardware-configuration.nix
        else
            warning_echo "Hardware configuration has changed. Run with --sync to sync the hardware configuration."
            exit 1
        fi
    fi
fi

# remove these files if they exist to remove nix channel
channel_leftovers=(
/root/.nix-defexpr/channels
/nix/var/nix/profiles/per-user/root/channels
)
for channel_leftover in "${channel_leftovers[@]}"; do
    if [[ -d "$channel_leftover" ]]; then
        info_echo "removing ${channel_leftover}"
        sudo rm -rf "$channel_leftover"
    fi

    if [[ -f "$channel_leftover" ]]; then
        info_echo "removing ${channel_leftover}"
        sudo rm -f "$channel_leftover"
    fi
done

# if --upgrade is set, run nix flake update first
if [[ "$options_upgrade" == true ]]; then
    info_echo "Running nix flake update"
    nix flake update --flake path:$PWD/system

    # update develops
    for develop in $(find ./develop/* -type d); do
        info_echo "Updating develop $(basename "$develop")"
        nix flake update --flake path:$PWD/develop/$(basename "$develop")
    done

    # if not success, exit
    if [[ "$?" -ne 0 ]]; then
        exit $?
    fi
fi

# destructively copying files
if [ -d "./files" ]; then
    warning_echo "Copying files destructively"
    cp -r ./files/. ~/
fi

if [[ "$options_files_only" == true ]]; then
    exit 0
fi

build_success=0

# run nixos-rebuild
info_echo "Running nixos-rebuild"
if [[ -n "$options_hostname" ]]; then
    if [[ "$options_dry" == true ]]; then
        nix run nixpkgs#nh -- os switch path:$PWD/system --hostname $options_hostname --dry
        build_success=$?
    else
        nix run nixpkgs#nh -- os switch path:$PWD/system --hostname $options_hostname
        build_success=$?
    fi
else
    if [[ "$options_dry" == true ]]; then
        nix run nixpkgs#nh -- os switch path:$PWD/system --dry
        build_success=$?
    else
        nix run nixpkgs#nh -- os switch path:$PWD/system
        build_success=$?
    fi
fi

# if not success, exit
if [[ "$build_success" -ne 0 ]]; then
    exit $?
fi

# if --dry is set, exit
if [[ "$options_dry" == true ]]; then
    exit 0
fi

# find the current system generation
system_gen=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | awk '/\(current\)/ {print $1}')
success_echo "Current generation: $system_gen"

# commit changes
info_echo "Committing changes"
git add .
git -c user.name="NixOS Generation" -c user.email="no-valid@nixos.com" -c commit.gpgsign=false commit -m "system generation $system_gen"
