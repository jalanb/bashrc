#! /bin/bash

OSX_HOME=/Users/jab
PROFILE="/$OSX_HOME/Library/Application Support/Firefox/Profiles/0r6wcrwt.default"
SOURCE="$PROFILE/jetpack/jid1-xUfzOsOFlzSOXg@jetpack/simple-storage/store.json"
DESTINATION_DIRECTORY=/Volumes/HD/$OSX_HOME/log
DESTINATION=$DESTINATION_DIRECTORY/store.json.$(/bin/date +%Y%m%d)
/bin/cp -v "$SOURCE" "$DESTINATION" > /$OSX_HOME/bin/save_profile.log 2>/Users/jab/bin/save_profile.err
find $DESTINATION_DIRECTORY -mtime +30 -delete
