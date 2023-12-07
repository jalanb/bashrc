#! /bin/cat

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

pg () {
    ps -ef | grep -v grep | grep "$@"
}

pm () {
    local option_=
    if [[ $1 == "-q" ]]; then
        shift
        option_=-q
    fi
    p $option_ -m "$@"
}

pv () {
    unhash_python_handlers
    [[ $1 =~ -f ]] && rm -rf .venv
    [[ -d .venv ]] || python -m venv .venv
    . .venv/bin/activate
}

pvf () {
    pv -f 
}

# xxx

. ~/bash/python.sh
