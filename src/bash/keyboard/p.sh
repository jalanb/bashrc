#! /bin/cat

# _x
# _xx
# _xxx
# _xxxx
# _xxxxx
# _xxxxxx

. ~/bash/python.sh

# x

p () {
    if [[ $1 == "-q" ]]; then
        shift
    else
        show_command python "$@"
    fi
    python "$@"
}

# xx

pm () {
    local option_=
    if [[ $1 == "-q" ]]; then
        shift
        option_=-q
    fi
    p $option_ -m "$@"
}

# xxx

# xxxx

