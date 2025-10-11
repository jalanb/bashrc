#! /bin/cat


# _
# x
# _x
# xx

y () {
    echo "$@"
}


ytdl () {
    local type_=
    [[ $1 =~ ^mp[34]$ ]] && type_=$1 || return 1
    shift
    local dir_="${HOME}/Downloads/yt-${type_}/"
    [[ $YOUTUBES ]] && dir_="${YOUTUBES}/${type_}/"
    local options_=" --no-check-certificate"
    local output_=
    case $type_ in
        mp3) options_+=" --extract-audio --audio-format=mp3 --audio-quality=0"
            output_="%(uploader)s/%(upload_date>%Y)s/%(upload_date>%m)s/%(title)s.%(ext)s"
            ;;
        mp4) options_+="" 
            output_="./%(title)s.mp4"
            ;;
    esac
    ( command cd $dir_
    [[ "$@" ]] && yt-dlp $options_ -o "$output_" "$@" | grep -v Downloading
    pwd
    eza -1tr ./
    )
}

YOUTUBES=/Users/jab/youtubes

ytmp3 () {
   ytdl mp3 "$@"
}

ytmp4 () {
   ytdl mp4 "$@"
}
