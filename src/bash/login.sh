#! /bin/bash -x


if [[ $- =~ i ]]; then
    LOCAL=/usr/local
    [[ -d $LOCAL/gnu ]] && LOCALS="$LOCAL/gnu:$LOCAL/bin" || LOCALS="$LOCAL/bin"
    BINS=/usr/bin:/bin:/usr/sbin:/sbin
    HOMES=$HOME/bin:$HOME/.local
    export PATH=$LOCALS:$BINS:$HOMES
    [[ -d $LOCAL/go/bin ]] && PATH=$PATH:$LOCAL/go/bin

    source ~/jab/jab/__init__.sh
    export JAB

    echo JAB is $JAB

    export PS1="\$? [\u@\h:\$PWD]\n$ "

    vbb () {
        vim -p ~/.bashrc $HUB/jab/__init__.sh "$@" +/bash
        ls -l ~/.bashrc $HUB/jab/__init__.sh
    }

    export PS1="\$? [\u@\h:\$PWD]\n$ "

    # set -x
    j
    # set +x
    sp
    # clock # fucks with terminal, leave off
fi
