#! /bin/cat

. ~/bash/welcome.sh

Welcome_to $BASH_SOURCE

# x
# xx

pi () {
    ppip install "$@"
}

pu () {
    ppip uninstall "$@"
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

ppip () {
    python -m pip "$@"
}

pipd () {
    local __doc__="""pip install a directory for development"
    _pipy develop "$@"
}

_pipy_vim () {
    local _dir="$1"; shift
    local _vim="$1"; shift
    (
        cd $_dir
        local _setups=
        [[ -f setup.py ]] && _setups=setup.py
        [[ -f requirements.txt ]] && _setups="$_setups requirements.txt"
        [[ -d requirements ]] && _setups="$_setups requirements"
        [[ $_vim ]] && $_vim $_setups
    )
}

_pipy_setup () {
    local _dir="$1"; shift
    local _force="$@"; shift
    (
        cd $_dir
        local _dev=
        if [[ -f requirements.txt || -d requirements ]]; then
            (
                [[ -d requirements ]] && cd requirements
                [[ $1 == "-d" && -f development.txt ]] && pi $_force -r development.txt
                pi $_force -r requirements.txt
            )
        fi
        local _script_dir=
        local _mode=--editable
        local _which_python=$(which python)
        if [[ $_which_python =~ ^/usr/local ]]; then
            _script_dir="--script-dir=/usr/local/bin"
            _mode=
        elif [[ ! $_which_python =~ ^$HOME ]]; then
            show_error Cannot pipy $(which python), which is outside $HOME
            return 1
        fi
        [[ -f setup.py ]] || echo "$_dir/setup.py is not a file" >&2
        [[ -f setup.py ]] || return 1
        echo pip install $_force $_mode $_script_dir $_dir
        set -x
        pip install $_force $_mode $_script_dir $_dir
        set +x
    ) 2>&1 | grep -v already.satisfied  | grep -e ^Installed -e '^Installing .* script' -e pip.install | grep -e 'g [a-z_]+\>' -e '/\<[a-z0-9.-]*[^/]+$'
}

pipy () {
    local __doc__="""Install a python project dir

    [path] : path to the project (defaults to \$PWD)
    -v : edit the setup files first
    -V : only edit the setup files
    -f : force 
    -u : upgrade
    """
    piup >/dev/null 2>&1
    local _dir=$PWD
    [[ -d "$1" ]] && _dir="$1" && shift
    local _vim=
    [[ $1 =~ -[vV] ]] && _vim="vim -p"
    local _vvim=
    [[ $1 == -V ]] && _vvim=1
    [[ $_vim ]] && shift
    local _force=
    [[ $1 =~ -u*fu* ]] && _force=--force-reinstall
    [[ $1 =~ -f*uf* ]] && _force="$_force --upgrade"
    [[ $_force ]] && shift
    [[ ! -d $_dir && -d "$1" ]] && _dir="$1" && shift
    _pipy_vim $_dir $_vim
    [[ $_vvim ]] && return 0
    _pipy_setup $_dir $_force
}

pirr_ () {
    [[ -d requirements ]] && pi -r requirements/development.txt
    [[ -f requirements.txt ]] && pi -r requirements.txt
}

pirr () {
    local _in_dir=
    [[ -d "$1" ]] && _in_dir="ind $1"
    $_in_dir pirr_
}

piup () {
    pi --upgrade pip
}

vipy () {
    pipy -V "$@"
}

# _xxxx

_pipy () {
    piup >/dev/null 2>&1
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
            local _pip=ppip
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
pythoni () {
    python -c "import $1; print($1.__file__)"
}

pythonv () {
    python -V "$@"
}

# xxxxxxx

pythonvv () {
    python -m .venv
    sed -i -e /activate/d .cd 
    echo "activate_python_here" >> .cd
}

pylinum () {
    local string=$(pylint --help-msg $1 | hd1 | cut -d\: -f2 | cut -d\  -f1 | sed -e "s/^/# pylint: disable=/")
    [[ $string != "# pylint: disable=No" ]] && echo $string
}

# xxxxxxx*

install_develop () {
    [[ -f setup.py ]] || echo "setup.py is not a file" >&2
    [[ -f setup.py ]] || return 1
    local _pip=ppip
    [[ $1 =~ 2 ]] && _pip=pip2
    [[ -f requirements.txt ]] && $_pip install -r requirements.txt
    $_pip install -e .
}

Bye_from $BASH_SOURCE
