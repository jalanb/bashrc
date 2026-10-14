#! cat

. ~/bash/quietly.sh

# x

r () {
    [[ "$*" ]] && show_run_command rm -vrf "$@" || show_run_command ranger .
}

# xx

ra () {
    ranger "$@"
}

rd () {
    rf -d "$@"
}

rf () {
    $(python_command) ~/jab/src/python/rf.py "$@"
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

rj () {
    rg "$@" /opt/clones/github/jalanb
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
    local rr_home_=$(rlce $HOME) rr_one_=$(rlce "$1")
    if [[ "$rr_one_" == "$rr_home_" ]]; then
        echo "Will not remove $1" >&2
        return 1
    fi
    QUIETLY rm $options_ "$@"
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

rfr () {
    rf -r "$@"
}

rgj () {
    from_jalanb rg "$@"
}

rgy () {
    rg -t py "$@"
}

rgt () {
    rg -l "$@" | trin
}

rgyt () {
    rgy -l "$@" | grep -v -e test | trin
}

rlf () {
    if [[ ! "$@" ]]; then
        ls -d $(rlce .)
        return 0
    fi
    local path_= rlf_path_= result_=1
    for path_ in "$@"; do
        rlf_path_=$(rlce "$path_")
        if [[ -e $rlf_path_ ]]; then
            ls -d "$rlf_path_"
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
    local _opts='--canonicalize-existing'
    for path in "$@"; do
        [[ -e "$path" ]] || continue
        _result=0
        _opts='--canonicalize-existing'
        [[ -d "$path" ]] && _opts='-rf'
        rr $_opts "$path"
    done
    return $_result
}

rrr () {
    sudo rm -rf --preserve-root "$@" 2> ~/fd2
}

# xxxx

rfrr () {
    QUIETLY rf -rp "$@"
}

rovo () {
    acli rovodev "$@"
}

rr.. () {
    local here_=$(rlce .)
    cd ..
    rr "$here_"
}

# xxxxxxx

rlce () {
    readlink --canonicalize-existing "$@"
}
