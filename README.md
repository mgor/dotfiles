# dotfiles

This is *my* `dotfiles`. Other than providing configuration files, dependencies needed for all the configuration will also be installed (or updated).

This has become a bit more than just a dotfile project, it will also install icon theme, mouse pointer theme, a patched version of notify-osd and change some lightdm settings.

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

