#! /bin/bash

. ~/jab/src/bash/hub.sh



checkout () {
    [[ -d ~/jab ]] && return 1
    . ~/jab/src/bash/github.sh
    git clone $GITHUB/jalanb/dotjab ~/jab
}

main () {
    if checkout; then
        SCRIPT_DIR=$(dirname $(readlink -f $BASH_SOURCE))
        bash $SCRIPT_DIR/link_dots.sh
    fi
}

main
