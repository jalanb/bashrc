#! /bin/cat

type same_dir >/dev/null 2>&1 || . ~/bash/paths.sh

# x
# xx

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

ppi () {
    [[ $1 == install ]] && shift
    ppip install "$@"
}

ppu () {
    ppip uninstall "$@"
}

# xxxx

ppid () {
    pip_install_develop "$@"
}

ppie () {
    if [[ -d "$1" ]]; then
        (
            cd "$1"
            ppi -e .
        )
    else
        ppi -e . 
    fi
}

ppii () {
    local _ipython=$(which ipython)
    [[ -n $IPYTHON ]] && _ipython=$IPYTHON
    pypath $_ipython "$@"
}

ppip () {
    [[ "$@" ]] || return 1
    show_command python3 -m pip "$@"
    python3 -m pip "$@" > ~/fd1
    grep -v -e already.satisfied -e upgrade.pip ~/fd1
    if grep -q "pip install --upgrade pip" ~/fd1; then
        python3 -m pip install --upgrade pip &
    fi
}

ppir () {
    ppi -r "$@"
}

ppiu () {
    ppi --upgrade "$@" | grep -v already.satisfied
}

pipv () {
    local dir_=$PWD setup_py_= setup_cfg= requires_=
    [[ -d "$1" ]] && dir_="$1" && shift
    [[ -f "$dir_/setup.py" ]] && setup_py_="$dir_/setup.py"
    [[ -f "$dir_/setup.cfg" ]] && setup_cfg_="$dir_/setup.cfg"
    if [[ -d "$dir_/requirements" ]]; then
        requires_="$dir_"'/requirements/*'
    elif [[ -f "$dir_/requirements.txt" ]]; then
        requires_="$dir_/requirements.txt"
    fi
    vim -p "$setup_py_" "$setup_cfg_" "$requires_"
}

pirr () {
    install_requirements_at "$@"
}

piup () {
    python3 -m pip install --upgrade pip | grep installed && show_command "python3 -m pip install --upgrade pip"
}

vipy () {
    pipy -V "$@"
}

venv () {
    local __doc__="""Activate a .venv (make it if needed)"""
    local dir_=.
    [[ -d "$1" ]] && dir_="$1"
    local dir_venv_="$dir_/.venv"
    if [[ -d "$dir_venv_" ]]; then
        if [[ $1 =~ ^-(f|-force)$ ]]; then
            show_command "rm -rf \"$dir_venv_\""
            rm -rf "$dir_venv_" >/dev/null
        else
            unhash_activate "$dir_venv_"
            piup
            return 0
        fi
    fi
    [[ $VIRTUAL_ENV ]] && deactivate
    hash -d python3 2>/dev/null
    show_command "python3 -m venv \"$dir_venv_\""
    python3 -m venv --copies "$dir_venv_"
    unhash_activate "$dir_venv_"
    python3 -m ensurepip
    python3 -m pip install --upgrade pip setuptools wheel | grep installed
    install_requirements_at "$dir_" -p
}

# _xxxx

# xxxxxxx

pythonv () {
    python -V "$@"
}

# xxxxxxx

pylinum () {
    local string=$(pylint --help-msg $1 | hd1 | cut -d\: -f2 | cut -d\  -f1 | sed -e "s/^/# pylint: disable=/")
    [[ $string != "# pylint: disable=No" ]] && echo $string
}

# xxxxxxxxx

install_requirements () {
    install_requirements_at "$PWD" "$@"
}

install_requirements_at () {
    local dir_=.
    [[ -d "$1" ]] && dir_="$1"
    [[ $2 == -p ]] || piup
    local requirement_file_= requirements_=
    for requirement_file_ in requirements/development.txt requirements/testing.txt requirements/requirements.txt requirements.txt; do
        requirements_="$dir_/$requirement_file_"
        [[ -f "$requirements_" ]] || continue
        show_command "python3 -m pip install -r \"$requirements_\""
        python3 -m pip install -r "$requirements_" | grep installed
        break
    done
}


# xxxxxxx*

pip_install_develop () {
    local __doc__="""pip install a directory for development"
    local dir_=.
    if [[ -d "$1" ]]; then
        dir_="$1"
        shift
    fi
    install_requirements_at "$dir_"
    ppie "$dir_"
}

unhash_activate () {
    local dir_=.
    [[ -d "$1" ]] && dir_="$1"
    [[ -d "$dir_" ]] || return 1
    unhash_deactivate -q
    show_command "source \"$dir_/bin/activate\""
    source "$dir_/bin/activate"
    show_blue_line "python3 is $(which python3)"
}

unhash_deactivate () {
    local arg_=
    for arg_ in python python2 python3 ipython ipython2 ipython3 pudb pudb3 pdb ipdb pip pip2 pip3; do
        hash -d $arg_ 2>/dev/null
    done
    [[ $VIRTUAL_ENV ]] && deactivate
    [[ $1 == -q ]] || show_blue_line "python3 is $(which python3)"
}
