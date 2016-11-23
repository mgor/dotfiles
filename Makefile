protocol ?= https

git.vimrc.url := $(protocol)://github.com/amix/vimrc.git
git.vimrc.path := $(HOME)/.vim_runtime

git.vim_better_whitespace.url := $(protocol)://github.com/ntpeters/vim-better-whitespace.git
git.vim_better_whitespace.path := $(git.vimrc.path)/sources_non_forked/vim-better-whitespace

git.bash_it.url := $(protocol)://github.com/Bash-it/bash-it.git
git.bash_it.path := $(HOME)/.bash_it

git.gimpps.url := $(protocol)://github.com/doctormo/GimpPs
git.gimpps.path := $(HOME)/.gimp-2.8

ubuntu.version := $(shell lsb_release -sr)
apt.dependencies := stow git python3-pip tmux
apt.theme.dependencies := arc-theme

git.dependencies := vimrc vim_better_whitespace bash_it gimpps
pip.dependencies := powerline-status

bashit.enable := apt alias-completion curl dirs docker general git less-pretty-cat ssh virtualenv

.PHONY = all install reinstall uninstall test _wrapped_stow _pre_stow _stow _post_stow _stow_ignore _install_args _reinstall_args _uninstall_args _test_args _install_theme _install_icon_theme _install_fonts _install_mouse_pointer_theme _fix_unity_launcher _fix_lighdm _fix_notify_osd _fix_wallpaper _apt_dependencies $(git.dependencies) $(pip.dependencies) $(bashit.enable)

all:
	$(error You probably want to run 'make test' first)

_stow_ignore:
	$(foreach file,$(wildcard *),$(eval ARGS += --ignore=$(file)))
	$(eval ARGS += --ignore=.gitignore)

_stow: _stow_ignore
	@stow -t $(HOME) -v $(ARGS) .

$(git.dependencies):
	$(info git dependency: $@)
	$(eval path := ${git.${@}.path})
	$(eval url := ${git.${@}.url})
	@if [ -d ${path}/.git ]; then \
		cd ${path} && git stash > /dev/null 2>&1; git pull --rebase && git stash pop > /dev/null 2>&1; cd - > /dev/null 2>&1; \
	else \
		git clone ${url} ${path}; \
		cd ${path} && git config user.email "$(USER)@$(shell hostname)" && git config user.name "$(USER)"; cd - > /dev/null 2>&1; \
	fi

$(pip.dependencies):
	$(info pip dependency: $@)
	@pip3 install --user -U $@

$(bashit.enable):
	@if [ -e ~/.bash_it/plugins/available/$@.plugin.bash ]; then \
		echo "enable bash-it plugin: $@"; \
		mkdir -p ~/.bash_it/plugins/enabled; \
		cd ~/.bash_it/plugins/enabled && \
		ln -f -s ../available/$@.plugin.bash || true && \
		cd - 2>&1 > /dev/null; \
	fi

	@if [ -e ~/.bash_it/aliases/available/$@.aliases.bash ]; then \
		echo "enable bash-it alias : $@"; \
		mkdir -p ~/.bash_it/aliases/enabled; \
		cd ~/.bash_it/aliases/enabled && \
		ln -f -s ../available/$@.aliases.bash || true && \
		cd - 2>&1 > /dev/null; \
	fi

_install_theme:
	@if [ $(shell echo $(ubuntu.version)\>=16.10 | bc ) -eq 1 ]; then \
		echo "changing GTK and WM theme to arc-theme"; \
		gsettings set org.gnome.desktop.interface gtk-theme "Arc-Dark"; \
		gsettings set org.gnome.desktop.wm.preferences theme "Arc-Dark"; \
	fi

_install_icon_theme:
	@wget -q -O - https://raw.githubusercontent.com/mgor/papirus-icon-theme-gtk/master/install-papirus-home.sh | bash
	@echo "replacing dash icon (might require sudo password)"

	@if [ ! -e /usr/share/unity/icons/launcher_bfb.orig.png ]; then \
		sudo mv /usr/share/unity/icons/launcher_bfb.png /usr/share/unity/icons/launcher_bfb.orig.png; \
	fi

	@sudo cp ~/.icons/Papirus-GTK/48x48/apps/launcher_bfb.png /usr/share/unity/icons/launcher_bfb.png

	@echo "changing icon theme"
	@gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark-GTK'

_install_fonts:
	@echo "updating font cache"
	@fc-cache -vf $(HOME)/.fonts/ 2>&1 > /dev/null

_install_mouse_pointer_theme:
	@echo "installing mouse pointer theme (might require sudo password)"
	@curl -o /tmp/obsidian.tar.bz2 https://dl.opendesktop.org/api/files/download/id/1460735403/73135-Obsidian.tar.bz2
	@sudo tar jxf /tmp/obsidian.tar.bz2 -C /usr/share/icons/
	@rm -rf /tmp/obsidian.tar.bz2

	@if ! update-alternatives --display x-cursor-theme | grep -q Obsidian; then \
		sudo update-alternatives --install /usr/share/icons/default/index.theme x-cursor-theme /usr/share/icons/Obsidian/index.theme 20; \
		sudo update-alternatives --set x-cursor-theme /usr/share/icons/Obsidian/index.theme; \
	fi

	@if ! gsettings get org.gnome.desktop.interface cursor-theme | grep -q Obsidian; then \
		gsettings set org.gnome.desktop.interface cursor-theme "Obsidian"; \
	fi

	@if ! grep -q "Xcursor.theme: Obsidian" /etc/X11/Xresources/x11-common; then \
		sudo bash -c 'echo "Xcursor.size: 24" >> /etc/X11/Xresources/x11-common'; \
		sudo bash -c 'echo "Xcursor.theme: Obsidian" >> /etc/X11/Xresources/x11-common'; \
	fi

_fix_unity_launcher:
	@echo "flatten unity launcher icons (might require sudo password)"
	@git clone https://github.com/mjsolidarios/unity-flatify-icons.git /tmp/unity-flatify-icons
	@cd /tmp/unity-flatify-icons && bash unity-flatify-icons.sh; cd - 2>&1 > /dev/null
	@rm -rf /tmp/unity-flatify-icons

_fix_lightdm:
	@echo "disabling lightdm grid and setting lightdm mouse pointer theme (might require sudo password)"
	@gsettings set com.canonical.unity-greeter draw-grid false
	@sudo xhost +SI:localuser:lightdm 2>&1 > /dev/null
	@sudo -u lightdm bash -c 'gsettings set org.gnome.desktop.interface cursor-theme "Obsidian"' 2>&1 > /dev/null
	@sudo -u lightdm bash -c 'gsettings set com.canonical.unity-greeter draw-grid false' 2>&1 > /dev/null
	@sudo xhost -SI:localuser:lightdm 2>&1 > /dev/null

_fix_notify_osd:
	@if ! grep -q leolik /etc/apt/sources.list.d/*.list; then \
		echo "installing patched notify-osd (might require sudo password)"; \
		sudo add-apt-repository ppa:leolik/leolik; \
		sudo apt-get update; \
		sudo apt-get -y upgrade; \
	fi

_fix_wallpaper:
	@echo "setting wallpaper"
	@gsettings set org.gnome.desktop.background picture-uri file://$(HOME)/.local/share/wallpapers/$(ubuntu.version).png

_apt_dependencies:
	@echo "installing apt dependencies"
	@sudo apt-get update 2>&1 > /dev/null
	@if [ $(shell echo $(ubuntu.version)\>=16.10 | bc ) -eq 1 ]; then \
		@sudo apt-get install -y $(apt.theme.dependencies); \
	fi
	@sudo apt-get install -y $(apt.dependencies)

_pre_stow: $(git.dependencies) $(pip.dependencies)

_post_stow: $(bashit.enable) _install_fonts _install_icon_theme _install_mouse_pointer_theme _fix_unity_launcher _fix_lightdm _fix_notify_osd _fix_wallpaper

_install_args:
	$(eval ARGS := -S)

_reinstall_args:
	$(eval ARGS := -R)

_uninstall_args:
	$(eval ARGS := -D)

_test_args:
	$(eval ARGS := -n -S)

_wrapped_stow: _pre_stow _stow _post_stow

install: _apt_dependencies _install_args _wrapped_stow

uninstall: _uninstall_args _wrapped_stow

reinstall: _reinstall_args _wrapped_stow

test: _test_args _stow
