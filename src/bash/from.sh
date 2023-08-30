#! /bin/bash -x
        
$TO_ROOT=0; 
$TO_BRANCH=-1
$TO_LEAF=-2

set__x () {
    set +x
    return "$@"
}

from () {
    __doc__="Run Commands down from $PWD or $3
			No Commands are run without permissions
			LEAF_COMMAND is run only when there are no more dirs
			PRE_DIRS, POST_DIRS, TO_SUB_DIR and FROM_SUB_DIR work as expected"
	# gits $TO_LEAF 0 "$@"
    # permissions=git
    (
        set -x
        [[ -z $permissions ]] && return set__x $(realpath .)
        _further=$1; shift
        _level=$1; shift
        # _further=-2; _level=0
        [[ $_further -lt $TO_ROOT ]] && return set__x $_further
        # [[ -2 -lt 0 ]] && return -2
        [[ $_level -gt $_further ]] && return set__x $_level
        # [[ 0 -gt -2 ]] && return 0
    	local _leaf=1
    	local _result=0
    	# gits "$@"
    	if [[ $_level -lt $once ]]; then
    	# if [[ 0 -lt $once ]]; then
    		parent=.; [[ -d "$3" ]] && _parent="$3"
    		$PRE_DIRS
    		for _item in $(ls); do 
    			[[ -d "$_item" ]] || continue
    			_leaf=0
    			(cd "$_item";
    				$TO_SUB_DIR
    				from $_further $(( $_level - 1 )) $_parent "$@"
    				_result=$?
    				$FROM_SUB_DIR
    			)
    		done
    		$FROM_SUB_DIRS
    	fi
        [[ $_leaf == 1 ]] && $LEAF_COMMAND
        # [[ -n "git" ]] && stop_permissions
    )
    return $_result
}

git_command () {
	[[ -d .git ]] || return 0
    (permissions=git; from git "$@")
}

gits () {
    permissions=
	PRE_DIRS=${GIT_COMMAND:-git_command pull --rebase}
	POST_DIRS=${GIT_COMMAND:-git_command commit .}
 	TO_SUB_DIR=${GIT_COMMAND:-git_command status --short}
	FROM_SUB_DIR=${GIT_COMMAND:-git_command add -i .}
}

gits_status () {
	GIT_COMMAND= FROM_SUB_DIR="git_command status" gits $TO_LEAF 0 "$@"
}

gits_pull () {
	GIT_COMMAND= FROM_SUB_DIR=-git_command status --short; PRE_DIRS="git_command pull --rebase" gits $TO_BRANCH 0 "$@"
}

gits_push () {
}

rebase_all () {
    GIT_COMMAND="pull --rebase" _git_down "$@"
}

fetch_all () {
    GIT_COMMAND="fetch --all" _git_down "$@"
}

status_all () {
    GIT_COMMAND="status --short"_git_down "$@"
}

status_all
