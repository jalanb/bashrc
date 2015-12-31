#! /bin/bash

_source_jab_environ () {
    EX_OK=0
    EX_BAD=1

    if [[ ! -d $JAB ]]; then
        . $JAB/environ.d/jab.sh
    fi

    export COLUMNS

    export EXITSTATUS="$?"
    export FIGNORE=.pyc:.swp:~:.o

    #export DISPLAY=:0

    # correct minor spelling errors for cd
    shopt -s cdspell
    #
    # some interesting paths
    #
    GIT_BUCKET=no_bucket; [[ -d ~/src/git/bucket ]] && GIT_BUCKET=~/src/git/bucket; export GIT_BUCKET
    HG_BUCKET=no_bucket; [[ -d ~/src/hg/bucket ]] && HG_BUCKET=~/src/hg/bucket; export HG_BUCKET
    BUCKET=no_bucket
    if [[ -d $HG_BUCKET ]]; then
        BUCKET=$HG_BUCKET
    elif [[ -d $GIT_BUCKET ]]; then
        BUCKET=$GIT_BUCKET
    fi
    export BUCKET
    [[ -n $DIRCOLORS ]] && eval $($DIRCOLORS ~/.dir_colors | sed -e "s/setenv LS_COLORS /export LS_COLORS=/")
    OLD_PATH=$PATH
    if [[ -d $JAB ]]; then
        . $JAB/bin/add_to_a_path.sh
        PATH=
        add_to_a_path PATH $HOME/bin
        add_to_a_path PATH $JAB/bin
        add_to_a_path PATH $HOME/.local
        add_to_a_path PATH $HOME/.local/bin
        add_to_a_path PATH /usr/local/gnu
        add_to_a_path PATH /bin
        add_to_a_path PATH /usr/local/bin
        add_to_a_path PATH /usr/bin
        add_to_a_path PATH /usr/local/sbin
        add_to_a_path PATH $HOME/git/bin
        add_to_a_path PATH /opt/local/bin
        add_to_a_path PATH /sbin
        add_to_a_path PATH /usr/sbin
        add_to_a_path PATH /usr/local/go/bin
        export PATH
    else
        echo JAB is not a directory
    fi
    show_path
    export PS1

    #
    # Path dependencies
    #

    if [[ -x /usr/local/bin/which ]]; then
        export WHICH=/usr/local/bin/which
    else
        export WHICH=/usr/bin/which
    fi
    export EDITOR=vim
    export EMAIL="dotjab@al-got-rhythm.net"

    if [[ -d $JAB ]]; then
        source_path $JAB/environ.d/colour.sh
    fi

    RE_IP="\<\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\>"
    export LOG_LINES_ON_CD_GIT_DIR=7

    set -o vi
}

_source_jab_environ
