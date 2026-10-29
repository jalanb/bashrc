#! /usr/bin/env bash

yttxt () {
    local url_="${1:?Usage: yttxt URL [CREATOR [TITLE]]}";
    local creator_="${2:-}" title_="${3:-}";
    local base_="${TUBES_TRANSCRIPTS:-/opt/clones/github/jalanb/Claude/Projects/Tubes/data/transcripts}";

    local meta_;
    meta_=$(yt-dlp --no-playlist --print "%(uploader)s" --print "%(title)s" "$url_" 2>/dev/null);
    [[ -z "$creator_" ]] && creator_="${meta_%%$'\n'*}";
    [[ -z "$title_"   ]] && title_="${meta_##*$'\n'}";

    creator_=$(printf '%s' "$creator_" | tr -d '<>:"/\\|?*');
    title_=$(printf '%s'   "$title_"   | tr -d '<>:"/\\|?*');

    local out_="${base_}/${creator_}/${title_}.md";
    mkdir -p "${base_}/${creator_}";

    local tmp_;
    tmp_=$(mktemp -d);

    yt-dlp --no-check-certificate \
           --write-auto-sub --sub-lang en \
           --skip-download --convert-subs vtt \
           --no-playlist -o "${tmp_}/%(id)s.%(ext)s" "$url_" >/dev/null;

    local vtt_;
    vtt_=$(find  "${tmp_}" -name="*.vtt" -print 2>/dev/null | head -1);

    if [[ -z "$vtt_" ]]; then
        rm -rf "$tmp_";
        echo "yttxt: no subtitles for $url_" >&2;
        return 1;
    fi;

    {   printf '# %s\n\n**Creator:** %s  \n**URL:** %s\n\n---\n\n' \
            "$title_" "$creator_" "$url_";
        python3 - "$vtt_" <<'PYEOF'
import re, sys
last = None
for line in open(sys.argv[1]):
    line = re.sub(r'<[^>]+>', '', line).strip()
    if not line or re.match(r'WEBVTT|^\d{2}:\d{2}|^\d+$', line):
        continue
    if line != last:
        print(line)
        last = line
PYEOF
    } > "$out_";

    rm -rf "$tmp_";
    echo "Saved: $out_";
}

