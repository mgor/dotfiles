git.vimrc.url := https://github.com/amix/vimrc.git
git.vimrc.path := $(HOME)/.vim_runtime

git.bash_it.url := https://github.com/Bash-it/bash-it.git
git.bash_it.path := $(HOME)/.bash_it

git.solarized_dircolors.url := https://github.com/seebi/dircolors-solarized
git.solarized_dircolors.path := $(HOME)/.local/share/dircolors-solarized

git.solarized_dircolors.url := https://github.com/seebi/dircolors-solarized
git.solarized_dircolors.path := $(HOME)/.local/share/dircolors-solarized

git.solarized_dircolors.url := https://github.com/seebi/dircolors-solarized
git.solarized_dircolors.path := $(HOME)/.dircolors-solarized

git.solarized_gnome_terminal.url := https://github.com/Anthony25/gnome-terminal-colors-solarized
git.solarized_gnome_terminal.path := $(HOME)/.gnome-terminal-solarized

git.dependencies := vimrc bash_it solarized_dircolors solarized_gnome_terminal

pip.dependencies := powerline-status

.PHONY = all install reinstall uninstall test _wrapped_stow _pre_stow _stow _post_stow _stow_ignore _install_args _reinstall_args _uninstall_args _test_args $(git.dependencies) $(pip.dependencies)

all:
	$(error You probably want to run 'make test' first)

_stow_ignore:
	$(foreach file,$(wildcard *),$(eval ARGS += --ignore=$(file)))

_stow: _stow_ignore
	@stow -t $(HOME) -v $(ARGS) .

$(git.dependencies):
	$(info git dependency: $@)
	$(eval path := ${git.${@}.path})
	$(eval url := ${git.${@}.url})
	if [ -d ${path}/ ]; then \
		cd ${path} && git pull --rebase && cd -; \
	else \
		git clone ${url} ${path}; \
	fi

$(pip.dependencies):
	$(info pip dependency: $@)
	if ! which pip3; then \
		pip install --user -U $@; \
	else \
		pip3 install --user -U $@; \
	fi

_pre_stow: $(git.dependencies) $(pip.dependencies)
	$(eval profile := $(subst ',,$(shell dconf read /org/gnome/terminal/legacy/profiles:/default)))
	cd ${git.solarized_gnome_terminal.path} && ./install.sh -p :$(profile) -s dark && cd -

_post_stow:
	@fc-cache -vf $(HOME)/.fonts/

_install_args:
	$(eval ARGS := -S)

_reinstall_args:
	$(eval ARGS := -R)

_uninstall_args:
	$(eval ARGS := -D)

_test_args:
	$(eval ARGS := -n -S)

_wrapped_stow: _pre_stow _stow _post_stow

install: _install_args _wrapped_stow

uninstall: _uninstall_args _wrapped_stow

reinstall: _reinstall_args _wrapped_stow

test: _test_args _stow
