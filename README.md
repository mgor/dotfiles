# dotfiles

This is *my* `dotfiles`. Other than providing configuration files, dependencies needed for all the configuration will also be installed (or updated).

If you want to try them out, you should fork the repository and make additional changes. For example, you *must* update `.gitconfig`.

## Dependencies
You need `stow` and `git` installed to be able to use the `Makefile`:

    sudo apt install stow git

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

