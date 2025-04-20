#! /bin/bash


set_paths () {
    OLD_PATH=$PATH
    if [[ -d ~/jab ]]; then
        . ~/jab/src/bash/add_to_a_path.sh
        add_to_PATH $HOME/bin
        add_to_PATH ~/jab/bin
        add_to_PATH $HOME/.local
        add_to_PATH $HOME/.local/bin
        add_to_PATH ${VIRTUAL_ENV}/bin
        add_to_PATH /opt/homebrew/bin
        add_to_PATH /usr/local/gnu
        add_to_PATH /usr/local/bin
        add_to_PATH /bin
        add_to_PATH /usr/bin
#       add_to_PATH /usr/local/opt/python/libexec/bin
        add_to_PATH /usr/local/sbin
#       add_to_PATH $HOME/git/bin
#       add_to_PATH /opt/local/bin
        add_to_PATH /sbin
        add_to_PATH /usr/sbin
        add_to_PATH /usr/local/go/bin
#       add_to_PATH ~/.cargo/bin
        export PATH
    else
        echo ~/jab is not a directory
    fi
}

set_bucket () {
    local _src=~/src
    GIT_BUCKET=no_bucket; [[ -d $_src/git/bucket ]] && GIT_BUCKET=$( readlink -f $_src/git/bucket); export GIT_BUCKET
    HG_BUCKET=no_bucket; [[ -d $_src/hg/bucket ]] && HG_BUCKET=$( readlink -f $_src/hg/bucket); export HG_BUCKET
    BUCKET=no_bucket
    [[ -d $HG_BUCKET ]] && BUCKET=$HG_BUCKET
    [[ -d $GIT_BUCKET ]] && BUCKET=$GIT_BUCKET
    export BUCKET
}

show_dir_colors () {
    local _dircolors=$(quietly realpath $(which dircolors) )
    [[ $_dircolors ]] || return 1
    eval $($_dircolors ~/.dircolors | sed -e "s/setenv LS_COLORS /export LS_COLORS=/")
}

export_symbols () {
    export EX_OK=0
    export EX_BAD=1
    export FIGNORE=.pyc:.swp:~:.o
    export RE_IP="\<\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\>"
    export LOG_LINES_ON_CD_GIT_DIR=7
    export EDITOR=vim
    export LESS=MRSFX
}

_set_option () {
    shopt | grep -q $1 || return 1
    shopt -s $1
}

_source_jab_environ () {
   # echo x1
    set_paths
   # echo x2
    export_symbols
   # echo x3
    set_bucket
   # echo x4
    show_dir_colors
   # echo x5
    _set_option cdspell
   # echo x6
    _set_option autocd
   # echo x7
    set -o vi
   # echo x8
}

# echo before _source_jab_environ
_source_jab_environ
# echo after _source_jab_environ
