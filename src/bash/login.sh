
test -d ~/.local_login.sh && source ~/.local_login.sh

echo HOSTNAME, $(hostname -f)
SRC=~/src
GIT=$SRC/git
HUB=$GIT/hub
JAB=$HUB/jab
[[ -e $JAB ]] || JAB=$HUB/dotjab
[[ -e $JAB ]] || JAB=~/.jab
if [[ -d $JAB ]]; then
    . $JAB/src/bash/require.sh
    require $JAB/src/bash/functons.sh
    require $JAB/src/bash/prompt.sh
    require $JAB/environ.d/environ.sh
    require $JAB/environ.d/python.sh
    require $HUB/ack2vim/ack2vim
    require $JAB/src/bash/aliases.sh
    require $JAB/local/functons.sh
    require $HUB/kd/kd.sh
    export PS1="\$? [\u@\H:\$PWD]\n$ "
    sp

    echo JAB, $JAB

    jj
else
    ls -l $JAB
fi
