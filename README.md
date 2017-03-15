# dotfiles

## Table of Contents

<!-- toc -->

- [Description](#description)
- [Usage](#usage)
- [Tasks](#tasks)

<!-- tocstop -->

## Description

This is *my* `dotfiles`. Other than providing configuration files, dependencies needed for all the configuration will also be installed (or updated).

This has become a bit more than just a dotfile project, it will configure the environment as much as possible.

Full functionality will only be setup on `Ubuntu` when package `ubuntu-desktop` or `gnome-shell` is installed.

+ `Ubuntu` and `ubuntu-desktop` or `gnome-shell`
  + Dependencies installed automagically, command line and user interface settings installed
+ `Ubuntu` **without** `ubuntu-desktop` or `Debian`
  + Dependencies installed automagically, command line settings installed
+ Other
  + Warning about which packages that must be installed (seen when running `make` without a target), command line settings installed

## Usage
You should probably start with:

    make test

To see which files and where they will be installed. You probably have to move some existing files.

Install with:

    make install

If you prefer (or must) use a different protocol than `https`:

    make protocol=git install

`https`, `git` and `ssh` are available for github.

To update `git` and `pip` dependencies:

    make update


## Tasks

- [x] install and enable bundled gnome-shell extensions
- [x] enable system gnome-shell extensions
- [x] configure gnome-shell
- [x] set wallpaper
- [x] install and set theme (gtk, gnome-shell, ..)  
- [x] install and set icon theme
- [x] install and set mouse pointer theme
- [x] set fonts (with `dconf`)
- [x] replace all `gsettings` with `dconf`
- [x] install and set lock screen theme
- [x] configure `lightdm`
- [x] fix strange invisible border around `gnome-terminal` right and bottom side (fixed by changing to termite)
- [ ] install firefox extensions/themes/plugins
    - [ ] [disable compability check](https://addons.mozilla.org/firefox/downloads/latest/checkcompatibility/addon-300254-latest.xpi)
    - [ ] [arc dark theme](https://addons.mozilla.org/firefox/downloads/latest/arc-dark-theme/platform:2/addon-656100-latest.xpi)
    - [ ] [stylish](https://addons.mozilla.org/firefox/downloads/latest/stylish/addon-2108-latest.xpi)
    - [ ] [uBlock origin](https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi)
    - [ ] [passifox](https://addons.mozilla.org/firefox/downloads/latest/passifox/addon-292320-latest.xpi)
    - [ ] [colorfultabs](https://addons.mozilla.org/firefox/downloads/latest/colorfultabs/addon-1368-latest.xpi)
- [x] build and install custom packages
    - [x] docker-ubuntu-keepassxc-builder
    - [x] docker-ubuntu-termite-builder
