#! /bin/cat


# _
# x

alias m=echo
# _x
# xx

md () {
    mkdir -p "$@" 2>/dev/null
}

ml () {
    memo -l 9
}

# xxx

<<<<<<< HEAD
quietly unalias man
quietly unalias batman
=======
unalias man >/dev/null 2>&1
unalias batman >/dev/null 2>&1
>>>>>>> 1d815e6f (Add keyboard)

man () {
    /opt/homebrew/bin/batman "$@"
}

mat () {
    mdcat "$@"
}

min () {
    local min_=~/jab/bash/bashrc_minimal
    vim $min_
    . $min_
}

mkd () {
    local __doc__='make a directory'
    local verbose_=1
    [[ $1 =~ -q ]] && shift && verbose_=
    if [[ -d "$1" ]]; then
        [[ $verbose_ ]] || return 0
        echo Directory existed "$@" >&2
        return 1
    fi
    [[ $verbose_ ]] && show_command mkdir -p "$1"
    md "$1"
    [[ -d "$1" ]]
}

main () {
    shift_dir "$@" && shift
    [[ -n $* ]] && cp ~/jab/src/python/main.py $1 || cp ~/jab/src/python/main.py $dir
}

mann () {
    man -P /usr/local/gnu/cat $1 | col -b
}

mine () {
    sudo chown -R $(id -un):$(id -gn) "$@"
}

mkcd () {
    local __doc__='make a directory and cd to it';
    mkd  -q "$1" || return 1
    cd "$1"
}

mkpy () {
    mkd "$1"
    touch "$1"/__init__.py
}

mkv3 () {
    mkvirtualenv -v --clear --system-site-packages --relocatable --python=$(which python3) $1
    virtualenv --python=$(which python3) /Users/jab/.virtualenvs/$1
}

mvim () {
    local _mvim=/Applications/MacVim.app/Contents/bin/mvim 
    ([[ "$@" ]] && $_mvim --remote-tab "$@" || $_mvim --remote) > ~/log/mvim.log 2> ~/log/mvim.err
}

