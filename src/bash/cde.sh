#! /bin/cat

# . ~/jab/src/bash/cde.sh

# cccc may be defined in cde.sh

# x
# _
# xx
# _x
# xxx

cls () {
    local __doc__="clean, clear, ls"
    clean
    clear
    if [[ -n "$@" ]]; then
        lk "$@"
    else
        l .
        echo
    fi
}

_pre_kd () {
    [[ -z $CDE_header ]] && return
    echo $CDE_header
}

cde () {
    local __doc__="cd to a dir, show the dir"
    _pre_kd
    KD_QUIET=1 kd "$@" || return 1
    _post_kd
}

_post_kd () {
    _show_todo_here && echo
    # set -x
    _post_kd_bash
    _post_kd_git  && _post_kd_python && _post_kd_venv
    _post_kd_show  # see also _post_kd_git
    # set +x
}

# xxxxxxxxxxxx

_post_kd_git () {
    [[ -d ./.git ]] || return 1
    show_git_time . | head -n $LOG_LINES_ON_CD_GIT_DIR
    local _branch=$(git rev-parse --abbrev-ref HEAD)
    echo $_branch
    git_simple_status .
    show_version_here
    gl11
}

# xxxxxxxxxxxxx

_post_kd_bash () {
    local __doc__="""LOok for __init__.sh here or below and source it if found"""
    local _init=./__init__.sh
    [[ -f $_init ]] || _init=bash/__init__.sh
    [[ -f $_init ]] || _init=src/bash/__init__.sh
    [[ -f $_init ]] && . $_init
}

_post_kd_show () {
    l
}

_post_kd_venv () {
    # set -x
    local _venvs=$HOME/.virtualenvs
    [[ -d $_venvs ]] || return 1
    local _here=$(realpath $(pwd))
    local _venvs_path=$_venvs/$(basename $_here)
    local _path=$_here
    while [[ ! -d "$_venvs_path" ]]; do
        [[ -z $_path || $_path == "/" || $_path == $HOME ]] && return 1
        _path=$(dirname $_path)
        _venvs_path=$_venvs/$(basename $_path)
    done
    local _venv_activate="$_venvs_path/bin/activate"
    [[ -f $_venv_activate ]] || return 1
    . $_venv_activate 
    # set +x
}

any_python_scripts_here () {
    local _found=$(find . -type f -name "*.py" -exec echo 1 \; -quit)
    [[ $_found == 1 ]] && rf -qpr
}

python_project_here () {
    [[ -f setup.py || -d ./$_dir_name ]]
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

_post_kd_python () {
    any_python_scripts_here || return 0
    python_project_here || return 0
    local _dir=$(realpath .)
    local _dir_name=$(basename $_dir)
    local egg_info=${_dir_name}.egg-info
    if [[ -d $egg_info ]]; then
        ri $egg_info
    fi
}

_show_todo_here () {
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

# xxxxxxxxxxxxxxxxxxx
