#! /usr/bin/env bat -l bash

qq () {
    quietly "$@"
}

Qq () {
    Quietly "$@"
}

QQ () {
    QUIETLY "$@"
}

qt () {
    QQ type "$@"
}

QT () {
    QQ type "$@"
}

qx () {
    local doc_="""Catch an edge case in terminal"""
    local doc__="""set -x writes to stderr, even after a subshell"""
    (set +x; "$@") 2>/dev/null
}

#
# xxx
# xxxx

from () {
    local source_="$1"
    local import_=$2
    local type_=$3
    QT "$type_" && return 0
    QUIETLY test -f "$source_" || return 2
    source "$source_"
}

# xxxxx
# xxxxxx
# xxxxxxx

quietly () {
    "$@" 2>/dev/null
}

Quietly () {
    "$@" 1>/dev/null
}

QUIETLY () {
    Quietly quietly "$@"
}

