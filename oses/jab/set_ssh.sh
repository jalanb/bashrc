#! /bin/bash

. ~/jab/environ.d/jab.sh optional

HOME_SSH=~/.ssh
JAB_SSH=~/jab/etc/ssh
HOME_ID=$HOME_SSH/id_rsa

authorize_jab () {
    KNOWN_KEYS=$HOME_SSH/authorized_keys
    [[ -f "$HOME_ID" ]] || ssh-keygen -q -t rsa -N "" -f $HOME_ID
    chmod 600 $KNOWN_KEYS
    [[ -f "$KNOWN_KEYS" ]] && cat $JAB_ID.pub >> $KNOWN_KEYS || cat $JAB_ID.pub > $KNOWN_KEYS
}

change_modes () {
    sudo chmod 400 -R ~/jab/etc/ssh $HOME_SSH
    chmod u+X $HOME_SSH ~/jab/etc/ssh

    chmod 400 $JAB_ID
    chmod 444 $JAB_ID.pub

    chmod 400 $HOME_ID
    chmod 444 $HOME_ID.pub
}

change_modes
authorize_jab
