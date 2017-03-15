# dotfiles

## Table of Contents

<!-- toc -->

- [Settings](#settings)
- [Usage](#usage)
- [TODO](#todo)
  * [gnome-shell](#gnome-shell)

<!-- tocstop -->

This is *my* `dotfiles`. Other than providing configuration files, dependencies needed for all the configuration will also be installed (or updated).

This has become a bit more than just a dotfile project, it will also install icon theme, mouse pointer theme, a patched version of notify-osd and change some lightdm settings.

Full functionality will only be setup on `Ubuntu` when package `ubuntu-desktop` is installed.

+ `Ubuntu` and `ubuntu-desktop`
  + Dependencies installed automagically, command line and user interface settings installed
+ `Ubuntu` **without** `ubuntu-desktop` or `Debian`
  + Dependencies installed automagically, command line settings installed
+ Other
  + Warning about which packages that must be installed (seen when running `make` without a target), command line settings installed

## Settings

Packages (cli):

+ `stow`
+ `git`
+ `python-pip3`
+ `tmux`
+ `vim`
+ `exuberant-ctags`

Packages (gui):

+ `unity-tweak-tool`
+ `indicator-multiload`
+ `compizconfig-settings-manager`
+ `redshift-gtk`
+ `xsel`
+ `gimp`
+ `hexchat`

`git` repositories:

+ [amix/vimrc](https://github.com/amix/vimrc.git)
+ [ntpeters/vim-better-whitespaces](https://github.com/ntpeters/vim-better-whitespaces.git)
+ [tmux-plugins/vim-tmux-focus-events](https://github.com/tmux-plugins/vim-tmux-focus-events.git)
+ [tmux-plugins/vim-tmux](https://github.com/tmux-plugins/vim-tmux.git)
+ [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm.git)
+ [Bash-it/bash-it](https://github.com/Bash-it/bash-it.git)
+ [doctormo/GimpPs](https://github.com/doctormo/GimpPs.git)

`pip` packages:

+ powerline-status

`bash-it` aliases and plugins:

+ alias-completion
+ curl
+ dirs
+ docker
+ git
+ less-pretty-cat
+ ssh
+ virtualenv

Custom scripts:

+ `dice-pwgen` - generates diceware passwords (not as secure as actually rolling a dice though)
+ `script-parse` - parses and produces a readable log file captured from command `script`

Configuration:

+ tmux
+ bash-it (custom multiline prompt theme)
+ git styling, and a hook that will ask you to configure `user.name` and `user.email` when cloning a new repository (possible to set defaults and not be asked)
+ ctags configuration for `python`, `bash`, `yaml`, `css`, `scss`, `html`, `puppet`, `javascript` and `php`
+ notify-osd, removing "ugly" gap between notifcation and top menu bar
+ vimrc
+ hexchat theme
+ ubuntu mono derivative with powerline symbols font

gui configuration:

+ gtk/unity theme Arc-Dark
+ icon theme Papirus Dark GTK
+ mouse pointer theme Obsidian
+ flatten unity icons and set unity icon size
+ disable lightdm grid and change lightdm mouse pointer theme to Obsidian
+ gnome-terminal solaried color theme
+ dir-colors solarized color theme
+ set wallpaper

Probably some additional tweaks not mentioned as well :)

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

To uninstall (un-stow) the files:

    make uninstall

## TODO

### gnome-shell

- [x] install and enable bundled extensions
- [x] enable system extensions
- [x] configure extensions
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
    - [ ] arc dark theme
    - [ ] disable compability check
    - [ ] stylus
    - [ ] uBlock
    - [ ] passlfox
- [x] build and install custom packages
    - [x] docker-ubuntu-keepassxc-builder
    - [x] docker-ubuntu-termite-builder
