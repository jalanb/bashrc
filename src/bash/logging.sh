#! /bin/cat

# login.sh: source by ~/.bashrc

# set -e
# set +e

am_interactive () {
    [[ $- =~ i ]]
}

is_running () {
    /usr/bin/pgrep -f $1  > /dev/null 2>&1
    return $?
}

do_not_use_proxy () {
    unset https_proxy
    unset http_proxy
}

use_proxy () {
    #export https_proxy=http://w3proxy.s3group.com:3128/
    #export http_proxy=http://w3proxy.s3group.com:3128/
    export https_proxy=http://avproxylan.dublin.s3group.com:8080/
    export http_proxy=http://avproxylan.dublin.s3group.com:8080/
}

_source () {
    test -f $1 || return 1
    pushd $(dirname $1) >/dev/null 2>&1 || return 1
    source $1
    popd >/dev/null 2>&1 || return 1
    return 0
}

_edit_log () {
    cd "$1"
    sed -i -e "s:/tmp/virtualenvwrapper-initialize-hook-[A-Za-z0-9]\+:/tmp/virtualenvwrapper-initialize-hook-XXXX:" $2
    local _previous_log=$(ls -1tr *.bashrc.log | tail -n 2 | head -n1)
    local _differ=
    if ! diff -q $_previous_log "$2"; then
        _differ="-do $_previous_log"
    fi
    vim $_differ $2 + +?"^[^+'].*"
    cd
    # KBSS: can discard the "- 2>/dev/null", in ~
}

trace_one_bashrc () {
    local _level="^+ "
    verbose_interactive_bashrc | grep $_level
}

. ~/jab/src/bash/hub.sh

run_bashrc () {
    echo Welcome to $HOME/.bashrc
    export PATH=/usr/local/bin:/usr/bin:/bin
    export SHELL=/bin/bash
    . ~/hub/what/what.sh
    builtin cd && . .bashrc > bashrc.log 2>&1 && builtin cd >/dev/null 2>&1
    if ! is_running autocutsel
    then
        autocutsel &
        autocutsel -s PRIMARY &
    fi
    export TERM="xterm-256color"
    source $HOME/bin/virtualenvwrapper.sh
    do_not_use_proxy
    mython ~/jab/src/python/checksums.py
    echo Bye from $HOME/.bashrc
}

concise_interactive_bashrc () {
    am_interactive && run_bashrc
}

verbose_interactive_bashrc () {
    am_interactive && verbosely run_bashrc
}

verbosely () {
    (set -x; "$@")
}

log_verbose_bashrc () {
    local _there=~/log
    test -d $_there || return 1
    local _now=$(date +"%y_%m_%d_%H_%M_%S").bashrc.log
    local _temp=/tmp/$_now
    verbose_interactive_bashrc > $_temp 2>&1
    EXCLUSIONS="-e him\?xBH \
        -e up-to-date \
        -e tr.: \
        -e Error..Can.t.open.display \
        -e sed..e..s.Your.branch..... \
        -e estimate.py \
        -e ^...-- \
        -e ^..-- \
        -e ^.-- \
        -e tkdiff.vimdiff.gvimdiff.xxdiff \
        -e ^..[0-9][0-9]m \
        -e nothing.to.commit..working.directory.clean
        "
    grep -v $EXCLUSIONS $_temp > $_there/$_now
    rm -f $_temp
    _edit_log $_there $_now
}

# log_verbose_bashrc
concise_interactive_bashrc
