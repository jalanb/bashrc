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
    py "$@"
}

# xx

pd () {
    python -m doctest -o REPORT_ONLY_FIRST_FAILURE -o FAIL_FAST "$@"
}

pv () {
    python -m venv .venv
    unhash_python_handlers

}

# xxx

ppp () {
    pyth pai "$@"
}

# xxxx

pypu () {
    pyth pudb "$@"
}
