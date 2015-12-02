#! /bin/bash

set -e

main () {
	wget https://fontlibrary.org/assets/downloads/fantasque-sans-mono/db52617ba875d08cbd8e080ca3d9f756/fantasque-sans-mono.zip
    unzip fantasque-sans-mono.zip
    [[ -d "~/.fonts" ]] || mkdir ~/.fonts
    cp *.ttf ~/.fonts
}

require $JAB/src/bash/scratch.sh

scratch_up
main
scratch_down
