#! /bin/bash

. ~/jab/jab/src/bash/hub.sh
JAB=${HUB/jab}

. ~/jab/jab/src/bash/github.sh
DOTJAB=$GITHUB/jalanb/dotjab

checkout () {
    if [[ -z $JAB ]]; then
        echo please set \$JAB
        return 1
    fi
    [[ -d "$JAB" ]] && return 0
    if [[ -z $DOTJAB ]]; then
        echo please set \$DOTJAB
        return 1
    fi
    if [[ ! -d "$JAB" ]]; then
        git clone $DOTJAB $JAB
    fi
}

main () {
    if checkout; then
        SCRIPT_DIR=$(dirname $(readlink -f $BASH_SOURCE))
        bash $SCRIPT_DIR/link_dots.sh
    fi
}

main
