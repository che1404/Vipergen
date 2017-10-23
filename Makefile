TOOL_NAME = vipergen
VERSION = 0.1.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(TOOL_NAME)
BUILD_PATH = .build/release/$(TOOL_NAME)
CURRENT_PATH = $(PWD)
TAR_FILENAME = $(TOOL_NAME)-$(VERSION).tar.gz
TEMPLATES_FOLDER_NAME = vipergen_templates

install: build
	mkdir -p $(PREFIX)/bin
	cp -f $(BUILD_PATH) $(INSTALL_PATH)
	mkdir -p $(PREFIX)/bin/$(TEMPLATES_FOLDER_NAME)
	cp -r -f $(TEMPLATES_FOLDER_NAME)/* $(PREFIX)/bin/$(TEMPLATES_FOLDER_NAME)

build:
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

uninstall:
	rm -f $(INSTALL_PATH)
	rm -r -f $(PREFIX)/bin/$(TEMPLATES_FOLDER_NAME)
