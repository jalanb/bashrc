#! /bin/bash

set -e

SCRATCH=/tmp/Downloads
MINIMUM_VERSION=1.6.0

set_up () {
	trap tear_down EXIT
	if [[ -d "${SCRATCH}" ]]; then
		 rm -rf ${SCRATCH}/*
	else
		 mkdir ${SCRATCH}
	fi
	cd ${SCRATCH}
}

tear_down () {
	if [[ -d "${SCRATCH}" ]]; then
		rm -rf ${SCRATCH}
	fi
}

install_tree () {
	wget http://mama.indstate.edu/users/ice/tree/src/tree-${MINIMUM_VERSION}.tgz
	tar zxf tree-${MINIMUM_VERSION}.tgz 
	cd tree-${MINIMUM_VERSION}/
	make
	sudo make install
}

main () {
	if which tree >/dev/null 2>&1; then
		PROGRAM=$(which tree 2>/dev/null | tail -n 1)
		VERSION=$($PROGRAM --version | grep v[0-9]\. | sed -e "s/[^v]*v\([^ ]*\) .*/\1/")
		if [[ $VERSION < ${MINIMUM_VERSION} ]]; then
			sudo rm -rf $PROGRAM
			install_tree
		fi
		echo installed
	else
		install_tree
	fi
}

set_up
main
tear_down
