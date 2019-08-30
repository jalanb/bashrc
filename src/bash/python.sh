#! /bin/cat

. ~/bash/welcome.sh

Welcome_to $BASH_SOURCE

# x
# xx

pi () {
    pip install "$@"
}

pu () {
    pip uninstall "$@"
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
    pypath $_ipython "$@"
}

# xxxx

pipd () {
    local __doc__="""pip install a directory for development"
    _pipy develop "$@"
}

pipy () {
    pipu >/dev/null 2>&1
    local _dir=.
    [[ -d "$1" ]] && _dir="$1"
    [[ -d "$2" ]] && _dir="$2"
    local _force=
    [[ $1 == "-f" ]] && _force=--force-reinstall
    [[ $1 == "-F" ]] && _force="--upgrade"
    [[ $_force ]] && shift
    (
        cd $_dir
        if [[ -f requirements.txt ]]; then
            [[ $1 == "-d" && -f development.txt ]] && pip install $_force -r development.txt
            [[ -f requirements.txt ]] && pip install $_force -r requirements.txt
        fi
        [[ $_force ]] && _force="--upgrade"
        local _script_dir=
        local _command=develop
        if [[ $(which python) =~ ^/usr/local ]]; then
            _script_dir="--script-dir=/usr/local/bin"
            _command=install
        elif [[ $(which python) =~ ^/ ]]; then
            show_error Cannot pipy $(which python)
            return 1
        fi
        [[ -f setup.py ]] || echo "$_dir/setup.py is not a file" >&2
        [[ -f setup.py ]] || return 1
        set -x
        [[ -f setup.py ]] && python setup.py $_command $_force $_script_dir  2>&1
        set +x
    ) 2>&1 | grep -v already.satisfied  | grep -e ^Installed -e '^Installing .* script' | g -e 'g [a-z_]+\>' -e '/\<[a-z0-9.-]*[^/]+$' -e setup.py
}

pipu () {
    pi --upgrade pip
}

# _xxxx

_pipy () {
    pipu >/dev/null 2>&1
    local _install=$1; shift
    local _dir=.
    if [[ -d "$1" ]]; then
        _dir="$1"
        shift
        (
            cd $_dir
            local _edit=
            [[ $_install == "develop" ]] && _edit=-e
            local _force=
            [[ $1 == "-f" ]] && _force=--force-reinstall
            local _pip=pip
            [[ -f requirements.txt ]] && $_pip install $_force -r requirements.txt
            if [[ -f setup.py ]]; then
                if [[ $_force ]]; then
                    _force=--force
                    [[ $_install == "develop" ]] && _force=--upgrade
                fi
                local _python=python
                $_python setup.py $_force $_install $_edit .
            fi
        ) 2>&1 | grep -v already.satisfied
    fi
}
# xxxxxxx

pylinum () {
    local string=$(pylint --help-msg $1 | hd1 | cut -d\: -f2 | cut -d\  -f1 | sed -e "s/^/# pylint: disable=/")
    [[ $string != "# pylint: disable=No" ]] && echo $string
}

install_develop () {
    [[ -f setup.py ]] || echo "setup.py is not a file" >&2
    [[ -f setup.py ]] || return 1
    local _pip=pip
    [[ $1 =~ 2 ]] && _pip=pip2
    [[ -f requirements.txt ]] && $_pip install -r requirements.txt
    $_pip install -e .
}

Bye_from $BASH_SOURCE
