.PHONY = all install uninstall test _stow _install_args _uninstall_args _test_args

all:
	@echo "You probably want to run 'make test' first."

_stow:
	@stow -t $(HOME) -v --ignore=LICENSE --ignore=Makefile --ignore=README.md $(ARGS) .

_install_args:
	$(eval ARGS := -S)

_uninstall_args:
	$(eval ARGS := -D)

_test_args:
	$(eval ARGS := -n -S)

install: _install_args _stow

uninstall: _uninstall_args _stow

test: _test_args _stow
