#! /bin/cat

type same_dir >/dev/null 2>&1 || . ~/bash/paths.sh

# x
# xx

pi () {
    [[ $1 == install ]] && shift
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
        local _path=$(pyth ~/python/scripts.py -m "$@" 2> ~/fd2)
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

pid () {
    pip_install_develop "$@"
}

pig () {
    pi --upgrade "$@"
}

pii () {
    local _ipython=$(which ipython)
    [[ -n $IPYTHON ]] && _ipython=$IPYTHON
    pypath $_ipython "$@"
}

pir () {
    pi -r "$@"
}

pvv () {
    local virtualenv_=.venv
    python -m venv $virtualenv_
    cde_activate_there $virtualenv_
}

piu () {
    pi --upgrade "$@"
}

# xxxx

pidd () {
    pip_install_develop .
}

ppip () {
    [[ "$@" ]] || return 1
    show_run_command python -m pip "$@"
    python3 -m pip "$@" 2>&1 | grep -q "using pip version"  && piup
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
    local force_=
    [[ $1 =~ -u*fu* ]] && force_=--force-reinstall
    [[ $1 =~ -f*uf* ]] && force_="$force_ --upgrade"
    [[ $force_ ]] && shift
    [[ -d "$1" ]] && _dir="$1" && shift
    _pipy_setup $_dir $force_ 2>&1 | grep -v already.satisfied  | grep -e ^Installed -e '^Installing .* script' -e pip.install | grep -e 'g [a-z_]+\>' -e '/\<[a-z0-9.-]*[^/]+$'
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

venv () {
    local activate_="$ACTIVATE"
    make_venv "$@" 2>/dev/null
    local venv_=.venv
    [[ -d "$1" ]] && venv_="$1/.venv"
    cde_activate_there $venv_ || return 1
    [[ "$activate_" != "$ACTIVATE" ]] && show_blue_line "cde_activate_there $venv_"
    pip install --upgrade pip | tail -n1
    whyp python 2>/dev/null
}

# _xxxx

_install_requirements_here () {
    local force_=$1 requirement_=
    [[ -f requirements.txt ]] && pir -r requirements.txt $force_ && return 0
    [[ -d requirements ]] && for requirement_ in requirements/*.txt; do pir ${requirement_} $force_ ; done
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

pylinum () {
    local string=$(pylint --help-msg $1 | hd1 | cut -d\: -f2 | cut -d\  -f1 | sed -e "s/^/# pylint: disable=/")
    [[ $string != "# pylint: disable=No" ]] && echo $string
}

# xxxxxxxxx

make_venv () {
    local __doc__="""Make a .venv"""
    local root_=. venv_=.venv venv_dir_=.venv
    if [[ -d "$1" ]]; then
        root_="$1"
        venv_dir_="$1/$venv_"
        shift
    fi
    local force_=
    [[ $1 =~ ^-(f|-force)$ ]] && force_=1
    if [[ -d $venv_dir_ ]]; then
        [[ $force_ ]] || return 0
        show_command "rm -rf $venv_dir_"
        rm -rf $venv_dir_
    fi
    show_command "python3 -m venv $venv_"
    python3 -m venv $venv_
}

# xxxxxxx*

pip_install_develop () {
    local __doc__="""pip install a directory for development"
    piup >/dev/null 2>&1
    local _install=develop
    local _dir=.
    if [[ -d "$1" ]]; then
        _dir="$1"
        shift
        local force_=
        [[ $1 == "-f" ]] && force_=--force-reinstall
        _install_requirements_there $_dir $force_
        if [[ -f setup.py ]]; then
            [[ $force_ ]] && force_=--upgrade
            pi $force_ -e .
        fi
    fi 2>&1 | grep -v already.satisfied
}

