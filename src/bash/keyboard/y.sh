#! /bin/cat


# _
# x
# _x
# xx

y () {
    echo "$@"
}


ytscript () {
      local url_="${1:-$(pbpaste)}"
      [[ "$url_" =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/ ]] || {
          show_fail "Not a YouTube URL: $url_"
          return 1
      }
      claude -p "/ytube $url_ . Output only the path to the transcript, no commentary"  --dangerously-skip-permissions
}

ytdl () {
    local type_=
    [[ $1 =~ ^mp[34]$ ]] && type_=$1 || return 1
    shift
    local dir_="${HOME}/Downloads/yt-${type_}/"
    [[ $YOUTUBES ]] && dir_="${YOUTUBES}/${type_}/"
    local options_=" --no-check-certificate" 
    local ext_=none
    case $type_ in
        mp3) options_+=" --extract-audio --audio-format=mp3 --audio-quality=0"
            ext_=mp3
            ;;
        mp4) options_+="" 
            ext_=mp4
            ;;
    esac
    local output_="./%(title)s.$ext_"
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

# Slice-one workhorse: top 5 candidates, fast (no per-video page fetch)
yt_find_fast () {
    local artist_="$1"
    local venue_="$2"
    local date_="$3"
    local song_="$4"
    yt-dlp "ytsearch5: $artist_ $venue_ $date_ $song_" \
        --flat-playlist \
        --print "%(url)s | %(duration>%H:%M:%S)s | %(view_count)s | %(title)s"
    }

# Full metadata per candidate (slower — fetches each video page; gives
# upload_date, like_count, channel — the popularity-proxy fields for later slices)
yt_find_slow () {
    local artist_="$1"
    local venue_="$2"
    local date_="$3"
    local song_="$4"
    yt-dlp "ytsearch5: $artist_ $venue_ $date_ $song_" \
        --skip-download \
        --dump-json | \
            jq '{id, title, duration, view_count, like_count, channel, upload_date}'
}
