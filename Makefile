.PHONY = all install uninstall test _pre_stow _stow _post_stow  _install_args _uninstall_args _test_args

all:
	@echo "You probably want to run 'make test' first."

_stow:
	$(eval ARGS += $(shell find . -maxdepth 1 -type f -not -name ".*" -printf "--ignore=%P "))
	@stow -t $(HOME) -v $(ARGS) .

_pre_stow:
ifneq ($(wildcard $(HOME)/.bash_it/.*),)
	cd $(HOME)/.bash_it && git pull --rebase && cd -
else
	git clone https://github.com/Bash-it/bash-it.git $(HOME)/.bash_it
endif

ifneq ($(wildcard $(HOME)/.vim_runtime/.*),)
	cd $(HOME)/.vim_runtime && git pull --rebase && cd - 
else
	git clone https://github.com/amix/vimrc.git $(HOME)/.vim_runtime
endif

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
