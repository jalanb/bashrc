#! /bin/cat

Welcome_to $BASH_SOURCE

export CDE_SOURCE=$(basename $BASH_SOURCE)
# x
# _
# xx
# _x
# xxx

c () {
    cde "$@"
}

cls () {
    local __doc__="clean, clear, ls"
    clean
    clear
    if [[ -n "$@" ]]; then
        l0 "$@"
    else
        l0 .
        echo
    fi
}

_pre_cd () {
    [[ -z $CDE_header ]] && return
    echo $CDE_header
}

_post_cd () {
    local _path=$(~/jab/bin/short_dir $PWD)
    [[ $_path == "~" ]] && _path=HOME
    [[ $_path =~ "wwts" ]] && _path="${_path/wwts/dub dub t s}"
    # set -x
    # echo $_path
    local _tildless=${_path/~/home} # ; echo t $_tildless
    local _homele=$(echo $_tildless | sed -e "s:$HOME:home:")
    local _homeles=${_homele/home\//} # ; echo 1 $_homeles
    local _homeless=${_homeles/home/} # ; echo 2 $_homeless
    local _rootless=$(echo $_homeless | sed -e "s:^/:root :" )
    local _said=$(echo $_rootless | sed -e "s:/: :g")
    sai $_said
    # echo "said $_said"
    # set +x
    _here_show_todo && echo
    # set -x
    _here_bash
    _here_bin
    _here_git
    # set -x
    _here_python && _here_venv
    # set +x
    [[ -n $1 ]] && 
    _here_ls && _here_clean
    # set +x
}

# rule 1: Always leave system commands alone
# So this is called "cde", not "cd"

cde () {
    local __doc__="cd to a dir, show the dir"
    _pre_cd
    KD_QUIET=1 kd "$@" || return 1
    [[ -d . ]] || return 1
    _post_cd
}

cdl () {
    cde "$@"
    l
}

cdp () {
    cde .
}
    
# xxxx

cdup () {
    cde ..
}
# xxxxx
    
cdupp () {
    cde ../..
}
# xxxxxxxxxxxx
    
cduppp () {
    cde ../../..
}
    
cdupppp () {
    cde ../../../..
}
    
cduppppp () {
    cde ../../../../..
}
    
cdupppppp () {
    cde ../../../../../..
}

_here_bin () {
    [[ -d ./bin ]] && add_to_a_path PATH ./bin
}

_here_git () {
    [[ -d ./.git ]] || return 0
    show_git_time . | head -n $LOG_LINES_ON_CD_GIT_DIR
    local _branch=$(git rev-parse --abbrev-ref HEAD)
    echo $_branch
    git_simple_status .
    show_version_here
    gl11
    return 0
}

_here_range () {
    cdra .
}

# xxxxxxxxxxxxx

_here_bash () {
    local __doc__="""LOok for __init__.sh here or below and source it if found"""
    local _init=./__init__.sh
    [[ -f $_init ]] || _init=bash/__init__.sh
    [[ -f $_init ]] || _init=src/bash/__init__.sh
    [[ -f $_init ]] && . $_init
    return 0
}

_here_clean () {
    for path in $(find . -type f -name '*.sw*'); do
        ls -l $path 2> ~/bash/fd/2
        rri $path && continue
        [[ $? == 1 ]] && break
    done
}

_here_l1 () {
    l -1 2> ~/bash/fd/2
}

_here_ls () {
    l 2> ~/bash/null
}

_here_venv () {
    local _active_venv="$VIRTUAL_ENV"
    local _active_bin="$_active_venv/bin"
    if [[ -e $_active_bin/ipython ]]; then
        alias ipy="$_active_bin/ipython" 
    else
        unalias ipy >/dev/null 
    fi > /dev/null 2>&1
    activate_python_here && return 0
    # set -x
    local _venvs=$HOME/.virtualenvs
    [[ -d $_venvs ]] || return 0
    local _here=$(realpath $(pwd))
    local _name="not_a_name"
    [[ -e $_here ]] && _name=$(basename_ $_here)
    local _venv_path=
    for _venv_path in $_venvs/*; do
        local _venv_dir="$_venv_path"
        [[ -d "$_venv_dir" ]] || continue
        local _venv_name=$(basename_ $_venv_dir)
        if [[ $_venv_name == $_name ]]; then
            local _venv_activate="$_venv_dir/bin/activate"
            [[ -f $_venv_activate ]] || return 1
            . $_venv_activate
            return 0
        fi
    done
    return 0
    # set +x
}

any_python_scripts_here () {
    local _found=$(find . -type f -name "*.py" -exec echo 1 \; -quit)
    [[ $_found == 1 ]] && rf -qpr
}

_activate () {
    . $ACTIVE
    # Thanks to @nxnev at https://unix.stackexchange.com/a/443256/32775
    hash -d python ipython pip pudb >/dev/null 2>&1
}

local_activate () {
    local _pwd=$(pwd)
    for _active in bin/activate ./activate; do
        [[ -f $_active ]] || continue
        [[ "$@" =~ -v ]] && echo $(readlink -f $_active)
        return 0
    done
    return 1
}

_active () {
    #(( $(dirname_ $( readlink -f $ACTIVE )) == $(dirname $(readlink -f $(command -v python))) ))
    local _one=$(dirname_ $(readlink -f $ACTIVE))
    local _two=$(dirname_ $(readlink -f $(command -v python)))
    test "$_one" = "$_two"
}

activate_python_here () {
    ACTIVE=$(local_activate -v) || return 1
    _active || _activate
    PYTHON_VERSION=$(python --version 2>&1 | head -n 1 | cut -d' ' -f 2)
}

python_project_here () {
    [[ -f setup.py || -f requirements.txt || -d ./$_dir_name ]]
}

# _xxxx
# xxxxx

cccde () {
    1
    cc
}
# _xxxxx
# xxxxxx

# xxxxxxxxxxxxxxx

_here_python () {
    any_python_scripts_here || return 0
    python_project_here || return 0
    activate_python_here
    local _dir=$(realpath .)
    local _dir_name=$(basename_ $_dir)
    local egg_info=${_dir_name}.egg-info
    if [[ -d $egg_info ]]; then
        ri $egg_info
    fi
    return 0
}

_here_show_todo () {
    if [[ -f todo.txt ]]; then
        todo_show
        return 0
    fi
    return 1
}
# xxxxxxxxxxxxxxxxx

show_version_here () {
    local config=./.bumpversion.cfg
    if [[ -f $config ]]; then
        bump show
        return
    fi
    echo "[bumpversion]" > $config
    echo "commit = True" >> $config
    echo "tag = True" >> $config
    echo "current_version = 0.0.0" >> $config
    git add $config
    echo "git commit -m\"v0.0.0\""
    echo bump
}

Bye_from $BASH_SOURCE
