#! /bin/bash

set -e

SCRATCH=/tmp/Downloads

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

get_pandemic () {
	wget --no-check-certificate https://github.com/jwcxz/vim-pandemic/archive/master.zip
	mv master.zip vim-pandemic-master.zip
	unzip vim-pandemic-master.zip
	rm -rf vim-pandemic-master.zip
}

make_pandemic () {
	cd vim-pandemic-master
	sed -i -e "s|vim/bundle.remote|vim/bundle|" bin/pandemic
	python2.7 setup.py install --prefix=$HOME
	PANDEMIC=bin/pandemic
	if [[ ! -f "$PANDEMIC" ]]; then
		echo Installation of $PANDEMIC failed >&2
		exit 1
	else
		sed -i -e "s|vim/bundle.remote|vim/bundle|" $PANDEMIC
	fi
}

update_pandemic () {
	$PANDEMIC list | sed -e "s/:.*//" | xargs env GIT_SSL_NO_VERIFY=true $PANDEMIC update
}

main () {
	get_pandemic
	make_pandemic
	update_pandemic
}

set_up
main
tear_down
