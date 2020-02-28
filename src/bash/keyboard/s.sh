#! /bin/cat

Welcome_to $BASH_SOURCE

source ~/hub/whyp/whyp.sh

# _
# x
s () {
    local __doc__="""s is for sourcing"""
    . "$@"
}

# _x
# xx
sa () {
    s $(aliases)
}

sb () {
    s ~/bash/__init__.sh
}

sf () {
    s $(functons)
}

# _xx
# xxx

sla () {
    s $(aliases -l)
}

sgf () {
    s $(functons -g)
}

slf () {
    s $(functons -l)
}

swf () {
    s $(functons -w)
}

Bye_from $BASH_SOURCE
