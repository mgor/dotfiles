##
## Installation of dotfiles
##

# Change default shell
SHELL := /bin/bash

#
# Set variables based on target environment
OS := $(shell lsb_release -si)
OS.VERSION := $(shell lsb_release -sr)
OS.VERSION.MAJOR := $(shell lsb_release -sr | awk -F\. '{print $$1}')
OS.NAME := $(shell lsb_release -sc)

ifeq ($(OS),$(filter $(OS),Ubuntu Debian))
	gnome.shell := $(shell dpkg --list gnome-shell 2>/dev/null | awk '/gnome-shell/ {gsub("ii", "installed", $$1); print $$1}')
	gnome.terminal := $(shell dpkg --list gnome-terminal 2>/dev/null | awk '/gnome-terminal/ {gsub("ii", "installed", $$1); print $$1}')
else
	gnome.shell :=
	gnome.terminal :=
endif

ifeq (installed,$(gnome.terminal))
	gnome.terminal.profile := $(shell dconf list /org/gnome/terminal/legacy/profiles:/ | grep ^: | sed 's/\///g' | head -1)
else
	gnome.terminal.profile :=
endif
#

# Fetch GIT repositories over https as default, override with:
# make -Dprotocol=ssh
protocol ?= https

#
# List of GIT repositories that should be cloned, or updated if they exists
git.vimrc.url := $(protocol)://github.com/amix/vimrc.git
git.vimrc.path := $(HOME)/.vim_runtime

git.vim_better_whitespace.url := $(protocol)://github.com/ntpeters/vim-better-whitespace.git
git.vim_better_whitespace.path := $(git.vimrc.path)/sources_non_forked/vim-better-whitespace

git.vim_tmux_focus_events.url := $(protocol)://github.com/tmux-plugins/vim-tmux-focus-events.git
git.vim_tmux_focus_events.path := $(git.vimrc.path)/sources_non_forked/vim-tmux-focus-events

git.typescript_vim.url := $(protocol)://github.com/leafgarland/typescript-vim.git
git.typescript_vim.path := $(git.vimrc.path)/sources_non_forked/typescript-vim

git.vim_tmux.url := $(protocol)://github.com/tmux-plugins/vim-tmux.git
git.vim_tmux.path := $(git.vimrc.path)/sources_non_forked/vim-tmux

git.vim_markdown_grip.url := $(protocol)://github.com/mgor/vim-markdown-grip.git
git.vim_markdown_grip.path := $(git.vimrc.path)/sources_non_forked/vim-markdown-grip

git.vim_python_mode.url := $(protocol)://github.com/python-mode/python-mode.git
git.vim_python_mode.path := $(git.vimrc.path)/sources_non_forked/python-mode

git.vim_phpqa.url := $(protocol)://github.com/joonty/vim-phpqa.git
git.vim_phpqa.path := $(git.vimrc.path)/sources_non_forked/vim-phpqa

git.vim_nord.url := $(protocol)://github.com/arcticicestudio/nord-vim.git
git.vim_nord.path := $(git.vimrc.path)/sources_non_forked/nord-vim

git.vim_vice.url := $(protocol)://github.com/bcicen/vim-vice.git
git.vim_vice.path := $(git.vimrc.path)/sources_non_forked/vim-vice

git.bash_it.url := $(protocol)://github.com/Bash-it/bash-it.git
git.bash_it.path := $(HOME)/.bash_it

git.gimpps.url := $(protocol)://github.com/doctormo/GimpPs
git.gimpps.path := $(HOME)/.gimp-2.8

git.tpm.url := $(protocol)://github.com/tmux-plugins/tpm
git.tpm.path := $(HOME)/.tmux/plugins/tpm

git.dependencies := vimrc vim_better_whitespace vim_tmux_focus_events vim_markdown_grip vim_python_mode vim_phpqa vim_nord typescript_vim bash_it tpm vim_vice
#

#
# List of PIP dependencies that should be installed
pip.dependencies := powerline-status grip
#

#
# List of NPM dependencies that should be installed
npm.dependencies := markdown-pdf markdown-toc uglifycss uglify-js
#

#
# List of PPAs that should be added
apt.ppa.dependencies :=
#

#
# List of DEB packages that should be installed
apt.dependencies := stow git python3-pip tmux neovim exuberant-ctags shellcheck fontconfig curl docker.io colortail apt-transport-https ca-certificates software-properties-common libqt5x11extras5 libpcre2-8-0 tlp-rdw tlp libxml2-utils neofetch libpcre2-8-0
#

#
# List of bash-it alias and plugins that should be enabled
bashit.enable := base alias-completion curl dirs docker general git less-pretty-cat ssh virtualenv
#

#
# Conditional dependencies
ifeq ($(gnome.shell),installed)
	git.dependencies := $(git.dependencies) gimpps
	apt.ppa.dependencies := $(apt.ppa.dependencies) ppa:snwh/ppa ppa:fossfreedom/arc-gtk-theme-daily ppa:phoerious/keepassxc
	apt.dependencies := $(apt.dependencies) xsel gimp hexchat wmctrl firefox gnome-tweak-tool keepassxc
	apt.theme.dependencies := arc-theme paper-icon-theme
endif

ifeq ($(OS),$(filter $(OS),Ubuntu Debian))
	bashit.enable := $(bashit.enable) apt
endif
#

.PHONY = all install reinstall uninstall test update stow _wrapped_stow _pre_stow _stow _post_stow _stow_ignore _install_args _reinstall_args _uninstall_args _test_args _install_theme _install_icon_theme _install_fonts _install_mouse_pointer_theme _install_terminal_theme _desktop _gnome_shell _fix_wallpaper _apt_ppa_dependencies _apt_dependencies $(git.dependencies) $(pip.dependencies) $(npm.dependencies) $(bashit.enable)

#
# Targets
#

#
# Internal targets
_stow_ignore:
	$(foreach file,$(wildcard *),$(eval ARGS += --ignore=$(file)))
	$(eval ARGS += --ignore=.gitignore --ignore=.ropeproject/)

stow: _stow_ignore
	@command -v stow &> /dev/null || sudo apt install stow
	@stow -t $(HOME) -v $(ARGS) .
	@sudo stow -t /etc -v $(ARGS) etc/

_install_args:
	$(eval ARGS := -S)

_reinstall_args:
	$(eval ARGS := -R)

_uninstall_args:
	$(eval ARGS := -D)

_test_args:
	$(eval ARGS := -n -S)

_wrapped_stow: _pre_stow stow _post_stow

_pre_stow: $(git.dependencies) $(pip.dependencies) $(npm.dependencies)
	@[[ -e "$(HOME)/.bashrc" && ! -e "$(HOME)/.bashrc.old" ]] && mv "$(HOME)/.bashrc" "$(HOME)/.bashrc.old" || true

_post_stow: $(bashit.enable) _install_fonts _desktop
	@sudo update-alternatives --set vim /usr/bin/nvim
	@. ~/.bashrc
#

#
# Configuration targets
_install_theme:
	$(info change ark-dark colors to something from nord palette)
	$(info selected items, nord9)
	@sudo find /usr/share/themes/Arc-Dark -type f -exec sed -i 's/#5294e2/#81A1C1/gI' {} \;
	@sudo find /usr/share/themes/Arc-Dark -type f -exec sed -i 's/#2679db/#81A1C1/gI' {} \;

	$(info close buttons/icons, nord12 and nord11)
	@sudo find /usr/share/themes/Arc-Dark -type f -exec sed -i 's/#cc575d/#D08770/gI' {} \;
	@sudo find /usr/share/themes/Arc-Dark -type f -exec sed -i 's/#d7787d/#BF616A/gI' {} \;
	@sudo find /usr/share/themes/Arc-Dark -name "close-active.svg" -exec sed -i 's/#d8354a/#D08770/gI' {} \;
	@sudo find /usr/share/themes/Arc-Dark -name "close-hover.svg" -exec sed -i 's/#ff7a80/#BF616A/gI' {} \;

	$(info logout/power off buttons, variations of nord11)
	@sudo find /usr/share/themes/Arc-Dark -type f -exec sed -i 's/#ee3239/#BF4E59/gI' {} \;
	@sudo find /usr/share/themes/Arc-Dark -type f -exec sed -i 's/#f04a50/#BF616A/gI' {} \;
	@sudo find /usr/share/themes/Arc-Dark -type f -exec sed -i 's/#f47479/#BF747B/gI' {} \;

	$(info changing GTK and WM theme to arc-theme)
	@dconf write /org/gnome/desktop/interface/gtk-theme "'Arc-Dark'"
	@dconf write /org/gnome/desktop/wm/preferences/theme "'Arc-Dark'"
	@dconf write /org/gnome/shell/extensions/user-theme/name "'Arc-Dark'"

_install_icon_theme:
	$(info changing icon theme)
	@dconf write /org/gnome/desktop/interface/icon-theme "'Paper'"

_install_fonts:
	$(info updating font cache)
	@fc-cache -vf $(HOME)/.fonts/ &>/dev/null

_install_mouse_pointer_theme:
	$(info installing mouse pointer theme)

	@sudo update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /usr/share/icons/Paper/cursor.theme 19
	@sudo update-alternatives --set x-cursor-theme /usr/share/icons/Paper/cursor.theme

	@dconf write /org/gnome/desktop/interface/cursor-theme "'Paper'"

	@if ! grep -q "Xcursor.theme: Paper" /etc/X11/Xresources/x11-common; then \
		sudo bash -c 'echo "Xcursor.size: $(DASH.SIZE)" >> /etc/X11/Xresources/x11-common'; \
		sudo bash -c 'echo "Xcursor.theme: Paper" >> /etc/X11/Xresources/x11-common'; \
	fi

_install_terminal_theme:
ifneq ($(gnome.shell),installed)
	$(info install terminal theme)
	@dconf read /org/gnome/terminal/legacy/profiles:/$(gnome.terminal.profile)/visible-name | grep -q Nord || \
	{ curl -L -o /tmp/gnome-terminal.nord.sh https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/src/nord.sh && \
		bash /tmp/gnome-terminal.nord.sh && \
		rm -rf /tmp/gnome-terminal.nord.sh || true; }

	$(info change terminal default size)
	@dconf write /org/gnome/terminal/legacy/profiles:/$(gnome.terminal.profile)/default-size-columns 120
	@dconf write /org/gnome/terminal/legacy/profiles:/$(gnome.terminal.profile)/default-size-rows 45
	@dconf write /org/gnome/terminal/legacy/profiles:/$(gnome.terminal.profile)/font "'Source Code Pro 8'"

	$(info do not show menubar)
	@dconf write /org/gnome/terminal/legacy/default-show-menubar false
else
	$(NOOP)
endif

_fix_wallpaper:
	$(info setting wallpaper)
	@dconf write /org/gnome/desktop/background/picture-uri "'file://$(HOME)/.local/share/wallpapers/$(OS.VERSION).png'"
	@dconf write /org/gnome/desktop/screensaver/picture-uri "'file://$(HOME)/.local/share/wallpapers/$(OS.VERSION).png'"
	@dconf write /org/gnome/desktop/background/show-desktop-icons false
#

#
# Dependencies targets
_apt_ubuntu_desktop_dependencies:
	$(info installing apt theme dependencies)
	@sudo apt-get install -y $(apt.theme.dependencies)

_apt_ppa_dependencies:
	@echo "many commands require sudo, let us authenticate now"; \
		sudo uptime >/dev/null
	$(info adding ppa: $(apt.ppa.dependencies))
	$(foreach ppa, $(apt.ppa.dependencies), \
		@sudo add-apt-repository -y $(ppa) \
	)

ifeq ($(OS),$(filter $(OS),Ubuntu Debian))
_apt_dependencies: _apt_ppa_dependencies
	$(info installing apt dependencies)
	@sudo apt-get install -y $(apt.dependencies)
	@[[ ! -e /usr/bin/node ]] && sudo ln -s /usr/bin/nodejs /usr/bin/node || true
	$(info fixing group permissions)
	@sudo usermod -a -G docker "${USER}"
else
_apt_dependencies:
	$(warning Make sure that the following packages are installed: $(apt.dependencies))
endif

$(git.dependencies):
	$(info git dependency: $@)
	$(eval path := ${git.${@}.path})
	$(eval url := ${git.${@}.url})
	@if [[ -d ${path}/.git ]]; then \
		pushd ${path} &>/dev/null && git stash &>/dev/null || true; git pull --rebase && git stash pop &>/dev/null || true; popd &>/dev/null; \
	else \
		git clone ${url} ${path}; \
		pushd ${path} &>/dev/null; \
		git config user.name "dotfiles"; \
		git config user.email "dotfiles@localhost"; \
		popd; \
	fi

$(pip.dependencies):
	$(info pip dependency: $@)
	@pip3 install --user -U $@

$(npm.dependencies):
	$(info npm dependency: $@)
	@sudo npm update -g $@

$(bashit.enable):
	@if [[ -e ~/.bash_it/plugins/available/$@.plugin.bash ]]; then \
		echo "enable bash-it plugin: $@"; \
		mkdir -p ~/.bash_it/plugins/enabled; \
		cd ~/.bash_it/plugins/enabled && \
		ln -f -s ../available/$@.plugin.bash || true && \
		cd - &>/dev/null; \
	fi

	@if [[ -e ~/.bash_it/aliases/available/$@.aliases.bash ]]; then \
		echo "enable bash-it alias : $@"; \
		mkdir -p ~/.bash_it/aliases/enabled; \
		cd ~/.bash_it/aliases/enabled && \
		ln -f -s ../available/$@.aliases.bash || true && \
		cd - &>/dev/null; \
	fi
#

#
# DE configuration targets
_desktop: _gnome_shell
	$(info change default browser to firefox)
	@sudo update-alternatives --set gnome-www-browser /usr/bin/firefox
	@sudo update-alternatives --set x-www-browser /usr/bin/firefox

ifeq ($(gnome.shell),installed)
_gnome_shell: _install_theme _install_icon_theme _install_mouse_pointer_theme _fix_wallpaper _install_terminal_theme
	$(info change gnome-shell settings)
	@dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'Ubuntu 8'"
	@dconf write /org/gnome/desktop/interface/font-name "'Ubuntu 8'"
	@dconf write /org/gnome/desktop/interface/document-font-name "'Sans 8'"
	@dconf write /org/gnome/desktop/interface/monospace-font-name "'Ubuntu Mono derivative Powerline 8'"
	@dconf write /org/gnome/desktop/interface/clock-show-seconds true
	@dconf write /org/gnome/desktop/interface/clock-show-date true
	@dconf write /org/gnome/desktop/interface/enable-animations true
	@dconf write /org/gnome/desktop/calendar/show-weekdate true
	@dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled true
	@dconf write /org/gnome/settings-daemon/plugins/power/lid-close-battery-action "'hibernate'"
	@dconf write /org/gnome/settings-daemon/plugins/power/lid-close-ac-action "'suspend'"
	@dconf write /org/gnome/settings-daemon/plugins/media-keys/screensaver "'<Primary><Super>l'"
	@dconf write /org/gnome/system/location true
	@dconf write /org/gnome/shell/window-switcher/app-icon-mode "'both'"
	@dconf write /org/gnome/shell/overrides/dynamic-workspaces true
	@dconf write /org/gnome/shell/overrides/workspaces-only-on-primary false
else
_gnome_shell:
	$(NOOP)
endif
#

#
# Public targets
all:
ifneq ($(OS),$(filter $(OS),Ubuntu Debian))
	$(warning Make sure that the following packages are installed: $(apt.dependencies))
endif
	$(error You probably want to run 'make test' first)


install: _apt_dependencies _apt_ubuntu_desktop_dependencies _install_args _wrapped_stow

uninstall: _uninstall_args _wrapped_stow

reinstall: _reinstall_args _wrapped_stow

ifeq (installed,$(gnome.shell))
update: $(git.dependencies) $(pip.dependencies) _install_icon_theme
else
update: $(git.dependencies) $(pip.dependencies)
endif
	$(info get latest version)
	@git stash &>/dev/null || true && git pull --rebase && git stash pop &>/dev/null || true
	@. ~/.bashrc
ifneq ($(TMUX),)
	@tmux source-file ~/.tmux.conf
endif

test: _test_args _stow
	$(info stow arguments: $(ARGS))
	$(info OS = $(OS))
	$(info gnome.shell = $(gnome.shell))
	$(info gnome.terminal = $(gnome.terminal))
	$(info gnome.terminal.profile = $(gnome.terminal.profile))
	$(info apt.ppa.dependencies = $(apt.ppa.dependencies))
	$(info apt.dependencies = $(apt.dependencies))
	$(info git.dependencies = $(git.dependencies))
	$(info npm.dependencies = $(npm.dependencies))
#
