
test -d ~/.local_login.sh && source ~/.local_login.sh

echo HOSTNAME, $(hostname -f)
SRC=~/src
GIT=$SRC/git
HUB=$GIT/hub
GITHUB=$HUB
source $HUB/what/what.sh
require $HUB/what/what.sh

require $HUB/kd/kd.sh
KDDIR=$HUB/kd
KD=$KDDIR/kd.sh
JAB=$HUB/dotjab
require $JAB/src/bash/functons.sh
require $JAB/environ.d/environ.sh
require $HUB/ack2vim/ack2vim
require $JAB/src/bash/aliases.sh
require $JAB/local/functons.sh
export PS1="\$? [\u@\H:\$PWD]\n$ "
export PYTHONPATH=$JAB/src/python/site:$PYTHONPATH
sp

echo JAB, $JAB

jj
