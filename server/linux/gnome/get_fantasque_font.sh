#! /bin/bash

set -e

SCRATCH=/tmp/Downloads

set_up () {
	trap tear_down EXIT
	if [[ -d ${SCRATCH} ]]; then
		 rm -rf ${SCRATCH}/*
	else
		 mkdir ${SCRATCH}
	fi
	cd ${SCRATCH}
}

tear_down () {
	if [[ -d ${SCRATCH} ]]; then
		rm -rf ${SCRATCH}
	fi
}

main () {
	wget https://fontlibrary.org/assets/downloads/fantasque-sans-mono/db52617ba875d08cbd8e080ca3d9f756/fantasque-sans-mono.zip
    unzip fantasque-sans-mono.zip
    [[ -d "~/.fonts" ]] || mkdir ~/.fonts
    cp *.ttf ~/.fonts
}

set_up
main
tear_down
