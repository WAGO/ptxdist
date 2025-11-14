version		:= $(shell . ./scripts/ptxdist_version.sh && echo $${PTXDIST_VERSION_FULL})
project		:= ptxdist-$(version)

prefix		:= /usr/local
exec_prefix	:= ${prefix}
abs_srcdir 	:= /usr/local/src/ptxdist-2024.12.0
libdir	 	:= ${exec_prefix}/lib
bindir	 	:= ${exec_prefix}/bin
instdir		:= $(libdir)/$(project)

SHELL		:= /usr/bin/bash
RST2MAN		:= /usr/bin/rst2man

export SHELL

all: kconfig environment
	@touch .done

kconfig:
	@echo "building conf and mconf ..."
	$(MAKE) -C "$(abs_srcdir)/scripts/kconfig"
	@echo "done."

environment:
	@echo -n "preparing PTXdist environment ..."
	@ln -sf /usr/bin/gawk "$(abs_srcdir)/bin/awk"
	@ln -sf /usr/bin/chmod "$(abs_srcdir)/bin/chmod"
	@ln -sf /usr/bin/chown "$(abs_srcdir)/bin/chown"
	@ln -sf /usr/bin/mv "$(abs_srcdir)/bin/mv"
	@ln -sf /usr/bin/cp "$(abs_srcdir)/bin/cp"
	@ln -sf /usr/bin/rm "$(abs_srcdir)/bin/rm"
	@ln -sf /usr/bin/ln "$(abs_srcdir)/bin/ln"
	@ln -sf /usr/bin/rmdir "$(abs_srcdir)/bin/rmdir"
	@ln -sf /usr/bin/md5sum "$(abs_srcdir)/bin/md5sum"
	@ln -sf /usr/bin/mkdir "$(abs_srcdir)/bin/mkdir"
	@ln -sf /usr/bin/mktemp "$(abs_srcdir)/bin/mktemp"
	@ln -sf /usr/bin/install "$(abs_srcdir)/bin/install"
	@ln -sf /usr/bin/stat "$(abs_srcdir)/bin/stat"
	@ln -sf /usr/bin/mknod "$(abs_srcdir)/bin/mknod"
	@ln -sf /usr/bin/tty "$(abs_srcdir)/bin/tty"
	@ln -sf /usr/bin/tar "$(abs_srcdir)/bin/tar"
	@ln -sf /usr/bin/find "$(abs_srcdir)/bin/find"
	@ln -sf /usr/bin/file "$(abs_srcdir)/bin/file"
	@ln -sf /usr/bin/cat "$(abs_srcdir)/bin/cat"
	@ln -sf /usr/bin/dirname "$(abs_srcdir)/bin/dirname"
	@ln -sf /usr/bin/readlink "$(abs_srcdir)/bin/readlink"
	@ln -sf /usr/bin/realpath "$(abs_srcdir)/bin/realpath"
	@ln -sf /usr/bin/sort "$(abs_srcdir)/bin/sort"
	@ln -sf /usr/bin/sed "$(abs_srcdir)/bin/sed"
	@ln -sf /usr/bin/xargs "$(abs_srcdir)/bin/xargs"
	@ln -sf /usr/bin/bash  "$(abs_srcdir)/bin/bash"
	@ln -sf /usr/sbin/sysctl "$(abs_srcdir)/bin/sysctl"
	@ln -sf /usr/bin/make "$(abs_srcdir)/bin/make"
	@if [ sphinx-build != "sphinx-build" ]; then \
		ln -sf sphinx-build "$(abs_srcdir)/bin/sphinx-build"; \
	fi
	@echo " done"

man: man/ptxdist.1.gz
man/ptxdist.1: doc/ptxdist.man doc/ref_parameter.rst
	@mkdir -pv man
	$(RST2MAN) $< $@

.INTERMEDIATE: man/ptxdist.1
man/ptxdist.1.gz: man/ptxdist.1
	gzip -f $<

clean:
	@rm -f .done
	@find "$(abs_srcdir)/bin" -type l -print0 | xargs -0 rm -f
	@$(MAKE) -C "$(abs_srcdir)/scripts/kconfig" clean

dirty-check:
	@case "$(version)" in \
		*-dirty) echo "refusing to install or package a dirty git tree!" ; exit 1 ;; \
	esac

install: all dirty-check
	@echo "installing PTXdist to $(DESTDIR)$(prefix)..."
	@rm -fr   "$(DESTDIR)$(instdir)"
	@mkdir -p "$(DESTDIR)$(instdir)"
	@tar -C "$(abs_srcdir)" -cf - \
		--exclude *~ \
		--exclude .*.sw* \
		--exclude .git \
		--exclude .gitignore \
		--exclude .pc \
		--exclude .svn \
		--exclude autom4te.cache \
		--exclude config.log \
		--exclude config.status \
		--exclude debian \
		--exclude state \
		. | \
		tar -o -C "$(DESTDIR)$(instdir)" -xvf -
	@if [ \! -e "$(DESTDIR)$(instdir)/.tarball-version" ]; then \
		echo -n "${version}" > "$(DESTDIR)$(instdir)/.tarball-version"; \
	fi
	@mkdir -p "$(DESTDIR)$(bindir)"
	@rm -f    "$(DESTDIR)$(bindir)/ptxdist"
	@ln -sf   "$(instdir)/bin/ptxdist" "$(DESTDIR)$(bindir)/ptxdist-$(version)"
	@ln -sf   "$(instdir)/bin/ptxdist-auto-version" "$(DESTDIR)$(bindir)/ptxdist"
	@if [ -d "$(DESTDIR)/etc/bash_completion.d" -a \
		-w "$(DESTDIR)/etc/bash_completion.d" ]; then \
		cp scripts/bash_completion "$(DESTDIR)/etc/bash_completion.d/ptxdist"; \
	fi

dist: dirty-check
	@rm -rf "$(project)"
	@git archive "$(project)" --prefix="$(project)"/ > "${project}.tar"
	tar xf "${project}.tar"
	echo -n "${version}" > "${project}/.tarball-version"
	cd "$(project)" && ./autogen.sh && ./configure && make man

	tar --owner=0 --group=0 -rf "${project}.tar" \
		"${project}/man/ptxdist.1.gz" \
		"${project}/configure" \
		"${project}/.tarball-version"
	bzip2 "${project}.tar"
	md5sum "${project}.tar.bz2" > "${project}.tar.bz2.md5"

distclean: clean
	rm -fr Makefile
	rm -fr build-stamp
	rm -fr config.log config.status autom4te.cache

maintainer-clean: distclean
	rm -f configure

release:
	@scripts/make_$@.sh

