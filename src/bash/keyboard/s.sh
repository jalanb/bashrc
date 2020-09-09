#! /bin/cat


source ~/hub/whyp/whyp.sh

# _
# x
s () {
    local __doc__="""s is for sourcing"""
    . "$@"
}

# _x
# xx
sa () {
    s $(aliases)
}

sb () {
    s ~/bash/__init__.sh
}

sf () {
    s $(functons)
}

sp () {
    source ~/bash/prompt.sh
}

sq () {
    . $GIT_BUCKET/qaz/src/bash/qazrc
}

sx () {
    export PS4='+ [${BASH_SOURCE##*/}:${LINENO}]'
    set -x
}

sz () {
    set +x
    export PS4=
}

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
    local _options=" --no-check-certificate --extract-audio --audio-format=mp3 --audio-quality=0 "
    ( cd $_dir
    [[ "$@" ]] && youtube-dl $_options "$@"
    pwd
    ll -htr
    )
}

# _xx
# xxx

sla () {
    s $(aliases -l)
}

sgf () {
    s $(functons -g)
}

slf () {
    JAB_LOCAL_FUNCS= s $(functons -l)
}

swf () {
    s $(functons -w)
}
