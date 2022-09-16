#! /bin/cat

# x
# xx

pym () {
    [[ $1 == -q ]] && shift || show_command python3 -m "$@"
    python3 -m "$@"
}

pyp () {
    pym pip "$@"
}

ppi () {
    pyp install "$@"
}

ppu () {
    pyp uninstall -y "$@"
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

ppiq () {
}

ppir () {
    ppi -r "$@"
}

ppiu () {
    ppi --upgrade "$@" | grep -v already.satisfied
}

ppup () {
    ppiu pip
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
