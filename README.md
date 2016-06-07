# dotfiles

This is my `dotfiles`. Other than providing configuration files, dependencies needed for all the configuration will also be installed (or updated).

## Dependencies
You need `stow`, `python-pip` and `git` installed to be able to use the `Makefile`:

    sudo apt install stow python-pip git

## Usage
You should probably start with:

    make test

To see which files and where they will be installed. You probably have to move some existing files.

Install with:

    make install

If you prefer (or must) use a different protocol than `https`:

    make protocol=git install

`https`, `git` and `ssh` are available for github.

To uninstall (un-stow) the files:

    make uninstall

