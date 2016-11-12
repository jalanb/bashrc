#! /bin/cat

# _x
# _xx
# _xxx
# _xxxx
# _xxxxx
# _xxxxxx

_python () {
    local _executable="$1"; shift
    local _script="$1"; shift
    if [[ $_executable == python ]]; then
        $(python $_script "$@")
    else
        # Other prgrams might not like the subshell so much
        $_executable $_script "$@"
    fi
}

# x

p () {
    _python python "$@"
}

# xx

pp () {
    _python pudb "$@"
}

pi () {
    pip install "$@"
}

pu () {
    pip uninstall "$@"
}

# xxx

pir () {
    pip install -r requirements.txt 2>&1 | grep 'pip install --upgrade pip' && pip install --upgrade pip
}

piu () {
    pip install --upgrade "$@"
}

ppp () {
    _python pym "$@"
}
pir () 
{ 
    pip install -r requirements.txt 2>&1 | grep 'pip install --upgrade pip' && pip install --upgrade pip
}
pir () 
{ 
    pip install -r requirements.txt 2>&1 | grep 'pip install --upgrade pip' && pip install --upgrade pip
}
