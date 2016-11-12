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
        ld $(pwd)
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
    git_simple_status $(pwd) || lk
    activate_ancestor_virtualenv_hence
    show_version_here
}
# _xx
# xxxx

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
    else
        echo "[bumpversion]" > $config
        echo "commit = True" >> $config
        echo "tag = True" >> $config
        echo "current_version = 0.0.0" >> $config
        git add $config
        echo "git commit -m\"v0.0.0\""
        echo bump 
    fi
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
