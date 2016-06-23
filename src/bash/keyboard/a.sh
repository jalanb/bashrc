#! /bin/cat

# _x
# _xx
# _xxx

_ack () {
    python -c "print '\n\033[0;36m%s\033[0m\n' % ('#' * $(tput cols))"
    # /usr/local/bin/ack "$@"
    # return
    local _sought="$@"; [[ $* == v ]] && _sought=$(pbpaste)
    cmd="$(python ~/hub/ack2vim/ack_vack.py $_sought)"
    (cd ~/hub/ack2vim
    if [[ $* == v ]]; then
        _ack_python ack_vack.py $(pbpaste)
    elif [[ $1 == PASTE ]]; then
        shift
        _ack_python ack_vack.py $(pbpaste) "$@"
    else
        _ack_python ack_vack.py "$@"
    fi)
}
# _xxxx
# _xxxxx
# _xxxxxx
# _xxxxxxx
# _xxxxxxxx
# _xxxxxxxxx
# _xxxxxxxxxx

_ack_python () {
    (cd $(dirname $(readlink -f $BASH_SOURCE))
    local _script=$1; shift
    if [[ $PYTHON_DEBUGGING == -U|| $DEBUGGING == www ]]; then
        python $_script $PYTHON_DEBUGGING "$@"
    else
        $(python $_script "$@")
    fi
    )
}

# x

a () {
    _ack "$@"
}

# xx

aa () {
    _ack "$@" -v
}

# xxx

aaa () {
    _ack --nojunk "$@"
}
