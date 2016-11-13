#! cat

# x

r () {
    rm -vrf "$@"
}


# xx

ri () {
    rr -i "$@"
}

rr () {
    local _path=$(readlink -f "$@")
    [[ "$_path" == "/" ]] && return 1
    local _shoot=
    if [[ $1 == '-i' ]]; then
        _shoot=2
        shift
    fi
    if [[ "$_path" == $(readlink -f $HOME) || "$@" == "$HOME" ]]; then
        _shoot=1
        echo "Scalp Herman"
        echo "Are you mad? What have you done? I made a deal with your general for that man's life!"
        echo "Yeah, they made that deal, but they don't give a fuck about him. They need you"
    fi
    if [[ -z $_shoot ]]; then
        echo "You'll be shot for this"
        echo "Nah, I don't think so, more like chewed out. I been chewed out before"
        rm -rfi "$@"
    else
        rm -rf "$@"
    fi
}

# xxx

rrr () {
    # Scalp Hans too
    sudo rm -rf "$@" 2> /dev/null
}

