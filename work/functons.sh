#! /bin/bash

SOURCE_DIR="$(dirname $(readlink -f $BASH_SOURCE))"
WORK=brightbeam
WORK_COM=${WORK}.com

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
    [[ "$1" =~ ${WORK}[.]com$ ]]
}

work_github () {
    echo "https://github.com/BrightbeamAI"
}

check () {
    local root_=$(get_root)
    local script_=$(find $root_ -name "check")
    local dest_=$(dirname $script_)
    (
        cd $dest_
        PS4= ./check
    )
}
