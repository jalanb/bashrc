#! /bin/cat


# _
# x
# _x
# xx

y () {
    echo "$@"
}

yt () {
    local _dir=~/Downloads/yt-dlp/
    if [[ -d "$1" ]]; then
        _dir="$1"
        shift
    elif [[ -d "$_dir/$1" ]]; then
        _dir="$_dir/$1"
        shift
    fi
    local _options=" --no-check-certificates --extract-audio --audio-format=mp3 --audio-quality=0 "
    ( cd $_dir
    [[ "$@" ]] && yt-dlp $_options "$@"
    pwd
    ll -htr .
    )
}
