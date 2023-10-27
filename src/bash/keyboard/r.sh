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

rg () {
    [[ "$@" ]] && c "$@"
    ranger
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

ru () {
    local __doc__="""do da root root route, do da ru !"""
    if [[ -z "$@" ]]; then
        SUDO
    else
        sudo "$@"
    fi
}

ry () {
    rf -qpr
}

# xxx

rfq () {
    rf -q "$@"
}

rlf () {
    if [[ ! "$@" ]]; then
        readlink -f .
        return 0
    fi
    local path_= rlf_path_= result_=1
    for path_ in "$@"; do
        rlf_path_=$(readlink -f "$path_")
        if [[ -e $rlf_path_ ]]; then
            echo $rlf_path_
            result_=0
        elif [[ $rlf_path_ ]]; then
            show_fail "$path_ (-> $rlf_path_) does not exist"
        else
            show_fail "$path_ (-> $(readlink $path_)) does not exist"
        fi
    done
    return $result_
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
