#! /bin/cat

Welcome_to $BASH_SOURCE

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
    [[ $? == 0 ]] && return $? || eff $?
    local __doc__="""fail fast, or show angrier faces"""
}

et () {
    [[ $? == 0 ]] && ett $? || return $?
    local __doc__="""show a happy face :-) Or let the other ones out"""
}

quietly unalias eg
eg () {
    env | g "$@"
}

# xxx

eff () {
    local __doc__="""Errors from a failed command"""
    local _status=$1
    echo "False $_status $(face $_status)" >&2
    false
}

eft () {
    local __doc__="""Errors from a command, or the one before"""
    ( [[ $@ ]] && "$@" )
    etf
}

etf () {
    wtf $?
    local __doc__="""Errors from a status"""
}

ett () {
    local __doc__="""Errors from a successful command"""
    local _status=$1
    echo "True $_status $(face $_status)" >&1
    true
}

wtf () {
    local _status=$?
    local __doc__="""Errors from a status"""
    [[ $1 ]] && _status=$1 && shift
    local _name=True
    local _streams=
    [[ $1 =~ -[qQ] ]] || _streams='>&1'
    [[ $_status == 0 ]] ||_name=False
    [[ $_name == True ]] || _streams="$_streams >&2"
    [[ $1 =~ -[Q] ]] && _streams=
    _message="$_name $_status $(face $_status)" 
    echo $_message $_streams
    [[ $_name == False ]] && return $_status
    true
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
