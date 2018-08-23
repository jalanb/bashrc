#! /bin/bash

. ~/jab/src/bash/hub.sh



checkout () {
    [[ -d ~/jab ]] && return 1
    . ~/jab/src/bash/github.sh
    git clone $GITHUB/jalanb/jab ~/jab
}

main () {
    if checkout; then
        SCRIPT_DIR=$(realdir $BASH_SOURCE)
        bash $SCRIPT_DIR/link_dots.sh
    fi
}

main
