#! /bin/bash

_show_home () {
    local _home=$1
    [[ $HOME == $_home ]] && return 0
    [[ -n $HOME ]] || echo \$HOME was $HOME
    if [[ ! -d $_home ]]; then
        echo $_home is not a directory >& 2
        return 1
    fi
    echo $HOME
}

_osx_home=$(_show_home /Users/jab)
PROFILE="$HOME/Library/Application Support/Firefox/Profiles/0r6wcrwt.default"
. ~/jab/local/profile.sh optional
SOURCE="$PROFILE/jetpack/jid1-xUfzOsOFlzSOXg@jetpack/simple-storage/store.json"
DESTINATION_DIRECTORY=/Volumes/HD$_osx_home/log
DESTINATION=$DESTINATION_DIRECTORY/store.json.$(/bin/date +%Y%m%d)
/bin/cp -v "$SOURCE" "$DESTINATION" > $DESTINATION_DIRECTORY/save_profile.log 2>$DESTINATION_DIRECTORY/save_profile.err
find $DESTINATION_DIRECTORY -mtime +30 -delete
