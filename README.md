# TsFreddie's NixOS Configuration

> no one should use this

## Note to self

### system

The system will be built from this directory. After build this script will automatically commit the changes.
You did it this way so you can rebuild first then commit to make sure every commit builds without having to reset. ***DO NOT attempt to convert this to a flake repository, you already tried that.***

### files

The `files` directory will be `cp`ed into the home directory, overwriting existing files. This is destructive, so be careful when putting files there.

Files usually sits in the `files` directory due to at least one of the following reasons:

- The file might be saved by an application by re-creating the file, breaking the symlink. This can cause home manager to fail.
- The target application actively ignores symlinks. (e.g. `fcitx5-rime`)

You can easily copy any file from the home directory into the `files` directory by using the `./pin-file.sh <path>` script.

### nid

`nid <name>` is a wrapper around `nix develop` that makes it easier to setup a develop environment. Simply run `nid <name>` to enter a develop environment set up by the `develop/<name>/flake.nix` file.

You can create a new develop environment by running `nid create <name>`. (This essentially duplicates the `empty` develop environment and renames it to `<name>`)

Note that `nid` is able to daisy chain multiple environments, e.g. `nid rust bun -- code .` will setup a `bun` environment inside a `rust` environment then open vscode in the current directory. 

However, you can also use `nid setup <name>` to create a `.envrc` file in the current directory and copies the `develop/<name>` template to `./.nid`. This is preferred for setting up environment for a project.

Note that `nid setup` can only setup a single environment. You should setup one environment then edit the `./.nid/flake.nix` file to update more. (Or you can just use `nid setup empty` to create a empty template so you can add packages yourself.)

Also, `nid` treats flakes as normal files instead of git repositories. It doesn't make much sense to me to use git for these. Also .nid and .envrc are globally `.gitignore`d, so you don't have to worry about accidentally committing them. (This does mean if you want to make a nix specific file, you have to manually add the .envrc file)
