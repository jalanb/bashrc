#! /bin/cat

. ~/bash/paths.sh
. ~/bash/welcome.sh


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
    show_run_command python -m pip "$@"
}

pipd () {
    _pip_install_develop "$@"
}

pipv () {
    local _dir=$PWD _setups=
    [[ -d "$1" ]] && _dir="$1" && shift
    [[ -f $_dir/setup.py ]] && _setups=$_dir/setup.py
    [[ -f $_dir/setup.cfg ]] && _setups=$_dir/setup.cfg
    [[ -f $_dir/requirements.txt ]] && _setups="$_setups $_dir/requirements.txt"
    [[ -d $_dir/requirements ]] && _setups="$_setups $_dir/requirements/*"
    vim -p $_setups "$@"
}

_pipy_setup () {
    local _dir="$1" _force="$2"; shift 2
    local _dev=
    _install_requirements_there $_dir "$_force"
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
    [[ -f $_dir/setup.py ]] || echo "$_dir/setup.py is not a file" >&2
    [[ -f $_dir/setup.py ]] || return 1
    set -x
    pip install $_force $_mode $_script_dir $_dir
    set +x
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
    local _force=
    [[ $1 =~ -u*fu* ]] && _force=--force-reinstall
    [[ $1 =~ -f*uf* ]] && _force="$_force --upgrade"
    [[ $_force ]] && shift
    [[ -d "$1" ]] && _dir="$1" && shift
    _pipy_setup $_dir $_force 2>&1 | grep -v already.satisfied  | grep -e ^Installed -e '^Installing .* script' -e pip.install | grep -e 'g [a-z_]+\>' -e '/\<[a-z0-9.-]*[^/]+$'
}

pirr () {
    _install_requirements_there "$@"
}

piup () {
    pi --upgrade pip
}

vipy () {
    pipy -V "$@"
}

# _xxxx

_install_requirements_here () {
    local _force=$1 _name=
    if [[ -d requirements ]]; then
        (cd requirements
            for _name in development testing requirements; do
                if [[ -f ${_name}.txt ]]; then
                    pi $_force -r ${_name}.txt
                    return
                fi
            done
        )
    fi
    [[ -f requirements.txt ]] && pi $_force -r requirements.txt
}

_install_requirements_there () {
    local _dir="$1"; shift
    same_dir "$_dir" . && _install_requirements_here "$@" || (cd $_dir; _install_requirements_here "$@")
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
    [[ -f requirements.txt ]] && $_pip install -r requirements.txt
    $_pip install -e .
}

_pip_install_develop () {
    local __doc__="""pip install a directory for development"
    piup >/dev/null 2>&1
    local _install=develop; shift
    local _dir=.
    if [[ -d "$1" ]]; then
        _dir="$1"
        shift
        local _force=
        [[ $1 == "-f" ]] && _force=--force-reinstall
        _install_requirements_there $_dir $_force
        if [[ -f setup.py ]]; then
            [[ $_force ]] && _force=--upgrade
            ppip install $_force -e .
        fi
    fi 2>&1 | grep -v already.satisfied
}

