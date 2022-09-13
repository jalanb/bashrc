#! /bin/cat

type same_dir >/dev/null 2>&1 || . ~/bash/paths.sh

# x
# xx

pym () {
    python3 -m "$@"
}

pmp () {
    pym pip "$@" 
}

ppd () {
    pip_install_develop "$@"
}

ppi () {
    [[ $1 == install ]] && shift
    pmp install "$@" | grep --color installed
}

ppu () {
    ppi --upgrade "$@"
}

ppp () {
    ppu setuptools wheel pip
}

ppy () {
    pmp uninstall -y "$@"
}

# xxx

# xxxx

ppie () {
    if [[ -d "$1" ]]; then
        (
            show_command cd "$1"
            cd "$1"
            ppi -e .
        )
    else
        ppi -e . 
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
