#! /bin/cat

PYTHON_SOURCE="$BASH_SOURCE"
# x
# xx

.p () {
    source "$PYTHON_SOURCE"
}

# xxx

latest_python () {
    quietly which $(compgen -c python3. | grep -v '[_-]' | sort -uV | tail -1)
}

python_command () {
    local __doc__="""Command to be used in shell is python3, or can be over-written with $PYTHON"""
    local python_=${PYTHON:-"$(latest_python)"}
    if ! QUIETLY command -v $python_ ; then
        echo $python_ not available >&2
        return 1
    fi
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

wp () {
    which_python "$@"
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
        ppi $upgrade_ -e .
        # | grep -v -e uninstall -e satisfied -e existing -e collected
        [[ -f requirements/development.txt ]] && ppr requirements/development.txt
    )
}

freeze_special () {
    [[ $1 =~ ^(pip|wheel|setuptools)$ ]]
}

ppf () {
    local quiet_=
    [[ $1 =~ -q ]] && shift && quiet_=-q
    if [[ "$@" ]]; then
        if freeze_special $1; then
            import_version $1
        elif [[ $quiet_ ]]; then
            pyp $quiet_ freeze | grep -q "$@"
        else
            pyp $quiet_ freeze | grep --color "$@"
        fi && return 0 || return 1
    else
        pyp $quiet_ freeze
    fi
}

ppi () {
    [[ $1 == install ]] && shift
    local __doc__="""Install $* with pip"""
    pyp install --quiet "$@"
    # 2>&1 | grep -v -e already -e "distutils config files" | grep --color [un]*installed
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
    pyp uninstall --quiet -y "$@"
}

pyc () {
    local cmd_=$(quietly python_command)
    [[ $cmd_ ]] || return 1
    $cmd_ -c "$@"
}

pym () {
    local args=("$@") quiet_=
    for i in "${!args[@]}"; do
        [[ ${args[$i]} =~ -q ]] && unset args[$i] && quiet_=1
    done
    local cmd_=$(quietly python_command)
    [[ $cmd_ ]] || return 1
    [[ $quiet_ ]] || show_command $cmd_ -m "${args[@]}"
    $cmd_ -m "${args[@]}"
}

pyp () {
    pym pip --require-virtualenv "$@"
}

vba () {
    if [[ -f .venv/bin/activate ]]; then
        source .venv/bin/activate
    elif [[ -f ../.venv/bin/activate ]]; then
        source ../.venv/bin/activate
    else
        echo ".venv not found" >&2
        return 1
    fi
}

# xxxx

acti () {
    unhash_activate "$1" && return 0
    local file_=$(venv_activator "$@")
    [[ -f "$file_" ]] || ls $(readlink -f "$file_")
    return 1
}

ppie () {
    ppi -e "$@"
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

reactivate () {
	unhash_activate "$1"
    ppp
}

venv () {
    local __doc__="""Activate a .venv (make it if needed)"""
    local dir_=.
    if [[ -d "$1" ]]; then
        dir_="$1"
        shift
    fi
    local venv_dir_="$dir_/.venv"
    if [[ -d "$venv_dir_" && $1 =~ ^-(f|-force)$ ]]; then
        show_command "rm -rf \"$venv_dir_\""
        rm -rf "$venv_dir_" >/dev/null
    fi
    de_activate
    hash -d python3 python 2>/dev/null
    pym venv --copies --clear "$venv_dir_"
    reactivate "$venv_dir_"
    install_python_project "$dir_" -p
}

# xxxxx

install_pip () {
    local quiet_=
    [[ $1 =~ -q ]] && shift && quiet_=-q
    # quietly ppf wheel && return 0
    pym $quiet_ ensurepip --user
    # 2>&1 | grep -v -e Looking -e already -e "distutils config files" | grep [un]*installed
    ppu $quiet_ --user "setuptools>=65.5.1" wheel pip
}

import_version () {
    local quiet_=
    [[ $1 =~ -q ]] && shift && quiet_=-q
    local module_=$1; shift
    local version_=$(pyc "import $module_; print($module_.__version__)")
    [[ $version_ ]] || return 1
    [[ $quiet_ =~ -q ]] && return 0
    echo "$module_==$(version_)"
    return 0
}

import_version -q pip || install_pip -q

has_pyproject_extra () {
    local file="$1" group="$2"
    awk '
        $0 ~ /^\[project.optional-dependencies\]/ { in_section=1; next }
        $0 ~ /^\[/ { in_section=0 }
        in_section && $0 ~ "^"grp"[[:space:]]*=[[:space:]]*\\[" { found=1 }
        END { exit(found ? 0 : 1) }
    ' grp="$group" "$file"
}

as_requirement_file () {
    local dir_="$1"
    local name_=$2
    local path_="$dir_/$name_.txt"
    [[ -f "$path_" ]] || return 1
    quietly readlink -f "$path_"
}

install_python_project () {
    local dir_=.
    [[ -d "$1" ]] && dir_="$1"
    [[ -d "$dir_" ]] || return 1
    [[ $2 =~ -p ]] || ppp
    local pyproject_="$dir_/pyproject.toml"
    local groups=(dev devops test lint)
    if [[ -f "$pyproject_" ]]; then
        for g in "${groups[@]}"; do
            has_pyproject_extra "$pyproject_" "$g" || continue
            lblue_line "Installing pyproject extra: $g"
            ppie "${dir_}.[${g}]"
            return 0
        done
    fi
    local requirements_dir_="$dir_/requirements"
    [[ -d "$requirements_dir_" ]] || requirements_dir_=
    local path_
    for g in "${groups[@]}"; do
        path_="$(as_requirement_file "$requirements_dir_" "$g")"
        [[ -f "$path_" ]] || continue
        lblue_line "Installing requirement file: ${g}.txt"
        ppr "$path_"
        ppie "${dir_}"
        return 0
    done
    path_="$dir_/requirements.txt" 
    if [[ -f "$path_" ]]; then
        ppr "$path_"
        lblue_line "Installing requirements.txt"
    fi
    ppie "${dir_}"
}

install_requirements () {
    local dir_=.
    [[ -d "$1" ]] && dir_="$1"
    [[ -d "$dir_" ]] || return 1

    local requirement_=requirements.txt requirements_dir_=
    [[ -f $requirement_ ]] && requirements_dir_="requirements"
    [[ -d "$dir_/requirements" ]] && requirements_dir_=$(ls "$dir_/requirements/*.txt")
    [[ -d "$requirements_dir_" ]] || requirements_dir_="$requirement_"

    [[ $2 =~ -p ]] || ppp
    local requirement_file_= 
    for requirement_ in $requirements_; do
        [[ -f "$requirement_" ]] || continue
        lblue_line Found requirements in $requirement_
        ppr "$requirement_"
        break
    done
}

pip_install_develop () {
    local __doc__="""pip install a directory for development"
    install_python_project "$@"
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
    unactivate -q
    show_command "source \"$file_\""
    source "$file_"
    which_python
}

de_activate () {
    QT deactivate && deactivate
    [[ $VIRTUAL_ENV ]] && QUIETLY deactivate
}

unactivate () {
    local arg_=
    de_activate
    unhash_py
    [[ $1 == -q ]] || show_python
}

unhash_py () {
    QUIETLY hash -d python python2 python3 ipython ipython2 ipython3 pudb pudb3 pdb ipdb pip pip2 pip3
}

some_python3 () {
    local __doc__="""It's a Python Dev's machine, there must be some python3 installed"""
    local python_=
    if [[ -x "$PYTHON" ]] ; then
        python_="$PYTHON"
    elif QUIETLY which python3 ; then
        python_=python3
    fi
    if [[ ! $python_ ]]; then
        [[ $1 =~ -q ]] || show_fail "No python available"
        return 1
    fi
    $python_ -c"import sys; print(sys.executable)"
}

which_python () {
    local __doc__="""Show the real paths to python, from which, python and readlink"""
    local default_python_="$(latest_python)"
    QUIETLY which $default_python_ || default_python_=python
    local python_=${PYTHON:-$default_python_}
    local exec_=$($python_ -c"import sys; print(sys.executable)")
    local version_=$($python_ -c"import sys; print(sys.version.split()[0])")
    local real_exec_=$(readlink -f $exec_)
    local shown_=
    if [[ $python_ =~ ^python3? ]]; then
        local which_=$(which $python_)
        if [[ $exec_ != $which_ ]]; then
            show_data "   bash: $which_"
            show_data " python: $exec_"
            [[ $real_exec_ == $exec_ ]] || show_data "   real: $real_exec_"
            shown_=1
        fi
    fi
    if [[ ! $shown_ ]]; then
        if [[ $real_exec_ == $exec_ ]]; then
            show_data " python: $exec_"
        else
            show_data " python: $exec_"
            show_data "   real: $real_exec_"
        fi
    fi
    show_data "version: $version_"
    local real_exec_=$(readlink -f $python_exec_)
    same_path "$python_exec_" "$real_exec_" || show_data "   real: $real_exec_"
}

which_pythons () {
    [[ $1 ]] && for arg in "$@"; do which_python $arg; done
    which_python python
    which_python python3
    which_python ipython
    which_python pudb
}

ipython_profile () {
    local arg_=$1
    [[ $arg_ ]] || arg_=default
    local profile_=
    for profile_ in $(ipython profile list | grep '^    ' | grep -v = | sed -e "s,^ *,,") ; do
        if [[ $profile_ =~ $arg_ ]]; then
            echo $profile_
            return 0
        fi
    done
    return 2
}

_pyv_strip_trailing_colons() {
    local path_=$1
    echo "$path_" | sed 's/:*$//'
}

_pyv_has_spaces_in_path() {
    echo "$PATH" | grep -q ' ' && {
        red_line "PATH contains spaces, cannot safely manipulate" >&2
        return 0
    }
    return 1
}

_pyv_find_exact_version() {
    local version_=$1 pythons_dir=/opt/pythons
    [[ -d "$pythons_dir" ]] || return 1
    local pattern_="^${version_}\$"  # exact match
    [[ "$version_" =~ \.[0-9]+$ ]] || pattern_="^${version_}\."  # prefix for partial
    local dir_= matches_=()
    for dir_ in $(ls -1 "$pythons_dir" 2>/dev/null | sort -V -r); do
        [[ "$dir_" =~ $pattern_ ]] || continue
        local bin_dir="$pythons_dir/$dir_/bin"
        local python_exe=
        [[ -x "$bin_dir/python3" ]] && python_exe="$bin_dir/python3"
        [[ -x "$bin_dir/python" ]] && [[ ! $python_exe ]] && python_exe="$bin_dir/python"
        [[ $python_exe ]] || continue
        matches_+=("$bin_dir")
    done
    [[ ${#matches_[@]} -eq 0 ]] && return 1
    [[ ${#matches_[@]} -gt 1 ]] && {
        red_line "Multiple Python $version_ found, call a sysadmin:" >&2
        printf '%s\n' "${matches_[@]}" | red >&2
        return 1
    }
    echo "${matches_[0]}"
    return 0
}

_pyv_offer_download() {
    local version_=$1
    yellow_line "Python $version_ not found in /opt/pythons"
    # TODO: offer to download/compile or suggest available versions
    return 1
}

pyv() {
    [[ $# -eq 0 ]] && which_python && return 0
    _pyv_has_spaces_in_path && return 1
    local target_=$(_pyv_find_exact_version "$1")
    [[ $target_ ]] || {
        _pyv_offer_download "$1"
        return 1
    }
    _pyv_validate_first
    local new_path=$(_pyv_strip_pythons)
    new_path=$(_pyv_strip_trailing_colons "$new_path")
    export PATH="$target_:$new_path"
    green_line "Switched to $target_"
    which_python
}
