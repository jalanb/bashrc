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

ack () {
    if [[ -x /usr/local/lib64/perl5 ]]; then
        $HOME/.local/bin/ack "$@"
    else
        $HOME/.local/bin/rg "$@"
    fi
}

alint () {
    if [[ -d .github ]]; then
        quietly ansible-lint --exclude=.github "$@"
    else
        quietly ansible-lint "$@"
    fi
}
