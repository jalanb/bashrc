#! /bin/cat

Welcome_to $BASH_SOURCE

source ~/hub/what/what.sh

# _
# x
s () {
    local __doc__="""s is for sourcing"""
    source_what "$@"
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

slf () {
    s $(functons -l)
}

Bye_from $BASH_SOURCE
