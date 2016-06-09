#! /bin/cat

SRC=; [[ -d $HOME/AlanSource ]] && SRC=$HOME/AlanSource; export SRC
      [[ -n $SRC && -d $HOME/src ]] && SRC=$HOME/src; export SRC
 HG=; [[ -d $SRC/hg   ]] &&  HG=$SRC/hg;   export HG
GIT=; [[ -d $SRC/git  ]] && GIT=$SRC/git;  export GIT
HUB=; [[ -d $GIT/hub  ]] && HUB=$GIT/hub;  export HUB
