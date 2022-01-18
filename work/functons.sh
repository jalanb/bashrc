#! /bin/bash

SOURCE_DIR="$(dirname $(readlink -f $BASH_SOURCE))"
WORK=wwts
WORK_COM=${WORK}.com

ssa () {
    ssh -i ~/.ssh/work/ab13173.key ab13173@$1.wwts.com
}

ssw () {
    local _command=$(python $SOURCE_DIR/ssw_command.py "$@")
    echo $_command
}

work () {
    echo "$@"."${WORK_COM}"
}

homework () {
    echo "${HOME}/${WORK}"
}

work_email () {
    echo "$@"@"${WORK_COM}"
}

is_work_server () {
    [[ "$1" =~ wwts[.]com$ ]]
}

server_to_project () {
    local _one=$1 && shift
    [[ $_one =~ wmp ]] && echo wmp
    [[ $_one =~ eop ]] && echo eop
    [[ $_one =~ opp ]] && echo opp
    [[ $_one =~ soso ]] && echo soso
    [[ $_one =~ bots ]] && echo bots
    [[ $_one =~ git ]] && echo bots
}

project_to_server () {
    local _project=$1 && shift
    local _server=$_project
    [[ $_server =~ $WORK_COM ]] || _server=$(work $_project)
    echo $_server
} 

use_bots () {
    local _venv=bots
    [[ $1 == -d ]] && _venv=bots_dev
    cde_activate_home $_venv
    local _root=~/bots/bots/bots
    [[ $1 == -d ]] && _root=~/bots/bots/develop
    cde_bin_PATH $_root/bin
    cde_PYTHONPATH $_root
}

remail_commits() {
    # http://stackoverflow.com/a/750182/500942

    git filter-branch --env-filter '
    OLD_EMAIL="github@al-got-rhythm.net"
    CORRECT_NAME="Alan Brogan"
    CORRECT_EMAIL=$(work_email alan.brogan)
    if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
    then
        export GIT_COMMITTER_NAME="$CORRECT_NAME"
        export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
    fi
    if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
    then
        export GIT_AUTHOR_NAME="$CORRECT_NAME"
        export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
    fi
    ' --tag-name-filter cat -- --branches --tags
}
