#!/bin/sh

git filter-branch --env-filter '
OLD_EMAIL="al-got-rhythm.net"
CORRECT_NAME="Alan Brogan"
CORRECT_EMAIL="abrogan@wwts.com"
if [[ $GIT_COMMITTER_EMAIL =~ rhythm ]]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [[ $GIT_AUTHOR_EMAIL =~ rhythm ]]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -f -- --branches --tags
