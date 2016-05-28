.PHONY = all install uninstall test _stow _install_args _uninstall_args _test_args

all:
	@echo "You probably want to run 'make test' first."

_stow:
	# Find all files in top level directory that is not a dot file and add it to the list of files
	# that stow should ignore
	$(eval ARGS += $(shell find . -maxdepth 1 -type f -not -name ".*" -printf "--ignore=%P "))
	@stow -t $(HOME) -v $(ARGS) .

_install_args:
	$(eval ARGS := -S)

_uninstall_args:
	$(eval ARGS := -D)

_test_args:
	$(eval ARGS := -n -S)

install: _install_args _stow

uninstall: _uninstall_args _stow

test: _test_args _stow
