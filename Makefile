git.vimrc.url := https://github.com/amix/vimrc.git
git.vimrc.path := $(HOME)/.vim_runtime

git.bash_it.url := https://github.com/Bash-it/bash-it.git
git.bash_it.path := $(HOME)/.bash_it

git.dependencies := vimrc bash_it

pip.dependencies := powerline-status

.PHONY = all install reinstall uninstall test _pre_stow _stow _post_stow _stow_ignore _install_args _reinstall_args _uninstall_args _test_args $(git.dependencies) $(pip.dependencies)

all:
	$(error You probably want to run 'make test' first)

_stow_ignore:
	$(foreach file,$(wildcard *),$(eval ARGS += --ignore=$(file)))

_stow: _stow_ignore
	@stow -t $(HOME) -v $(ARGS) .

$(git.dependencies):
	$(info git dependency: $@)
	$(eval url := ${git.${@}.url})
	$(eval path := ${git.${@}.path})
ifneq ($(wildcard ${path}/.*),)
	cd ${path} && git pull --rebase && cd -
else
	git clone ${url} ${path}
endif

$(pip.dependencies):
	$(info  pip dependency; $@)
	pip3 install --user -U $@

_pre_stow: $(git.dependencies) $(pip.dependencies)

_post_stow:
	fc-cache -vf $(HOME)/.fonts/

_install_args:
	$(eval ARGS := -S)

_reinstall_args:
	$(eval ARGS := -R)

_uninstall_args:
	$(eval ARGS := -D)

_test_args:
	$(eval ARGS := -n -S)

install: _install_args _pre_stow _stow _post_stow

uninstall: _uninstall_args _pre_stow _stow _post_stow

reinstall: _reinstall_args _pre_stow _stow _post_stow

test: _test_args _stow
