SUBDIRS = \
	libmsmcomm \
	msmcomm-specs \
	msmcommd

all:
	for i in $(SUBDIRS); do $(MAKE) -C $$i; done

install:
	for i in $(SUBDIRS); do sudo $(MAKE) install -C $$i; done

clean:
	for i in $(SUBDIRS); do $(MAKE) clean -C $$i; done

test:
	for i in $(SUBDIRS); do $(MAKE) test -C $$i; done

maintainer-clean:
	for i in $(SUBDIRS); do $(MAKE) maintainer-clean -C $$i; done

rebuild:
	pushd libmsmcomm; sudo make uninstall; ./autogen.sh; sudo make install; popd
	pushd msmcomm-specs; sudo make uinstall; ./autogen.sh; make clean; make; sudo make install; popd
	pushd msmcommd; sudo make uninstall; ./autogen.sh; sudo make install; popd
