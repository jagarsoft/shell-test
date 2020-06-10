# http://nuclear.mutantstargoat.com/articles/make/#writing-install-uninstall-rules
PREFIX = /usr/local

.PHONY: install
install: src/shelltest.sh
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp $< $(DESTDIR)$(PREFIX)/bin/shelltest

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/shelltest