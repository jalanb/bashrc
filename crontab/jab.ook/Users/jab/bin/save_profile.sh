#! /bin/bash

JAB=Users/jab
PROFILE="/$JAB/Library/Application Support/Firefox/Profiles/0r6wcrwt.default"
SOURCE="$PROFILE/jetpack/jid1-xUfzOsOFlzSOXg@jetpack/simple-storage/store.json"
DESTINATION_DIRECTORY=/Volumes/HD/$JAB/log
DESTINATION=$DESTINATION_DIRECTORY/store.json.$(/bin/date +%Y%m%d)
/bin/cp -v "$SOURCE" "$DESTINATION" > /$JAB/bin/save_profile.log 2>/Users/jab/bin/save_profile.err
find $DESTINATION_DIRECTORY -mtime +30 -delete
