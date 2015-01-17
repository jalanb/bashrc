#! /bin/bash

[[ -f $JAB/jab_environ ]] && source $JAB/jab_environ || echo "Cannot find $JAB/environ" >&2

HOME_SSH=~/.ssh
HOME_ID=$HOME_SSH/id_rsa

authorize_jab ()
{
    KNOWN_KEYS=$HOME_SSH/authorized_keys
    test -f $HOME_ID || ssh-keygen -q -t rsa -N "" -f $LOCAL_STEM
    chmod 600 $KNOWN_KEYS
    if [ -f $KNOWN_KEYS ]
    then
        cat $JAB_PUB_ID >> $KNOWN_KEYS
    else
        cat $JAB_PUB_ID > $KNOWN_KEYS
    fi
}

change_modes ()
{
    sudo chmod 400 -R $JAB_SSH $HOME_SSH
    sudo chmod 700 -R $JAB_SSH/.svn
    chmod u+X $HOME_SSH $JAB_SSH

    chmod 400 $JAB_ID
    chmod 444 $JAB_PUB_ID

    chmod 400 $HOME_ID
    chmod 444 $HOME_ID.pub
}

change_modes
authorize_jab
