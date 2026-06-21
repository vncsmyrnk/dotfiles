SRCDIR = .

PREFIX ?= /usr/local
DESTDIR ?=

TARGET=$(SRCDIR)/dotfiles

bindir = $(PREFIX)/bin
datarootdir = $(PREFIX)/share
zshcompdir = $(datarootdir)/zsh/site-functions

INSTALL ?= install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

all: $(TARGET)

$(TARGET): $(SRCDIR)/dotfiles.sh
	sed 's|^INSTALL_DIR_PLACEHOLDER=""|INSTALL_DIR_PLACEHOLDER="$(abspath $(SRCDIR))"|' $< > $@

.PHONY: install
install: all
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -d $(DESTDIR)$(zshcompdir)
	$(INSTALL_PROGRAM) $(TARGET) $(DESTDIR)$(bindir)/dotfiles
	$(INSTALL_DATA) $(SRCDIR)/completions.zsh $(DESTDIR)$(zshcompdir)/_dotfiles

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(bindir)/dotfiles
	rm -f $(DESTDIR)$(zshcompdir)/_dotfiles

.PHONY: clean
clean:
	rm -rf $(TARGET)

.PHONY: check
check:
	shellcheck $(SRCDIR)/dotfiles.sh

.PHONY: installcheck
installcheck:
	@echo "Verifying installation in $(DESTDIR)$(PREFIX)..."

	@test -x $(DESTDIR)$(bindir)/dotfiles || (echo "Error: binary not found or not executable" && exit 1)
	$(DESTDIR)$(bindir)/dotfiles --help > /dev/null

	@echo "Installation verification passed successfully!"
