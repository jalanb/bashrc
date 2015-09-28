#! /bin/bash

JAB=${JAB:-$HOME/src/git/hub/dotjab}
JABS=https://github.com/jalanb/dotjab

checkout () {
	if [ -z $JAB ]; then
		echo please set \$JAB
		return 1
	fi
	[ -d $JAB ] && return 0
	if [ -z $JABS ]; then
		echo please set \$JABS
		return 1
	fi
	if [[ ! -d $JAB ]]; then
		git clone $JABS $JAB
	fi
}

main () {
	if checkout; then
        SCRIPT_DIR=$(dirname $(readlink -f $BASH_SOURCE))
	    bash $SCRIPT_DIR/link_dots.sh
	fi
}

main 
