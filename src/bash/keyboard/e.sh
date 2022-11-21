#! /bin/cat


# _
# x
# _x
# xx

#
# These e*() functions show result of last command
#      $ ls /bin && et || ef
# Especially used in CLI to show conditions
#      $ [[ -d /bin ]] && et || ef
# "&& et || ef" was abbreviated to etf
#      $ [[ -d /bin ]]; etf 
# Can also be used as command
#      $ etf test -d /bin 
# 
ef () {
    local result_=$?
    [[ $result_ == 0 ]] && return $result_
    eff $result_ || ett
    local __doc__="""fail fast, or show angrier faces"""
}

et () {
    local result_=$?
    [[ $result_ == 0 ]] && ett $result_ || return $result_
    local __doc__="""show a happy face :-) Or let the other ones out"""
}

eg () {
    env | gr "$@"
}

# xxx

eff () {
    local _status=$1
    echo "False $_status $(face $_status)" >&2
    false
    local __doc__="""Errors from a failed command"""
}

eft () {
    ( [[ $@ ]] && "$@" )
    etf
    local __doc__="""Errors from a command, or the one before"""
}

etf () {
    et || ef
}

ett () {
    local _status=$1
    echo "True $_status $(face $_status)" >&1
    true
    local __doc__="""Errors from a successful command"""
}

# _xx
# xxx

err () {
    "$@" >/dev/null 2>&1
    er
}

# xxxxx

face () {
    local _faces=(😎 👿  👎  💀  👻  💩  🤨   😐  😑  😥  😮  😫  😲  ☹️  😤  😢  😭  😦  😧  😨  😩  🤯   😬  😰  😱  🥵   🥶   😳  🤢  🤮)
    echo ${_faces[$1]}
}
