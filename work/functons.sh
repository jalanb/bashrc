#! /bin/bash

SOURCE_DIR="$(dirname $(readlink -f $BASH_SOURCE))"
PYTHON_DIR="$SOURCE_DIR"
WORK=wwts
WORK_COM=${WORK}.com

ssw () {
    local _command=$(python $PYTHON_DIR/ssw_command.py "$@")
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
