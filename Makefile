############################################################################
#
# OpenOrb Build System
#
# This file its companion in build/Makefile define build targets for all
# command line executables (see PROGRAMS in ../make.config), liboorb
# libraries, and the pyoorb Python module.  Default rule (named all) builds
# all of them.
#
# Example usage (with -j4 to take advantage of multi-threaded builds):
#
#	$ make -j4
#
# or (for example) to just build oorb, run:
#
#	$ make -j4 oorb
#
# To install the code, run:
#
#	$ make install
#
# FOR DEVELOPERS:
#
# * The build is executed in the build/ subdirectory.  All intermediate
#   files end up there (.o, .mod, etc.)
#
# * To add new programs, add the .f90 file into main/ and list it in
#   PROGRAMS variable in make.config. Then rerun `make depends`.
#
# * To add new files, add them to modules/ or classes/ and list the file
#   name in the apropriate variable in make.config.  Then rerun `make
#   depends`
#
# * If there's a change in depdendency of any FORTRAN file (e.g., you've
#   USEd another module), run:
#
#       $ make depends
#
#   to rebuild the dependencies file (build/make.depends).  You must be
#   using gfortran for this rebuild to work.
#
# Author: mjuric@astro.washington.edu (http://github.com/mjuric)
#
#############################################################################


include make.config
include Makefile.include

PREFIX ?= /opt/oorb

.PHONY: all
all:
	@ $(MAKE) -C build $@

# Forward everything we don't recognize to the makefile in build/
%:
	$(MAKE) -C build $@

.PHONY: clean
clean:
	$(MAKE) -C build clean
	$(MAKE) -C doc clean

# Make tar-ball:
.PHONY: tar
tar: clean
	cd .. && tar czvf $(PROJNAME)_v$(VERSION).tar.gz --exclude $(PROJNAME)/.git $(PROJNAME)

.PHONY: install
install:
	@echo "Installing into $(PREFIX)"
	mkdir -p $(PREFIX)/bin $(PREFIX)/etc $(PREFIX)/lib $(PREFIX)/data $(PREFIX)/python
	cp -a main/oorb $(PREFIX)/bin/
	cp -a main/oorb.conf $(PREFIX)/etc/
	cp -a lib/liboorb* $(PREFIX)/lib/
	cp -a data/* $(PREFIX)/data/ && rm -rf "$(PREFIX)/data/JPL_ephemeris"
	cp -a python/pyoorb*.so $(PREFIX)/python/

.PHONY: test
test: all
	@hash pytest 2>/dev/null || { echo "You need to have pytest installed to run the tests." && exit -1; }
	PYTHONPATH="lib:$$PYTHONPATH" DYLD_LIBRARY_PATH="lib:$$DYLD_LIBRARY_PATH" LD_LIBRARY_PATH="lib:$$LD_LIBRARY_PATH" pytest tests
	@ ##PYTHONPATH=".python:$$PYTHONPATH" DYLD_LIBRARY_PATH="lib:$$DYLD_LIBRARY_PATH" LD_LIBRARY_PATH="lib:$$LD_LIBRARY_PATH" pytest tests
	@ # integration test
	@ ## OORB_DATA=data DYLD_LIBRARY_PATH="lib" python python/test.py
