#! cat

# x

r () {
    rm -vrf "$@"
}


# xx

ri () {
    local _argc=${#*}
    if [[ $_argc == 1 ]]; then
        if [[ -d $1 ]]; then
            shoot
            read -p "rm -rf $1 [Y]" reply
            [[ $reply =~ (^$|[yY]) ]] && rm -rf "$1"
        fi
    else
        rr -i "$@"
    fi
}

shoot () {
    echo "You'll be shot for this"
    echo "Nah, I don't think so, more like chewed out. I been chewed out before"
}

rr () {
    local _shoot=
    if [[ $1 == '-i' ]]; then
        _shoot=2
        shift
    fi
    local _path=$(readlink -f "$@")
    [[ "$_path" == "/" ]] && return 1
    if [[ "$_path" == $(readlink -f $HOME) || "$@" == "$HOME" ]]; then
        _shoot=1
        echo "Scalp Herman"
        echo "Are you mad? What have you done? I made a deal with your general for that man's life!"
        echo "Yeah, they made that deal, but they don't give a fuck about him. They need you"
    fi
    if [[ -n $_shoot ]]; then
        shoot
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

