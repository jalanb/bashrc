#! /bin/bash -x
        
$TO_ROOT=0; 
$TO_BRANCH=-1
$TO_LEAF=-2

set__x () {
    set +x
    return "$@"
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
