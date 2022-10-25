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

pyp () {
    pym pip "$@"
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


# xxx

# xxxx

ppie () {
    local dir_=$1
    [[ -d $dir_ ]] || dir_=.
    ppi $1/setup.py && upgrade_=
    [[ -f $setup_ ]] && upgrade="--upgrade"
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

ppii () {
    local _ipython=$(which ipython)
    [[ -n $IPYTHON ]] && _ipython=$IPYTHON
    pypath $_ipython "$@"
}

ppip () {
    [[ "$@" ]] || return 1
    if ppi "$@" | grep -q "pip install --upgrade pip"; then 
        quietly ppiu pip
    fi
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
    ppie "$dir_"
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

pirr () {
    _install_requirements_from "$@"
}

piup () {
    [[ $1 == [-]v ]] && ppiu pip || quietly ppiu pip
}

venv () {
    local activate_="$ACTIVATE"
    quietly make_venv "$@"
    local venv_=.venv
    [[ -d "$1" ]] && venv_="$1/.venv"
    cde_activate_there $venv_ || return 1
    [[ "$activate_" != "$ACTIVATE" ]] && show_command "cde_activate_there $venv_"
    quietly whyp python
}

# _xxxx

# xxxxxxx

# xxxxxxxxx

make_venv () {
    local __doc__="""Make a .venv"""
    local root_=. venv_=.venv venv_dir_=.venv
    if [[ -d "$1" ]]; then
        root_="$1"
        venv_dir_="$1/$venv_"
        shift
    fi
    if [[ -d $venv_dir_ ]]; then
        if [[ $1 =~ ^-(f|-force)$ ]]; then
            show_command "rm -rf $venv_dir_"
            rm -rf $venv_dir_
        else
            piup
            return 0
        fi
    fi
    [[ $VIRTUAL_ENV ]] && deactivate
    show_command "python3 -m venv $venv_"
    python3 -m venv --copies $venv_
    $python_ -m ensurepip
    ppiu pip setuptools wheel
    local requirements_=$(requirements_file $root_)
    [[ $requirements_ ]] || return 0
    $venv_python_ -m pip install -r $requirements_
}

requirements_file () {
    local dir_=.
    [[ -d $1 ]] && dir_=$1
    local name_= file_= requirements_=
    [[ -f $dir_/requirements.txt ]] && requirements_=$dir_/requirements.txt
    if [[ -d $dir_/requirements ]]; then
        for name_ in requirements linting testing devops development; do
            file_=$dir_/requirements/$name_.txt
            [[ -f $file_ ]] || continue 
            requirements_=$file_
        done
    fi
    [[ -f $requirements_ ]] || return
    echo $requirements_
}
