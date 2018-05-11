#! /bin/cat

Welcome_to $BASH_SOURCE

__version__=0.5.3

local_rc () {
    local __doc__="There might be local files with new $PWD and commands"
    local _cd=$1; shift
    local _cdd=
    local _rcf=${BASH_RC:-_rc.sh}
    local _cdf=${BASH_CD:-_cd.in}
    [[ -f $_rcf ]] && _cdd=$(dirname $(readlink -f $_rcf))
    if [[ -f $_cdf ]]; then
        _cdd=$(dirname $(readlink -f $_cdf))
        _cd=$(cat $_cdf)
        rm -f $_cdf
    fi
    cd $_cd
    if [[ -f $_rcf ]]; then
        echo "-f "'$_rcf'"($_rcf)" >&2
        local _rc="$(cat $_rcf)"
        [[ -n $_rc ]] || echo "-z "'$_rc'"'$_rc'" >&2
        [[ -n $_rc ]] && eval $_rc
        rm -f $_rcf
    else
        echo "! -f "'$_rcf'"($_rcf)" >&2
    fi 2>/dev/null
}

. ~/bash/tput.sh
. ~/bash/aliases.sh
. ~/bash/asserts.sh
. ~/bash/cde.sh
. ~/bash/first_num.sh
. ~/bash/functons.sh
. ~/bash/github.sh
. ~/bash/hosts.sh
. ~/bash/history.sh
. ~/bash/jabnet.sh
. ~/bash/prompt.sh
. ~/bash/pt.sh
. ~/bash/pym.sh
. ~/bash/repo.sh
. ~/bash/require.sh
. ~/bash/rf.sh
. ~/bash/run_python.sh
. ~/bash/virtualenvwrapper.sh
. ~/bash/wwts.sh
. ~/bash/keyboard/__init__.sh
. ~/bash/git/__init__.sh

export _BASH_DIR=~/bash

Bye_from $BASH_SOURCE
