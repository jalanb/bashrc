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

cde () {
    KD_QUIET=1 kd "$@" || return 1
    _show_todo_here
    echo
    echo
    echo
    show_git_time . | head -n $LOG_LINES_ON_CD_GIT_DIR
    echo
    activate_ancestor_virtualenv_hence
    cde_git  && cde_python
}

cde_git () {
    [[ -d ./.git ]] || return 1
    git_simple_status $(pwd) || lk
    show_version_here
}
# _xx
# xxxx

cde_python () {
    local _dir=$(dirname $(readlink -f .))
    local _dir_name=$(basename $_dir)
    [[ -f setup.py || -d ./$_dir_name ]] || return 1
    find . -type f -name "*.py" || return 0
    local _dir_name=$1
    local egg_info=${_dir_name}.egg-info
    if [[ -d $egg_info ]]; then
        rri $egg_info
    fi
}

ccde () {
    local __doc__="There's always gcc, on the off chance it's needed"
    c . "$@"
}
# _xxxx
# xxxxx

cccde () {
    1
    cc
}
# _xxxxx
# xxxxxx

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

activate_ancestor_virtualenv_hence () {
    local _venvs=$HOME/.virtualenvs
    [[ -d $_venvs ]] || return 1
    local _here=$(readlink -f $(pwd))
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
}
