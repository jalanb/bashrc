#! /bin/bash -x
        
_once=1
_only_here=0
_all_the_way=-1

_cmd_down () {
    __doc__="Run a \$LEAF_COMMAND down from a dir"
    _further=$1; shift
    _level=$1; shift
    [[ $_level -lt 1 ]] && $LEAF_COMMAND
    [[ $_further -eq 0 ]] || return
    [[ $_further -gt 0 ]] && [[ $_level -gt $_further ]] && return
    for _sub_dir in $(ls); do
        [[ -d "$_sub_dir" ]] || continue
        (cd "$_sub_dir";
            $TO_SUB_DIR
            _cmd_down $_further $(( $_level - 1 )) "$@"
            $FROM_SUB_DIR
        )
    done
    return 0
}

_git_in_dir () {
    [[ -d .git ]] || return
    [[ -n $GIT_COMMAND ]] && git $GIT_COMMAND
    [[ -n $TO_SUB_DIR ]] && MORE_DOWN=0
}

_git_up () {
    FROM_SUB_DIR=_git_in_dir _cmd_down "$@"
}

_git_down () {
    TO_SUB_DIR=_git_in_dir _cmd_down "$@"
}

_default_dir () {
    echo $(dirname $(readlink -f $BASH_SOURCE))
}

rebase_all () {
    GIT_COMMAND="pull --rebase"_git_down "$@"
}

fetch_all () {
    GIT_COMMAND="fetch --all" _git_down "$@"
}

status_all () {
    GIT_COMMAND="status --short"_git_down "$@"
}

status_all
