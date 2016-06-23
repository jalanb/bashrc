#! /bin/cat

# _x
# _xx
# _xxx

_pdb () {
    _python pdb "$@"
}

# _xxxx

_pudb () {
    _python pudb "$@"
}

# _xxxxx
# _xxxxxx

_python () {
    _pyth "$@"
    (cd $(dirname $(readlink -f $BASH_SOURCE))
    local _executable="$1"; shift
    local _script="$2"; shift
    if [[ $_executable == python ]]; then
        $(python $_script "$@")
    else
        # Other prgrams might not like the subshell so much
        $_executable $_script "$@"
    fi
    )
}

# x

p () {
    _python python "$@"
}

# xx

pp () {
    _python pudb "$@"
}

# xxx

ppp () {
    _python pym "$@"
}
