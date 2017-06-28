##
## Installation of dotfiles
##

# Functions
targetify = $(subst /,_,$(subst :,@,$1))
untargetify = $(subst _,/,$(subst @,:,$1))

# Change default shell
SHELL := /bin/bash

#
# Set variables based on target environment
OS := $(shell lsb_release -si)
OS.VERSION := $(shell lsb_release -sr)
OS.VERSION.MAJOR := $(shell lsb_release -sr | awk -F\. '{print $$1}')
OS.NAME := $(shell lsb_release -sc)

DASH.SIZE := 12
TILE.PADDING := 6

FIREFOX.PROFILE := $(shell find $(HOME) -type d -path "*/.mozilla/firefox*" -name "*.default" 2>/dev/null)

ifeq ($(OS),Ubuntu)
	ubuntu.desktop := $(shell dpkg --list ubuntu-desktop 2>/dev/null | awk '/ubuntu-desktop/ {gsub("ii", "installed", $$1); print $$1}')
else
	ubuntu.desktop :=
endif

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

git.bash_it.url := $(protocol)://github.com/Bash-it/bash-it.git
git.bash_it.path := $(HOME)/.bash_it

git.gimpps.url := $(protocol)://github.com/doctormo/GimpPs
git.gimpps.path := $(HOME)/.gimp-2.8

git.tpm.url := $(protocol)://github.com/tmux-plugins/tpm
git.tpm.path := $(HOME)/.tmux/plugins/tpm

git.dependencies := vimrc vim_better_whitespace vim_tmux_focus_events vim_markdown_grip vim_python_mode vim_phpqa vim_nord typescript_vim bash_it tpm
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
apt.dependencies := stow git python3-pip tmux vim exuberant-ctags nodejs shellcheck fontconfig curl npm docker-ce colortail apt-transport-https ca-certificates software-properties-common libqt5x11extras5 libpcre2-8-0 tlp-rdw tlp libxml2-utils neofetch
#

#
# List of bash-it alias and plugins that should be enabled
bashit.enable := base alias-completion curl dirs docker general git less-pretty-cat ssh virtualenv
#

#
# List of gnome-shell extensions installed by system
gnome.shell.extensions := user-theme@gnome-shell-extensions.gcampax.github.com alternate-tab@gnome-shell-extensions.gcampax.github.com screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com gnome-shell-extension-multi-monitors system-monitor@paradoxxx.zero.gmail.com dash-to-dock@micxgx.gmail.com impatience@gfxmonk.net workspace-indicator@gnome-shell-extensions.gcampax.github.com TopIcons@phocean.net
#

#
# List of custom built deb packages that should be built and installed
dpkg.docker.images := docker-ubuntu-keepassxc-builder docker-ubuntu-termite-builder
dpkg.docker.packages := keepassxc libvte-2.91-0 termite
#

# List of firefox extensions to install
firefox.extensions := checkcompatibility/addon-300254-latest.xpi arc-dark-theme/platform:2/addon-656100-latest.xpi stylish/addon-2108-latest.xpi ublock-origin/addon-607454-latest.xpi passifox/addon-292320-latest.xpi colorfultabs/addon-1368-latest.xpi hide-tab-bar-with-one-tab/addon-429664-latest.xpi gnome-shell-integration/platform:2/addon-751081-latest.xpi printpdf/platform:2/addon-5971-latest.xpi roomy-bookmarks-toolbar/addon-210846-latest.xpi
#

# Need to clean up extension paths, to make them target safe
$(foreach extension, $(firefox.extensions), \
	$(eval _firefox.extensions := $(_firefox.extensions) $(call targetify, $(extension))) \
)

firefox.extensions := $(_firefox.extensions)
#

#
# Conditional dependencies
ifeq (installed,$(filter installed,$(ubuntu.desktop) $(gnome.shell)))
	git.dependencies := $(git.dependencies) gimpps
	apt.ppa.dependencies := $(apt.ppa.dependencies) ppa:snwh/pulp ppa:ne0sight/chrome-gnome-shell
	apt.dependencies := $(apt.dependencies) xsel gimp hexchat wmctrl firefox
	apt.theme.dependencies := paper-icon-theme paper-cursor-theme
endif

ifeq ($(ubuntu.desktop),installed)
	apt.dependencies := $(apt.dependencies) unity-tweak-tool indicator-multiload compizconfig-settings-manager
	apt.theme.dependencies := arc-theme $(apt.theme.dependencies)
endif

ifeq ($(gnome.shell),installed)
	apt.dependencies := $(apt.dependencies) arc-theme gnome-tweak-tool gnome-shell-extension-multi-monitors gnome-shell-extension-system-monitor gnome-shell-extension-dashtodock chrome-gnome-shell gnome-shell-extension-impatience gnome-shell-extension-top-icons-plus
endif

ifeq ($(OS),$(filter $(OS),Ubuntu Debian))
	bashit.enable := $(bashit.enable) apt
endif
#

.PHONY = all install reinstall uninstall test update _sanity_check _wrapped_stow _pre_stow _stow _post_stow _stow_ignore _install_args _reinstall_args _uninstall_args _test_args _ubuntu_desktop _install_theme _install_icon_theme _install_fonts _install_mouse_pointer_theme _install_terminal_theme _fix_unity_launcher _fix_lighdm _desktop _gnome_shell _fix_wallpaper _apt_ppa_dependencies _apt_dependencies _docker_packages_install _docker_packages_install_pre _firefox_extensions_install _firefox_extensions_install_pre $(git.dependencies) $(pip.dependencies) $(npm.dependencies) $(bashit.enable) $(firefox.extensions)

#
# Targets
#

#
# Internal targets
_sanity_check:
ifeq (installed,$(filter installed,$(ubuntu.desktop) $(gnome.shell)))
ifeq (,$(FIREFOX.PROFILE))
	$(error please start and close firefox, so you have a default profile)
endif
endif

_stow_ignore:
	$(foreach file,$(wildcard *),$(eval ARGS += --ignore=$(file)))
	$(eval ARGS += --ignore=.gitignore --ignore=.ropeproject/)

_stow: _stow_ignore
	@which stow &> /dev/null || sudo apt install stow
	@stow -t $(HOME) -v $(ARGS) .
ifeq ($(OS),$(filter $(OS),Ubuntu Debian))
	@sudo ln -fs $(shell readlink -f etc/apt/apt.conf.d/99progressbar) /etc/apt/apt.conf.d/99progressbar
endif

_install_args:
	$(eval ARGS := -S)

_reinstall_args:
	$(eval ARGS := -R)

_uninstall_args:
	$(eval ARGS := -D)

_test_args:
	$(eval ARGS := -n -S)

_wrapped_stow: _pre_stow _stow _post_stow

_pre_stow: $(git.dependencies) $(pip.dependencies) $(npm.dependencies)
	@[[ -e "$(HOME)/.bashrc" && ! -e "$(HOME)/.bashrc.old" ]] && mv "$(HOME)/.bashrc" "$(HOME)/.bashrc.old" || true

_post_stow: $(bashit.enable) _install_fonts _desktop
	@. ~/.bashrc
#

#
# Configuration targets
_docker_packages_install: _docker_packages_install_pre $(dpkg.docker.images)
	$(foreach package, $(dpkg.docker.packages), \
		$(eval PACKAGES += $(wildcard /tmp/mgor-dotfiles-packages/$(package)_*)) \
	)
	@sudo dpkg -i $(PACKAGES)
	@sudo rm -rf /tmp/mgor-dotfiles-packages || true
	$(info make termite the default terminal)
	@[[ ! -e /usr/bin/gnome-terminal.distrib ]] && { sudo dpkg-divert --add --rename /usr/bin/gnome-terminal && sudo ln -s /usr/bin/termite /usr/bin/gnome-terminal; } || true

_docker_packages_install_pre:
	@rm -rf /tmp/mgor-dotfiles-packages && mkdir -p /tmp/mgor-dotfiles-packages

$(dpkg.docker.images):
	@rm -rf /tmp/$@ 2>&1 >/dev/null || true && git clone $(protocol)://github.com/mgor/$@.git /tmp/$@
	@sudo su - "${USER}" -c 'cd /tmp/$@ && make RELEASE=$(OS.NAME)' && \
		cp /tmp/$@/packages/*.deb /tmp/mgor-dotfiles-packages/ && \
		rm -rf /tmp/$@

_firefox_extensions_install: _firefox_extensions_install_pre $(firefox.extensions)
	@rm -rf /tmp/mgor-firefox-extensions
	@echo "MANUAL: allow the installation of the compatible extensions, then close firefox" && \
		firefox &> /dev/null
	@echo "MANUAL: allow the installation of the incompatible extensions, then close firefox" && \
		firefox &> /dev/null

_firefox_extensions_install_pre:
	@rm -rf /tmp/mgor-firefox-extensions || true && mkdir -p /tmp/mgor-firefox-extensions
	@mkdir -p $(FIREFOX.PROFILE)/extensions

$(firefox.extensions):
	$(eval extension := $@)
	$(eval extension := $(call untargetify,$(extension)))
	$(info firefox extension: $(extension))
	@./firefox-install-extension.bash $(extension) $(FIREFOX.PROFILE)

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
ifeq ($(ubuntu.desktop),installed)
	$(info replacing dash icon)

	@if [[ ! -e /usr/share/unity/icons/launcher_bfb.orig.png ]]; then \
		sudo mv /usr/share/unity/icons/launcher_bfb.png /usr/share/unity/icons/launcher_bfb.orig.png; \
	fi

	@sudo cp /usr/share/icons/Paper/24x24/places/ubuntu.png /usr/share/unity/icons/launcher_bfb.png
endif

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
	{ curl -L -o /tmp/gnome-terminal.nord.sh https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/src/sh/nord.sh && \
		bash /tmp/gnome-terminal.nord.sh && \
		rm -rf /tmp/gnome-terminal.nord.sh || true; }

	$(info change terminal default size)
	@dconf write /org/gnome/terminal/legacy/profiles:/$(gnome.terminal.profile)/default-size-columns 120
	@dconf write /org/gnome/terminal/legacy/profiles:/$(gnome.terminal.profile)/default-size-rows 45
else
	$(NOOP)
endif

_fix_unity_launcher:
	$(info flatten unity launcher icons)
	@. .bashrc; git clone --use-defaults https://github.com/mjsolidarios/unity-flatify-icons.git /tmp/unity-flatify-icons
	@cd /tmp/unity-flatify-icons && bash unity-flatify-icons.sh; cd - &>/dev/null
	@rm -rf /tmp/unity-flatify-icons
	$(info change unity launcher icon size)
	@dconf write /org/compiz/profiles/unity/plugins/unityshell/icon-size 24

_fix_lightdm:
	$(info disabling lightdm grid and setting lightdm mouse pointer theme)
	@dconf write /com/canonical/unity-greeter/draw-grid false
	@sudo xhost +SI:localuser:lightdm &> /dev/null
	@echo $$'dconf write /org/gnome/desktop/interface/cursor-theme "\'Obsidian\'"' | sudo -H -u lightdm bash -s --
	@sudo -H -u lightdm bash -c 'dconf write /com/canonical/unity-greeter/draw-grid false'
	@sudo xhost -SI:localuser:lightdm &> /dev/null
	@[[ ! -e /etc/lightdm/lightdm.conf.d/50-no-guest.conf ]] && sudo bash -c 'printf "[Seat:*]\nallow-guest=false\n" > /etc/lightdm/lightdm.conf.d/50-no-guest.conf' || true

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

	@if [[ -e /etc/apt/sources.list.d/snwh-ubuntu-pulp-zesty.list ]]; then \
		sudo sed -ri 's|zesty|yakkety|' /etc/apt/sources.list.d/snwh-ubuntu-pulp-zesty.list; \
	fi
	@if ! grep -q "download.docker.com" /etc/apt/sources.list; then \
		echo "adding docker repository"; \
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu yakkety stable"; \
	fi
	@sudo apt-get update &>/dev/null

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
_desktop: _ubuntu_desktop _gnome_shell _firefox_extensions_install
	$(info change default browser to firefox)
	@sudo update-alternatives --set gnome-www-browser /usr/bin/firefox
	@sudo update-alternatives --set x-www-browser /usr/bin/firefox

ifeq ($(ubuntu.desktop),installed)
_ubuntu_desktop: _install_theme _install_icon_theme _install_mouse_pointer_theme _install_terminal_theme _fix_unity_launcher _fix_lightdm _fix_wallpaper
else
_ubuntu_desktop:
	$(NOOP)
endif

ifeq ($(gnome.shell),installed)
_gnome_shell: _install_theme _install_icon_theme _install_mouse_pointer_theme _fix_lightdm _fix_wallpaper
	$(info enabling bundled extensions)
	$(foreach extension, $(notdir $(wildcard .local/share/gnome-shell/extensions/*)), \
		$(shell gnome-shell-extension-tool -e $(extension)) \
	)

	$(info enabling system extensions)
	$(foreach extension, $(gnome.shell.extensions), \
		$(shell gnome-shell-extension-tool -e $(extension)) \
	)

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
	@dconf write /org/gnome/shell/overrides/dynamic-workspaces false
	@dconf write /org/gnome/shell/overrides/workspaces-only-on-primary false
	@dconf write /org/gnome/desktop/wm/preferences/workspace-names "['Social', 'Mail', 'Development', 'Random']"

	$(info changing shellshape settings)
	@dconf write /org/gnome/shell/extensions/net/gfxmonk/shellshape/prefs/default-layout "'vertical'"
	@dconf write /org/gnome/shell/extensions/net/gfxmonk/shellshape/prefs/screen-padding $(DASH.SIZE)
	@dconf write /org/gnome/shell/extensions/net/gfxmonk/shellshape/prefs/tile-padding $(TILE.PADDING)
	@dconf write /org/gnome/shell/extensions/net/gfxmonk/shellshape/prefs/show-indicator false

	$(info changing dash-to-dock settings)
	@dconf write /org/gnome/shell/extensions/dash-to-dock/opaque-background true
	@dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-running-dots-border-color "'#2e3436'"
	@dconf write /org/gnome/shell/extensions/dash-to-dock/show-apps-at-top false
	@dconf write /org/gnome/shell/extensions/dash-to-dock/extend-height true
	@dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed true
	@dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-running-dots-color "'#a3be8c'"
	@dconf write /org/gnome/shell/extensions/dash-to-dock/force-straight-corner true
	@dconf write /org/gnome/shell/extensions/dash-to-dock/show-show-apps-button false
	@dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-running-dots true
	@dconf write /org/gnome/shell/extensions/dash-to-dock/dock-position "'LEFT'"
	@dconf write /org/gnome/shell/extensions/dash-to-dock/show-favorites true
	@dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-shrink true
	@dconf write /org/gnome/shell/extensions/dash-to-dock/background-opacity 0.9
	@dconf write /org/gnome/shell/extensions/dash-to-dock/custom-theme-running-dots-border-width 1
	@dconf write /org/gnome/shell/extensions/dash-to-dock/dash-max-icon-size $(DASH.SIZE)
	@dconf write /org/gnome/shell/extensions/dash-to-dock/background-color "'#444444'"
	@dconf write /org/gnome/shell/extensions/dash-to-dock/height-fraction 0.65
	@dconf write /org/gnome/shell/extensions/dash-to-dock/icon-size-fixed true
	@dconf write /org/gnome/shell/extensions/dash-to-dock/isolate-workspaces true

	$(info changing system-monitor settings)
	@dconf write /org/gnome/shell/extensions/system-monitor/memory-show-text=false
	@dconf write /org/gnome/shell/extensions/system-monitor/net-graph-width=50
	@dconf write /org/gnome/shell/extensions/system-monitor/memory-program-color='#eceff4ff'
	@dconf write /org/gnome/shell/extensions/system-monitor/battery-show-text=false
	@dconf write /org/gnome/shell/extensions/system-monitor/compact-display=true
	@dconf write /org/gnome/shell/extensions/system-monitor/freq-freq-color='#edd400ff'
	@dconf write /org/gnome/shell/extensions/system-monitor/memory-buffer-color='#d8dee9ff'
	@dconf write /org/gnome/shell/extensions/system-monitor/move-clock=true
	@dconf write /org/gnome/shell/extensions/system-monitor/cpu-iowait-color='#5e81acff'
	@dconf write /org/gnome/shell/extensions/system-monitor/center-display=false
	@dconf write /org/gnome/shell/extensions/system-monitor/cpu-nice-color='#81a1c1ff'
	@dconf write /org/gnome/shell/extensions/system-monitor/fan-display=false
	@dconf write /org/gnome/shell/extensions/system-monitor/disk-graph-width=50
	@dconf write /org/gnome/shell/extensions/system-monitor/net-show-text=false
	@dconf write /org/gnome/shell/extensions/system-monitor/freq-show-text=false
	@dconf write /org/gnome/shell/extensions/system-monitor/net-up-color='#a3be8cff'
	@dconf write /org/gnome/shell/extensions/system-monitor/fan-show-menu=false
	@dconf write /org/gnome/shell/extensions/system-monitor/freq-display=false
	@dconf write /org/gnome/shell/extensions/system-monitor/memory-cache-color='#e5e9f0ff'
	@dconf write /org/gnome/shell/extensions/system-monitor/net-collisions-color='#ebcb8bff'
	@dconf write /org/gnome/shell/extensions/system-monitor/battery-graph-width=50
	@dconf write /org/gnome/shell/extensions/system-monitor/swap-graph-width=50
	@dconf write /org/gnome/shell/extensions/system-monitor/net-downerrors-color='#b48eadff'
	@dconf write /org/gnome/shell/extensions/system-monitor/thermal-graph-width=50
	@dconf write /org/gnome/shell/extensions/system-monitor/cpu-individual-cores=false
	@dconf write /org/gnome/shell/extensions/system-monitor/net-uperrors-color='#bf616aff'
	@dconf write /org/gnome/shell/extensions/system-monitor/icon-display=false
	@dconf write /org/gnome/shell/extensions/system-monitor/thermal-display=false
	@dconf write /org/gnome/shell/extensions/system-monitor/fan-show-text=false
	@dconf write /org/gnome/shell/extensions/system-monitor/cpu-graph-width=50
	@dconf write /org/gnome/shell/extensions/system-monitor/thermal-show-text=false
	@dconf write /org/gnome/shell/extensions/system-monitor/battery-display=true
	@dconf write /org/gnome/shell/extensions/system-monitor/battery-show-menu=false
	@dconf write /org/gnome/shell/extensions/system-monitor/net-down-color='#d08670ff'
	@dconf write /org/gnome/shell/extensions/system-monitor/cpu-user-color='#88c0d0ff'
	@dconf write /org/gnome/shell/extensions/system-monitor/memory-graph-width=50
	@dconf write /org/gnome/shell/extensions/system-monitor/cpu-system-color='#8fbcbbff'
	@dconf write /org/gnome/shell/extensions/system-monitor/fan-graph-width=50
	@dconf write /org/gnome/shell/extensions/system-monitor/freq-graph-width=50
	@dconf write /org/gnome/shell/extensions/system-monitor/background='#2e3039ff'
	@dconf write /org/gnome/shell/extensions/system-monitor/cpu-show-text=false
	@dconf write /org/gnome/shell/extensions/system-monitor/cpu-other-color='#4c566aff'
	@dconf write /org/gnome/shell/extensions/system-monitor/battery-hidesystem=true
	@dconf write /org/gnome/shell/extensions/system-monitor/freq-show-menu=false
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


install: _sanity_check _apt_dependencies _apt_ubuntu_desktop_dependencies _docker_packages_install _install_args _wrapped_stow

uninstall: _uninstall_args _wrapped_stow

reinstall: _reinstall_args _wrapped_stow

ifeq (installed,$(filter installed,$(ubuntu.desktop) $(gnome.shell)))
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
	$(info ubuntu.desktop = $(ubuntu.desktop))
	$(info gnome.shell = $(gnome.shell))
	$(info gnome.terminal = $(gnome.terminal))
	$(info gnome.terminal.profile = $(gnome.terminal.profile))
	$(info apt.ppa.dependencies = $(apt.ppa.dependencies))
	$(info apt.dependencies = $(apt.dependencies))
	$(info git.dependencies = $(git.dependencies))
	$(info npm.dependencies = $(npm.dependencies))
	$(info firefox.extensions = $(firefox.extensions))
	$(info firefox.profile = $(FIREFOX.PROFILE))
#
