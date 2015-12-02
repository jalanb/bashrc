#! /bin/bash

SRC=; [[ -d $HOME/src ]] && SRC=$HOME/src; export SRC
GIT=; [[ -d $SRC/git ]] && GIT=$SRC/git; export GIT
HUB=; [[ -d $GIT/hub ]] && HUB=$GIT/hub; export HUB
