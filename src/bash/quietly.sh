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
    qq type "$@"
}

qx () {
    local doc_="""Catch an edge case in terminal"""
    local doc__="""set -x writes to stderr, even after a subshell"""
    (set +x; "$@") 2>/dev/null
}

#
# xxx
# xxxx
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

