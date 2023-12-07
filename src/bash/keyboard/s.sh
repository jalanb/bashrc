#! /bin/cat


type whyp_source >/dev/null 2>&1 || source ~/hub/whyp/whyp.sh

# _
# x
s () {
    local __doc__="""s is for sourcing"""
    whyp_source "$@"
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

sp () {
    s ~/bash/prompt.sh "$@"
}

sx () {
    export PS4='+ [${BASH_SOURCE##*/}:${LINENO}]'
    set -x
}

sz () {
    set +x
    export PS4=
}

# _xx
# xxx

sai () {
    [[ -f /usr/bin/say ]] || return
    local _one=$1
    local _voices="-v Moira"
    if [[ $_one =~ ^v(oices*)*$ ]]; then
        shift
        local _two=$1; [[ -n $_two ]] && shift
        _voices="-v?";
        if [[ $_one == "voice" ]]; then
            _voices="-v $_two"
        elif [[ $_one == v ]]; then
            local _voice=
            [[ -n $_two ]] &&  _voice=$_two
            _voices="-v $_two"
        fi
    fi
    local _message="$@"
    local _dir=
    [[ -d $_message ]] && _dir=$_message && _message=
    [[ -d "$1" ]] && _dir="$1" && shift && _message="$@"
    [[ -d $_dir ]] && _dir=$(short_dir $_dir) || _dir=
    # From https://stackoverflow.com/a/31189843/500942
    ( { { /usr/bin/say $_voices $_dir $_message >&2; } 2>&3- & } 3>&2 2>/dev/null )
}

ses () {
    local _old="$1"; shift
    local _new="$1"; shift
    echo "$@" | sed -e "s:$_old:$_new:"
}

sib () {
    . ~/.bashrc
}

sla () {
    s $(aliases -l)
}

sgf () {
    s $(functons -g)
}

slf () {
    JAB_LOCAL_FUNCS= s $(functons -l)
}

sto () {
    firefox "http://stackoverflow.com/search?q=$*"
}

swf () {
    s $(functons -w)
}
