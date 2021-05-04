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
    [[ $? == 0 ]] && return $? || eff $?
    local __doc__="""fail fast, or show angrier faces"""
}

et () {
    [[ $? == 0 ]] && ett $? || return $?
    local __doc__="""show a happy face :-) Or let the other ones out"""
}

quietly unalias eg
eg () {
    env | gr "$@"
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
    local name_=Pass out_=1 err_=1
    [[ $1 ]] && _status=$1 && shift
    [[ $_status == 0 ]] || name_=Fail
    [[ $name_ == Fail ]] && out_=
    [[ $name_ == Pass ]] && err_=
    [[ $1 =~ -[qQ] ]] && out_=
    [[ $1 =~ -[Q] ]] && err_=
    _message="$name_ $_status $(face $_status)" 
    if [[ $name_ == Pass ]]; then
        [[ $out_ ]] && echo $_message
    elif [[ $name_ == Fail ]]; then
        [[ $err_ ]] && echo $_message >&2
    fi
    [[ $name_ == Fail ]] && return $_status
    return 0
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
