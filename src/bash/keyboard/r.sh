#! cat

# x

r () {
    [[ -z "$@" ]] && ra . || rm -vrf "$@"
}


# xx

ri () {
    local _argc=${#*}
    if [[ $_argc == 1 ]]; then
        [[ -d "$1" ]] && chewed_rri "$1"
    else
        rri "$@"
    fi
}

chewed_rri () {
    [[ -d "$2" || -d "$1" ]] && (
        echo "You'll be shot for this"
        echo "Nah, I don't think so, more like chewed out. I been chewed out before"
    )
    rri "$@"
}


scalp_hermann () {
    echo "Are you mad? What have you done? I made a deal with your general for that man's life!"
    echo ""
    echo "Yeah, they made that deal, but they don't give a fuck about him. They need you"
}

rr () {
    local _interactive=
    if [[ $1 == '-i' ]]; then
        _interactive=1
        shift
    fi
    local _real_home=$(real_path $HOME)
    if [[ $(real_path "$@") == "$_real_home" ]]; then
        scalp_hermann
        return 1
    fi
    local _punchline=
    local _paths=
    local _sep=
    for p in "$@"; do
        if [[ "$p" == "/" ]];  then
            _punchline="I been chewed out before"
            continue
        fi
        if [[ -e $p ]]; then
            _paths="${_paths}${_sep}${p}"
            _sep=' '
            _punchline=
        fi
    done
    if [[ -n $_punchline ]]; then
        echo $_punchline
        return 1
    fi
    for p in $_paths; do
        local _path=$(real_path "$p")
        if [[ "$_path" == $(real_path $HOME) ]]; then
            scalp_hermann
        fi
        local _options=
        [[ -d $_path ]] && _options='-r'
        if [[ -n $_interactive ]]; then
            chewed_rri $_options $_path
        elif [[ -e $_path ]]; then
            rm -f $_options $_path
        fi
    done
}

# xxx

rri () {
    read -n1 -p "rm $@ [Y]" reply
    [[ $reply =~ [qQ] ]] && return 1
    [[ $reply =~ (^$|[yY]) ]] || return 0
    local _result=1
    local _opts='-f'
    for path in "$@"; do
        [[ -e "$path" ]] || continue
        _result=0
        _opts='-f'
        [[ -d "$path" ]] && _opts='-rf'
        rm $_opts "$path"
    done
    return $_result
}

rrr () {
    # Scalp Hans too
    sudo rm -rf "$@" 2> /dev/null
}

real_path () {
    python3 -c "from os import path; print(path.realpath(path.expanduser('"$1"')))"
}
