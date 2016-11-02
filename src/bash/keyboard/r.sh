#! cat

# x

r () {
    rm -vrf "$@"
}


# xx

rr () {
    local _path=$(readlink -f "$@")
    [[ "$_path" == "/" ]] && return 1
    local _home=$(readlink -f $HOME)
    if [[ "$_path" == "$_home" || "$@" == "$HOME"]]; then
        echo "Scalp Herman"
        echo "Are you mad? What have you done? I made a deal with your general for that man's life!"
        echo "Yeah, they made that deal, but they don't give a fuck about him. They need you"
        echo "You'll be shot for this"
        echo "Nah, I don't think so, more like chewed out. I been chewed out before"
        rm -rfi "$@"
    else
        rm -rf "$@"
    fi
}

# xxx

rrr () {
    sudo rm -rf "$@" 2> /dev/null
}

