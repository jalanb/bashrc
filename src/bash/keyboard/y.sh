#! /bin/cat


# _
# x
# _x
# xx

y () {
    echo "$@"
}


yt_download_mp3 () {
    local dir_="${1}"
    local url_="${2}"

    ( command cd "$dir_"
    local options_=" --no-check-certificate --extract-audio --audio-format=mp3 --audio-quality=0"
    local output_="./%(title)s.mp3"
    yt-dlp $options_ -o "$output_" "$url_" | grep -v Downloading
    pwd
    eza -1tr ./
    )
}

ytdl () {
    local type_=
    [[ $1 =~ ^mp[34]$ ]] && type_=$1 || return 1
    shift
    local dir_="${HOME}/Downloads/yt-${type_}/"
    [[ $YOUTUBES ]] && dir_="${YOUTUBES}/${type_}/"

    if [[ "$type_" == "mp3" ]]; then
        yt_download_mp3 "$dir_" "$@"
    else
        local options_=" --no-check-certificate"
        local ext_=mp4
        local output_="./%(title)s.$ext_"
        ( command cd "$dir_"
        [[ "$@" ]] && yt-dlp $options_ -o "$output_" "$@" | grep -v Downloading
        pwd
        eza -1tr ./
        )
    fi
}

YOUTUBES=/Users/jab/youtubes

ytmp3 () {
    local url_="${1}"
    if [[ "$url_" =~ \?.*list= ]] || [[ "$url_" =~ \&list= ]]; then
        yt_album "$@"
    else
        ytdl mp3 "$@"
    fi
}

yt_album () {
    local url_="${1}"
    local base_dir_="${YOUTUBES}/mp3/"

    local playlist_meta_
    playlist_meta_=$(yt-dlp --dump-json --flat-playlist "$url_" 2>/dev/null)

    if [[ -z "$playlist_meta_" ]]; then
        show_fail "Failed to fetch playlist metadata"
        return 1
    fi

    local album_name_
    album_name_=$(echo "$playlist_meta_" | jq -r '.playlist_title // empty' 2>/dev/null)

    if [[ -z "$album_name_" ]]; then
        show_fail "Could not extract playlist title"
        return 1
    fi

    local sanitized_
    sanitized_=$(echo "$album_name_" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_')

    local dir_name_
    read -p "Album? [$sanitized_] " dir_name_
    [[ -z "$dir_name_" ]] && dir_name_="$sanitized_"

    local album_dir_="${base_dir_}${dir_name_}/"
    mkdir -p "$album_dir_"

    yt_download_mp3 "$album_dir_" "$url_"
}

ytmp4 () {
   ytdl mp4 "$@"
}
