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

# ask for sudo first
if [[ "$EUID" -ne 0 ]]; then
    sudo "$0" "$@"
    exit $?
fi

options_dry_run=false
options_upgrade=false
options_files_only=false

for i in "$@"; do
    case $i in
        --dry-run)
            # dry run copies the files but does not build or commit
            options_dry_run=true
            ;;
        --upgrade)
            # upgrade runs nix flake update first
            options_upgrade=true
            ;;
        --files-only)
            # only copy files, do not run nixos-rebuild
            options_files_only=true
            ;;
        *)
            echo "Unknown option: $i"
            exit 1
            ;;
    esac
done

# put cwd to script path
cd "$(dirname "$0")"

# check if cwd is /home/$USER/nix
if [[ "$PWD" != "/home/$SUDO_USER/nix" ]]; then
    warning_echo "Please make sure your nix files are located in /home/$SUDO_USER/nix"
    exit 1
fi

# destructively copying files
if [ -d "./files" ]; then
    warning_echo "Copying files destructively"
    cp -r ./files/. ~/
fi

if [[ "$options_files_only" == true ]]; then
    exit 0
fi

# copy system nix files
info_echo "Syncing system configuration"
cp /etc/nixos/configuration.nix ./system/configuration.nix
cp /etc/nixos/hardware-configuration.nix ./system/hardware-configuration.nix

# check var.nix
if [ ! -f "./system/var.nix" ]; then
    warning_echo "var.nix not found."
    info_echo "Please create a var.nix file in ./system/ directory."
    info_echo "See ./system/var.nix.example for an example."
    warning_echo "Also make sure you enable flakes first: nix.settings.experimental-features = [ "nix-command" "flakes" ];"
    info_echo "Aborting..."
    exit 1
fi

# check if no-nix-channel is set to true in var.nix
if grep -Eq '^[^#]*no-nix-channel *= *true' ./system/var.nix; then
  # if ./no-nix-channel.nix is referenced, remove these files if they exist:
  channel_leftovers=(
    /root/.nix-defexpr/channels
    /nix/var/nix/profiles/per-user/root/channels
  )
  for channel_leftover in "${channel_leftovers[@]}"; do
    if [[ -d "$channel_leftover" ]]; then
      info_echo "removing ${channel_leftover}"
      rm -rf "$channel_leftover"
    fi
  done
fi

# if --dry-run is set, exit
if [[ "$options_dry_run" == true ]]; then
    exit 0
fi

# if --upgrade is set, run nix flake update first
if [[ "$options_upgrade" == true ]]; then
    info_echo "Running nix flake update"
    nix flake update --flake path:/home/$SUDO_USER/nix/system

    # if not success, exit
    if [[ "$?" -ne 0 ]]; then
        exit $?
    fi
fi

# run nixos-rebuild
info_echo "Running nixos-rebuild"
nixos-rebuild switch --flake path:/home/$SUDO_USER/nix/system

# if not success, exit
if [[ "$?" -ne 0 ]]; then
    exit $?
fi

# find the current system generation
system_gen=$(nix-env --list-generations --profile /nix/var/nix/profiles/system | awk '/\(current\)/ {print $1}')
success_echo "Current generation: $system_gen"

# drop root privileges and commit changes
if [[ "$EUID" -eq 0 ]]; then
    SUDO_USER_HOME=$(eval echo "~$SUDO_USER")
    info_echo "Committing changes as $SUDO_USER"

    # using sudo to switch to the original user, preserving environment
    sudo -u "$SUDO_USER" -- bash -c "
        cd $PWD
        git add .
        git -c user.name='TsFreddie NixOS' -c user.email='whatis+nix@tsdo.in' -c commit.gpgsign=false commit -m 'system generation $system_gen'
    "
else
    info_echo "Committing changes"
    git add .
    git -c user.name="TsFreddie NixOS" -c user.email="whatis+nix@tsdo.in" -c commit.gpgsign=false commit -m "system generation $system_gen"
fi
