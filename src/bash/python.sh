#! /bin/cat

# x
# xx
# xxx

_python_command () {
    local __doc__="""Cpommand to be used in this script is python3, or can be over-written with $PYTHON"""
    local python_=${PYTHON:-python3}
    $python_  -c"import sys; print(sys.executable)"
}

i () {
    local here_=$(jostname)
    console_title_on "ipython@$here_" && \
        ${IPYTHON:-ipython} "$@" && \
        console_title_off "${USER}@${here_}"
}

ip () {
    local __doc__="Run ipython with tab title"
    local me=$USER 
    local here_=$(jostname)
    local options_=-noconfirm_exit
    local _ipython=${IPYTHON:-ipython}
    if [[ $($_ipython --help | grep no.*confirm) == "--no-confirm-exit" ]]; then
        options_=--no-confirm-exit
    fi
    local profile_=$(ipython_profile $1)
    [[ $profile_ ]] && shift
    [[ $profile_ ]] || profile_=ipysyte
    options_="--profile=$profile_ $options_"
    console_title_on "${profile_}@${here_}" && \
        $_ipython $options_ "$@" && \
        console_title_off "${me}@${here_}"
}

ib () {
    ip ibots
}

ic () {
    ip company
}

ij () {
    ip jalanb
}

iz () {
    ip izatso
}

act () {
    unhash_activate "$1" && return 0
    local file_=$(venv_activator "$@")
    [[ -f "$file_" ]] || ls $(readlink -f "$file_")
    return 1
}

pym () {
    local args=("$@") quiet_=
    for i in "${!args[@]}"; do
        [[ ${args[$i]} =~ -q ]] && unset args[$i] && quiet_=1
    done
    [[ $quiet_ ]] || show_command "$(_python_command) -m" "${args[@]}"
    $(_python_command) -m "${args[@]}"
}

ppd () {
    pip_install_develop "$@"
}

ppe () {
    local dir_=$1 upgrade_=
    [[ -d "$dir_" ]] && show_command cd "$dir_" || dir_=.
    (
        cd "$dir_"
        Quietly ppf $(basename $(readlink -f .)) && upgrade_=--upgrade
        ppi $upgrade_ -e . | grep -v -e uninstall -e satisfied -e existing -e collected
        [[ -f requirements/development.txt ]] && ppr requirements/development.txt
    )
}

ppf () {
    if [[ "$@" ]]; then
        pyp freeze | grep "$@"
    else
        pyp freeze
    fi
}

ppi () {
    [[ $1 == install ]] && shift
    install_ppi
    show_command $(_python_command) -m pip install "$@"
    pyp install "$@" 2>&1 | grep -v -e already -e "distutils config files" | grep --color [un]*installed
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
    pyp uninstall -y "$@"
}

pyp () {
    pym pip --require-virtualenv "$@" 
}

# xxxx

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
    local venv_dir_="$dir_/.venv"
    if [[ -d "$venv_dir_" ]]; then
        if [[ $1 =~ ^-(f|-force)$ ]]; then
            show_command "rm -rf \"$venv_dir_\""
            rm -rf "$venv_dir_" >/dev/null
        else
            unhash_activate "$venv_dir_"
            ppp
            return 0
        fi
    fi
    [[ $VIRTUAL_ENV ]] && deactivate
    hash -d python3 python 2>/dev/null
    pym venv --copies --clear "$venv_dir_"
    unhash_activate "$venv_dir_"
    show_command $(_python_command) -m ensurepip
    install_requirements "$dir_" -p
}

install_ppi () {
    # quietly ppf wheel && return 0
    pym ensurepip 2>&1 | grep -v -e Looking -e already -e "distutils config files" | grep [un]*installed
    ppu "setuptools>=65.5.1" wheel pip
}

install_requirements () {
    local dir_=.
    [[ -d "$1" ]] && dir_="$1"
    [[ -d "$dir_" ]] || return 1 

    local requirement_=requirements.txt requirements_=
    [[ -f $requirement_ ]] && requirements_="requirements"
    [[ -d "$dir_/requirements" ]] && requirements_=$(ls "$dir_/requirements/*.txt")
    [[ -d "$requirements_" ]] || requirements_="$requirement_"

    [[ $2 =~ -p ]] || ppp
    local requirement_file_= requirements_=
    for requirement_ in $requirements_; do
        [[ -f "$requirement_" ]] || continue
        lblue_line Found requirements in $requirement_
        ppr "$requirement_"
        break
    done
}

pip_install_develop () {
    local __doc__="""pip install a directory for development"
    install_requirements "$@"
    ppe "$dir_"
}

show_python () {
    show_data "python  is $(which python)"
    show_data "python3 is $(which python3)"
}


venv_activator () {
    local venv_dir_=.
    [[ -d "$1" ]] && venv_dir_="$1"
    [[ -d "$1/.venv" ]] && venv_dir_="$1/.venv"
    local file_="${venv_dir_}/bin/activate"
    echo $file_
    test -f $file_
}

unhash_activate () {
    local file_=$(venv_activator "$@")
    [[ -f "$file_" ]] || return 1
    unhash_deactivate -q
    show_command "source \"$file_\""
    source "$file_"
    which_python
}

unhash_deactivate () {
    local arg_=
    QUIETLY type deactivate && deactivate
    for arg_ in python python2 python3 ipython ipython2 ipython3 pudb pudb3 pdb ipdb pip pip2 pip3; do
        QUIETLY hash -d $arg_
    done
    [[ $1 == -q ]] || show_python
}

which_python () {
    local __doc__="""Show the real paths to python, from which, python and readlink"""
    local python_=${PYTHON:-python}
    local exec_=$($python_ -c"import sys; print(sys.executable)")
    local version_=$($python_ -c"import sys; print(sys.version.split()[0])")
    local rlf_=$(readlink -f $exec_)
    local shown_=
    if [[ $python_ =~ ^python3? ]]; then
        local which_=$(which $python_)
        if [[ $exec_ != $which_ ]]; then
            show_data "   bash: $which_"
            show_data " python: $exec_"
            [[ $rlf_ == $exec_ ]] || show_data "   real: $rlf_"
            shown_=1
        fi
    fi
    if [[ ! $shown_ ]]; then
        if [[ $rlf_ == $exec_ ]]; then
            show_data " python: $exec_"
        else
            show_data " python: $exec_"
            show_data "   real: $rlf_"
        fi
    fi
    show_data "version: $version_"
}

ipython_profile () {
    [[ $1 ]] || return 1
    local profile_=
    for profile_ in $(ipython profile list | grep '^    ' | grep -v = | sed -e "s,^ *,,") ; do
        if [[ $profile_ =~ $1 ]]; then
            echo $profile_
            return 0
        fi
    done
    return 2
}
