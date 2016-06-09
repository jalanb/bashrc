#! /bin/bash

set -e

MINIMUM_VERSION=2.21

. ~/jab/jab/src/bash/scratch.sh

install_which () {
    clean_scratch
    cd "${SCRATCH}"

	wget http://ftp.gnu.org/gnu/which/which-${MINIMUM_VERSION}.tar.gz
	tar zxf which-${MINIMUM_VERSION}.tar.gz
	cd which-${MINIMUM_VERSION}/
	./configure --prefix=/usr
	make
	sudo make install
}

main () {
	if which which >/dev/null 2>&1; then
		PROGRAM=$(which which 2>/dev/null | tail -n 1)
		PROGRAM_VERSION=$($PROGRAM --version | grep v[0-9]\. | sed -e "s/.*v\([^,]*\),.*/\1/")
		if [[ $PROGRAM_VERSION < ${MINIMUM_VERSION} ]]; then
			sudo rm -rf $PROGRAM
			install_which
		fi
	else
		install_which
	fi
}

scratch_up
main
scratch_down
