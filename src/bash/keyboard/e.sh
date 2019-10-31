#! /bin/cat

Welcome_to $BASH_SOURCE

# _
# x
# _x
# xx

ef () {
    [[ $? == 0 ]] && return
    local _status=$?
    local _faces=(👿  👎  💀  👻  💩  🤨   😐  😑  😥  😮  😫  😲  ☹️  😤  😢  😭  😦  😧  😨  😩  🤯   😬  😰  😱  🥵   🥶   😳  🤢  🤮)
    local _out=False
    [[ $_status == 1 ]] || _out="False $_status ${_faces[$_status]}"
    echo $_out >&2
}

quietly unalias eg
eg () {
    env | g "$@"
}

er () {
    local _status=$?
    local _faces=(😎 👿  👎  💀  👻  💩  🤨   😐  😑  😥  😮  😫  😲  ☹️  😤  😢  😭  😦  😧  😨  😩  🤯   😬  😰  😱  🥵   🥶   😳  🤢  🤮)
    local _face=${_faces[$_status]}
    local _name="True"
    [[ $_status == 0 ]] || _name="False"
    echo "$_status $_name $_face"
}

et () {
    [[ $? == 0 ]] || return
    local _status=0
    local _statout=
    local _faces=(😎)
    local _out=True
    _out="True $$_status ${_faces[$_status]}"
    echo $_out >&1
}

# _xx
# xxx

err () {
    "$@" >/dev/null 2>&1
    er
}
