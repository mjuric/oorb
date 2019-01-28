#!/bin/bash
#
# (Re)Generate version.pyf with the version given on the command line
# Avoid regenerating if the version has not changed.
#

VERSION="$1"

cat <<-EOF | sed 's|\$VERSION|'"$VERSION"'|g' > version.pyf.tmp
	!    -*- f90 -*-
	python module pyoorb
	  interface
	    usercode '''
	#if PY_VERSION_HEX >= 0x03000000
	  s = PyUnicode_FromString(
	#else
	  s = PyString_FromString(
	#endif
	  "$VERSION"
	);
	  PyDict_SetItemString(d, "__version__", s);
	    '''
	  end interface
	end python module
EOF

cmp -s version.pyf.tmp version.pyf && rm -f version.pyf.tmp || mv version.pyf.tmp version.pyf
