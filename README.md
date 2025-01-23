# TsFreddie's NixOS Configuration

> no one should use this

## Note to self

### system

The system will be built from this directory. Before rebuild, `rebuild.sh` script will copy the `configuration.nix` and `hardware-configuration.nix` from `/etc/nixos` to into the `system` directory, then run `nixos-rebuild switch --flake path:./system`.

Note that this is not a flake repository, so `configuration.nix` and `hardware-configuration.nix` are not commited. Nothing in here will be put in store. You did it this way so you can rebuild first then commit and make it more portable without commiting to a fixed system configuration. ***DO NOT attempt to convert this to a flake repository, you already tried that.***

### files

The `files` directory will be `cp`ed into the home directory, overwriting existing files. This is destructive, so be careful when putting files there.

Files usually sits in the `files` directory due to at least one of the following reasons:

- The file might be saved by an application by re-creating the file, breaking the symlink. This can cause home manager to fail.
- The target application actively ignores symlinks. (e.g. `fcitx5-rime`)

You can easily copy any file from the home directory into the `files` directory by using the `./pin-file.sh <path>` script.
