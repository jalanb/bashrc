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

_chewed="I been chewed out before"

chew () {
    echo "Landa: You'll be shot for this"
    echo "Aldo: Nah, I don't think so, more like chewed out. $_chewed"
}

chewed_rri () {
    [[ -d "$2" || -d "$1" ]] && (
        chew
    )
    rri "$@"
}


scalp_hermann () {
    (
    echo "Landa: Are you mad? What have you done? I made a deal with your general for that man's life!"
    echo ""
    echo "Aldo: Yeah, they made that deal, but they don't give a fuck about him. They need you"
    ) 
}

rr_path () {
    test -e "$1" && readlink -f "$1" || realpath "$1"
}

rr () {
    if [[ "$1" =~ ^/[^/]*$|^[./]*$|^$HOME[/]*$ ]]; then
        echo "Will not remove $1" >&2
        return 1
    fi
    local rr_home_=$(rr_path $HOME) rr_one_=$(rr_path "$1")
    if [[ $(rr_path "$1") == "$rr_home_" ]]; then
        echo "Will not remove $1" >&2
        return 1
    fi
    r "$@" >/dev/null 2>&1
}

old_rr () {
    local _interactive= _path= _options=
    if [[ "$1" == '-i' ]]; then
        _interactive=1
        shift
    fi
    if [[ "$1" =~ ^/[^/]*$|^[./]*$|^$HOME[/]*$ ]]; then
        echo "Will not remove $1" >&2
        return 1
    fi
    local rr_home_=$(rr_path $HOME) rr_all_=$(rr_path "$@")
    if [[ $rr_all_ == "$rr_home_" ]]; then
        scalp_hermann 
        return 1
    fi
    for p in "$@"; do
        if [[ "$p" == "/" ]];  then
            echo $_chewed
            return
        fi
        if [[ -e "$p" ]]; then
            _paths="${_paths}${_sep}${p}"
            _path=$(rr_path "$p")
            [[ -e "$_path" ]] || continue
            if [[ "$_path" == "$rr_home_" ]]; then
                scalp_hermann
            fi
            [[ -d "$_path" ]] && _options='-r'
            if [[ -n $_interactive ]]; then
                chewed_rri $_options "$_path"
            else
                rm -f $_options "$p"
            fi
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
    sudo rm -rf "$@" 2> ~/fd2
}
