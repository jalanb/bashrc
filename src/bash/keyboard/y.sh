#! /bin/cat


# _
# x
# _x
# xx

alias y=echo


yt () {
    # -o ~/Downloads/youtube.dl/%(artist)s-%(album)s-%(release_year)s-%(track)s.mp3"
    local _dir=~/Downloads/youtube.dl
    if [[ -d "$1" ]]; then
        _dir="$1"
        shift
    elif [[ -d "$_dir/$1" ]]; then
        _dir="$_dir/$1"
        shift
    fi
    local _options=" --no-check-certificates --extract-audio --audio-format=mp3 --audio-quality=0 "
    ( cd $_dir
    [[ "$@" ]] && yt-dl $_options "$@"
    pwd
    ll -htr .
    )
}
