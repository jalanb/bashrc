#! /bin/bash

set -e

SCRATCH=/tmp/scratch
[[ -d $SCRATCH_DIR ]] && SCRATCH=$SCRATCH_DIR

scratch_up () {
    trap scratch_down EXIT
    if [[ -d "${SCRATCH}" ]]; then
         rm -rf ${SCRATCH}/*
    else
         mkdir ${SCRATCH}
    fi
    cd ${SCRATCH}
}

scratch_down () {
    if [[ -z $KEEP_SCRATCH ]]; then
        if [[ -d "${SCRATCH}" ]]; then
            rm -rf ${SCRATCH}
        fi
    fi
}

clean_scratch () {
    if [[ -z $KEEP_SCRATCH ]]; then
        echo "KEEP_SCRATCH == $KEEP_SCRATCH" >&2
        return 1
    fi
    [[ -d "${SCRATCH}" ]] && rm -rf ${SCRATCH}
    mkdir ${SCRATCH}
}

scratch_copy () {
    echo "" > $SCRATCH
    /usr/local/bin/vim $SCRATCH
    /bin/cat $SCRATCH | /usr/bin/pbcopy
}

scratch_paste () {
    SCRATCH=$HOME/tmp/fred
    /usr/bin/pbpaste > $SCRATCH
    /usr/local/bin/vim $SCRATCH
}

