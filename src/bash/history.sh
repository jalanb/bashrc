#! /bin/cat


# x
# xx


gh () {
    local __doc__="show stuff from history"
    _strip_history | grep --color "$@"
}

vh () {
    local __doc__="edit stuff from history"
    if [[ -n $* ]]; then
        _strip_history | vim - +/"$@"
    else
        _strip_history | vim - +
    fi
}

# xxx
# xxxx
# xxxxx

vhist () {
    local __doc__="edit unplugged stuff from history"
    _tease_history | [[ -n $* ]] && vim - +/"$@"
}

# xxxxxx
# xxxxxxx
# xxxxxxxx
# xxxxxxxxx
# xxxxxxxxxx
# xxxxxxxxxxx
# xxxxxxxxxxxx
# xxxxxxxxxxxxx

_tease_history () {
    history | sed -e "s/^ *[0-9]*  //"  | grep -v "\<\(history\|gh\)\>"
}

_strip_history () {
    HISTTIMEFORMAT= _tease_history "$@"
}
