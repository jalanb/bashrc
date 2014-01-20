#! /bin/bash

JAB=${JAB:-$HOME/.jab}
JAB_SSH=$JAB/ssh
JAB_STEM=$JAB_SSH/id_jab
JAB_KEY=${JAB_STEM}.pub
LOCAL_SSH=~/.ssh
LOCAL_STEM=$LOCAL_SSH/id_rsa
KNOWN_KEYS=$LOCAL_SSH/authorized_keys

test -f $LOCAL_STEM || ssh-keygen -q -t rsa -N "" -f $LOCAL_STEM
chmod 600 $KNOWN_KEYS
if [ -f $KNOWN_KEYS ]
then
	cat $JAB_KEY >> $KNOWN_KEYS
else
	cat $JAB_KEY > $KNOWN_KEYS
fi
sudo chmod 400 -R $JAB_SSH $LOCAL_SSH
sudo chmod 700 -R $JAB_SSH/.svn
chmod u+X $LOCAL_SSH $JAB_SSH
chmod 400 $JAB_STEM
chmod 400 $LOCAL_STEM
chmod 444 $JAB_STEM.pub
chmod 444 $LOCAL_STEM.pub
