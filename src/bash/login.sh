
test -d ~/.local_login.sh && source ~/.local_login.sh

echo HOSTNAME, $(hostname -f)
SRC=~/src
GIT=$SRC/git
HUB=$GIT/hub
GITHUB=$HUB
source $HUB/what/what.sh
source_what $HUB/kd/kd.sh

JAB=$HUB/dotjab
source_what $JAB/src/bash/require.sh
require $JAB/src/bash/functons.sh
require $JAB/environ.d/environ.sh
require $JAB/environ.d/python.sh
require $HUB/ack2vim/ack2vim
require $JAB/src/bash/aliases.sh
require $JAB/local/functons.sh
export PS1="\$? [\u@\H:\$PWD]\n$ "
sp

echo JAB, $JAB

jj
