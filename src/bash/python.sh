#! /bin/cat

# x
# xx

pym () {
    local args=("$@") quiet_=
    for i in "${!args[@]}"; do
        [[ ${args[$i]} == -q ]] && unset args[$i] && quiet_=1
    done
    [[ $quiet_ ]] || show_command "python -m" "${args[@]}"
    python -m "${args[@]}"
}

pmp () {
    pym pip "$@" 
}

ppd () {
    pip_install_develop "$@"
}

ppi () {
    [[ $1 == install ]] && shift
    show_command python3 -m pip install "$@"
    pmp install "$@" 2>&1 | grep -v -e already | grep --color [un]*installed
}

ppp () {
    ppu pip
}

ppr () {
    ppu -r "$@"
}

ppu () {
    ppi --upgrade "$@"
}

ppy () {
    pmp uninstall -y "$@"
}

# xxx

# xxxx

ppie () {
    local dir_=$1 upgrade_=
    [[ -d $dir_ ]] || dir_=.
    Quietly pyp freeze $(basename $(readlink -f $dir_)) && upgrade_=--upgrade
    if [[ -d "$dir" ]]; then
        (
            show_command cd "$1"
            cd "$1"
            ppi $upgrade_ -e .
        )
    else
        ppi $upgrade_ -e .
    fi
}

pipv () {
    local dir_=$PWD setup_py_= setup_cfg= requires_=
    [[ -d "$1" ]] && dir_="$1" && shift
    [[ -f "$dir_/setup.py" ]] && setup_py_="$dir_/setup.py"
    [[ -f "$dir_/setup.cfg" ]] && setup_cfg_="$dir_/setup.cfg"
    if [[ -d "$dir_/requirements" ]]; then
        requires_="$dir_/requirements/*"
    elif [[ -f "$dir_/requirements.txt" ]]; then
        requires_="$dir_/requirements.txt"
    fi
    vim -p "$setup_py_" "$setup_cfg_" "$requires_"
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
            ppp
            return 0
        fi
    fi
    [[ $VIRTUAL_ENV ]] && deactivate
    hash -d python3 2>/dev/null
    pym venv --copies "$dir_venv_"
    unhash_activate "$dir_venv_"
    show_command python3 -m ensurepip
    pym ensurepip | grep -v -e Looking -e already | grep [un]*installed
    ppu setuptools wheel pip
    install_requirements_at "$dir_" -p
}

install_requirements_at () {
    local dir_=.
    [[ -d "$1" ]] && dir_="$1"
    [[ $2 == -p ]] || ppp
    local requirement_file_= requirements_=
    for requirement_file_ in requirements/development.txt requirements/testing.txt requirements/requirements.txt requirements.txt; do
        requirements_="$dir_/$requirement_file_"
        [[ -f "$requirements_" ]] || continue
        lblue_line Found requirements $requirements_
        ppr "$requirements_"
        break
    done
}

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
    unhash_deactivate
    show_command "source \"$dir_/bin/activate\""
    source "$dir_/bin/activate"
    show_data "python3 is $(which python3)"
}

unhash_deactivate () {
    local arg_=
    for arg_ in python python2 python3 ipython ipython2 ipython3 pudb pudb3 pdb ipdb pip pip2 pip3; do
        hash -d $arg_ 2>/dev/null
    done
    [[ $VIRTUAL_ENV ]] && deactivate
    [[ $1 == -q ]] || show_data "python3 is $(which python3)"
}
