git.url.vimrc := https://github.com/amix/vimrc.git
git.url.bash_it := https://github.com/Bash-it/bash-it.git

git.path.vimrc := $(HOME)/.vim_runtime
git.path.bash_it := $(HOME)/.bash_it

git.dependencies := vimrc bash_it

.PHONY = all install uninstall test _pre_stow _stow _post_stow _stow_ignore _install_args _uninstall_args _test_args $(git.dependencies)

all:
	@echo "You probably want to run 'make test' first."

_stow_ignore:
	$(foreach file,$(wildcard *),$(eval ARGS += --ignore=$(file)))

_stow: _stow_ignore
	@stow -t $(HOME) -v $(ARGS) .

$(git.dependencies):
	@echo "git dependency: $@"
	$(eval url := ${git.url.${@}})
	$(eval path := ${git.path.${@}})
ifneq ($(wildcard ${path}/.*),)
	cd ${path} && git pull --rebase && cd -
else
	git clone ${url} ${path}
endif

_pre_stow: $(git.dependencies)

_post_stow:
	fc-cache -vf $(HOME)/.fonts/

_install_args:
	$(eval ARGS := -S)

_uninstall_args:
	$(eval ARGS := -D)

_test_args:
	$(eval ARGS := -n -S)

install: _install_args _pre_stow _stow _post_stow

uninstall: _uninstall_args _pre_stow _stow _post_stow

test: _test_args _stow
