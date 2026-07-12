SRCDIR = .
GO_SRC = $(filter-out $(SRCDIR)/bin/dotfiles-update/submodules_paths.go, $(shell find $(SRCDIR) -type f -name '*.go'))

PREFIX ?= /usr/local
DESTDIR ?=

TARGET=$(SRCDIR)/dotfiles-update

bindir = $(PREFIX)/bin
datarootdir = $(PREFIX)/share
zshcompdir = $(datarootdir)/zsh/site-functions

INSTALL ?= install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

all: $(TARGET)

$(TARGET): $(GO_SRC) $(SRCDIR)/bin/dotfiles-update/paths_generated.go
	go build \
		-trimpath \
		-o $@ $^

$(SRCDIR)/bin/dotfiles-update/paths_generated.go: $(SRCDIR)/bin/dotfiles-update/submodules_paths.go
	go generate ./...

.PHONY: install
install: all
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL_PROGRAM) $(TARGET) $(DESTDIR)$(bindir)/dotfiles-update

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(bindir)/dotfiles-update
	rm -f $(DESTDIR)$(zshcompdir)/_dotfiles

.PHONY: clean
clean:
	rm -rf $(TARGET)
