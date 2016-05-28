.PHONY = all install uninstall _target test test-uninstall test-clean _test-target _test-structure _test-destructure _stow _unstow

TARGET :=

all:
	@echo "You probably want to run 'make test' first."

_test-target:
	$(eval TARGET := /tmp/stow-test)

_test-structure:
	-@[ -e $(TARGET) ] && rm -rf $(TARGET)
	-@find . -type d -not -ipath "*.git*" -printf "mkdir -p $(TARGET)/%P\n" | sh

_test-destructure:
	-@rm -rf $(TARGET)

_target:
	$(eval TARGET := $(HOME))

_stow:
	stow -t $(TARGET) --ignore=LICENSE --ignore=Makefile -S .

_unstow:
	stow -t $(TARGET) --ignore=LICENSE --ignore=Makefile -D .

install: _target _stow

uninstall: _target _unstow

test: _test-target _test-structure _stow

test-uninstall: _test-target _unstow

test-clean: _test-target _test-destructure
