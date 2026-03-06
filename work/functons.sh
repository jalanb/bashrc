#! /bin/bash

WORK_DIR="$(dirname $(readlink -f $BASH_SOURCE))"
WORK=smbc
WORK_COM=smbcgroup.com

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
    [[ "$1" =~ ${WORK_COM} ]]
}

work_github () {
    echo "https://github.com/SMBCGitHub"
}
