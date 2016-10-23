protocol ?= https

git.vimrc.url := $(protocol)://github.com/amix/vimrc.git
git.vimrc.path := $(HOME)/.vim_runtime

git.vim_better_whitespace.url := $(protocol)://github.com/ntpeters/vim-better-whitespace.git
git.vim_better_whitespace.path := $(git.vimrc.path)/sources_non_forked/vim-better-whitespace

git.bash_it.url := $(protocol)://github.com/Bash-it/bash-it.git
git.bash_it.path := $(HOME)/.bash_it

git.gimpps.url := $(protocol)://github.com/doctormo/GimpPs
git.gimpps.path := $(HOME)/.gimp-2.8

git.dependencies := vimrc vim_better_whitespace bash_it gimpps
pip.dependencies := powerline-status

bashit.enable := apt alias-completion curl dirs docker general git less-pretty-cat ssh virtualenv

.PHONY = all install reinstall uninstall test _wrapped_stow _pre_stow _stow _post_stow _stow_ignore _install_args _reinstall_args _uninstall_args _test_args $(git.dependencies) $(pip.dependencies) $(bashit.enable)

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
		cd ${path} && git stash > /dev/null 2>&1; git pull --rebase && git stash pop > /dev/null 2>&1; cd - >/dev/null 2>&1; \
	else \
		git clone ${url} ${path}; \
	fi

$(pip.dependencies):
	$(info pip dependency: $@)
	@if ! which pip3 > /dev/null 2>&1; then \
		pip install --user -U $@; \
	else \
		pip3 install --user -U $@; \
	fi

$(bashit.enable):
	@if [ -e ~/.bash_it/plugins/available/$@.plugin.bash ]; then \
		echo "enable bash-it plugin: $@"; \
		mkdir -p ~/.bash_it/plugins/enabled; \
		cd ~/.bash_it/plugins/enabled && \
		ln -f -s ../available/$@.plugin.bash || true && \
		cd - > /dev/null 2>&1; \
	fi

	@if [ -e ~/.bash_it/aliases/available/$@.aliases.bash ]; then \
		echo "enable bash-it alias : $@"; \
		mkdir -p ~/.bash_it/aliases/enabled; \
		cd ~/.bash_it/aliases/enabled && \
		ln -f -s ../available/$@.aliases.bash || true && \
		cd - > /dev/null 2>&1; \
	fi

_pre_stow: $(git.dependencies) $(pip.dependencies)

_post_stow: $(bashit.enable)
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
