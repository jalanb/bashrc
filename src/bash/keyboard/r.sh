#! cat

# x

r () {
    [[ "$@" ]] && show_run_command rm -vrf "$@" || show_run_command ranger .
}

# xx

ra () {
    ranger "$@"
}

rd () {
    rf -d "$@"
}

rf () {
    python ~/jab/src/python/rf.py "$@"
}

ri () {
    local arg_=
    for arg_ in "$@"; do
        [[ -d "$arg_" ]] || continue
        echo "Landa: You'll be shot for $arg_"
        echo "Aldo: Nah, I don't think so, more like chewed out."
        echo "      I been chewed out before"
        echo
        break
    done
    rri "$@"
}


rr () {
    local options_="-rf"
    if [[ $1 =~ ^[-][rfv]+$ ]]; then
        options_=$1
        shift
    fi
    if [[ "$1" =~ ^/[^/]*$|^[./]*$|^$HOME[/]*$ ]]; then
        echo "Will not remove $1" >&2
        return 1
    fi
    local rr_home_=$(rr_path $HOME) rr_one_=$(rr_path "$1")
    if [[ "$rr_one_" == "$rr_home_" ]]; then
        echo "Will not remove $1" >&2
        return 1
    fi
    rm $options_ "$@" >/dev/null 2>&1
}

ry () {
    rf -qpr
}

# xxx

rfq () {
    rf -q "$@"
}

rlf () {
    local one_=
    for one_ in "$@"; do
        rlf_ "$one_"
    done
}

rlf_ () {
    local path_=. rlf_path_= suffix_=
    [[ $1 ]] && path_="$1"
    [[ $path_ ]] || return 1
    rlf_path_=$(readlink -f "$path_")
    if [[ -e $rlf_path_ ]]; then
        echo $rlf_path_
        return 0
    fi
    [[ $rlf_path_ ]] && path_=$rlf_path_
    show_fail "# '$path_' does not exist" >&2
    return 1
}

rlg () {
    green_line $(rlf "$@")
}

rlo () {
    rlg "$@"
    lo -tr "$@"
}

rlq () {
    quietly rlf "$@"
}

rr. () {
    rr ./*
}

rra () {
    rr ./* ./.* 2>&1 | grep -v 'cannot remove directory'
}

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
        rr $_opts "$path"
    done
    return $_result
}

rrr () {
    sudo rm -rf --preserve-root "$@" 2> ~/fd2
}

# xxxx

rr.. () {
    local here_=$(readlink -f .)
    cd ..
    rr "$here_"
}

# xxxxxxx

rr_path () {
    readlink -f "$1"
}
