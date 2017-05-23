#! /bin/cat

Welcome_to $BASH_SOURCE

path_to_this_repo () {
    local __doc__="Find root of git repo that this file is in"
    (cd $(dirname $BASH_SOURCE); git rev-parse --show-toplevel)
}

Bye_from $BASH_SOURCE
