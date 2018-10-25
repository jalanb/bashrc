#! /bin/cat

. ~/bash/welcome.sh

Welcome_to $BASH_SOURCE

# x
# xx

pi () {
    local _version=; if [[ $1 == 2 ]]; then _version=2; shift; fi
    pith $_version install "$@"
}

pu () {
    local _version=; if [[ $1 == 2 ]]; then _version=2; shift; fi
    pith $_version uninstall "$@"
}

py () {
    local __doc__="""Run python, or a python script or directory"""
    local _path=
    if [[ -n "$@" ]]; then
        local all_args="$*"
        local _path=$(pyth ~/python/scripts.py -m "$@" 2> ~/bash/fd/2)
        if [[ "$all_args" =~ "--help" || "$all_args" =~ "-[hU]" || $? != 0 ]]; then
            _path=
        elif [[ -z $_path ]]; then
            _path=${1/%./.py}
            shift
        fi
        [[ -e $_path ]] || _path=
    fi
    pyth $_path $*
}

# xxx

pii () {
    local _ipython=$(which ipython)
    [[ -n $IPYTHON ]] && _ipython=$IPYTHON
    local _executable=$_ipython
    EXECUTABLE_PY=$_executable pi "$@"
}

pir () {
    pipr "$@"
}

piu () {
    pipu "$@"
}

# xxxx

pipp () {
    local __doc__="""pip install stuff, then update pip if needed"""
    pi "$@" 2>&1 | tee /tmp/pipp.log
    grep 'pip install --upgrade pip' /tmp/pipp.log && pipu
}

pipr () {
    pi -r requirements.txt
}

pipu () {
    pi --upgrade pip
}

pith () {
    set -x
    local __doc__="""Run a pythonic command [pip]"""
    local _executable=pip
    if [[ $1 == 2 ]]; then
        _executable=pip2
        shift
    fi
    [[ -n $EXECUTABLE_PY ]] && _executable=$EXECUTABLE_PY
    pypath $_executable "$@"
    set +x
}

pypd () {
    pypp develop "$@"
}

pypp () { 
    pyth setup.py "$@"
}

pyth () {
    local __doc__="""Run a python command"""
    local _python=python
    for _arg in "$@"; do
        [[ -f "$_arg" ]] || continue
        if [[ -d "$_arg" ]]; then
            echo Choose one: $(ls "$_arg")
        else
            head -n 1 "$_arg" | grep -q '#!.*python' || continue
            _python=$(head -n 1 "$_arg" | sed -e "s:.* ::")
            break
        fi
    done
    pypath $_python "$@"
}

# xxxxxx

pypath () {
    local __doc__="""Restrict PATH when running python commands"""
    local _path="$HOME/bin:/usr/local/bin:/usr/bin"
    local _venv_bin="${VIRTUAL_ENV:-xxx}"/bin
    [[ -d $_venv_bin ]] && _path="$_venv_bin:$_path"
    local _executable="$1"; shift
    [[ -n $EXECUTABLE_PY ]] && _executable=$EXECUTABLE_PY
    if [[ $_executable =~ python[2-9] ]]; then
        (PATH=$_path $_executable "$@")
    else
        # Other programs might not like the subshell so much
        PATH=$_path $_executable "$@"
    fi
}

# xxxxxxx

pylinum () {
    local string=$(pylint --help-msg $1 | hd1 | cut -d\: -f2 | cut -d\  -f1 | sed -e "s/^/# pylint: disable=/")
    [[ $string != "# pylint: disable=No" ]] && echo $string
}

Bye_from $BASH_SOURCE
