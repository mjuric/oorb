#!/bin/bash
#
#  Inspired by the solution by FX Coudert
#       https://gcc.gnu.org/ml/fortran/2007-11/msg00013.html
#  and further discussed at
#       http://lagrange.mechse.illinois.edu/f90_mod_deps/
#

$FC -cpp -I. -M "$@" | while read line; do
	IFS=":" read -r TARGETS DEPS <<< "$line"

	# FIXME: I assume gfortran will output .o first
	IFS=" " read -r OBJ MODULES <<< "$TARGETS"

	# FIXME: I assume gfortran will output the corresponding .f90 first
	IFS=" " read -r SRC <<< "$DEPS"

	# Separate dependency for the object file
	echo "$OBJ: $DEPS"
	echo $'\t''$(OBJBUILDCMD)'

	# Separate dependency for the module file(s)
	echo "$MODULES: $SRC $OBJ"
	echo $'\t''$(MODBUILDCMD)'
#	for MODULE in $MODULES; do
#		echo "$MODULE: $SRC $OBJ"
#		echo $'\t''$(MODBUILDCMD)'
#	done
done
