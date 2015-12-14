#! /bin/cat

BASH_DIR=$(dirname $BASH_SOURCE)

_assert_directory $BASH_DIR

source_here () {
    if [[ -n $HUB ]]
    then source_what $BASH_DIR/$1 optional
    elif [[ -f "$BASH_DIR/$1" ]]
    then source $BASH_DIR/$1
    fi
}

source_here src/bash/aliases.sh
source_here src/bash/functons.sh
