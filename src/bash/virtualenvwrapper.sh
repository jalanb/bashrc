#! /bin/cat


export WORKON_HOME=$HOME/.virtualenvs
export PYM_HOME=~/hub/pym
for vew_dir in /usr/local/bin $HOME/.local/bin; do
    vew_sh=$vew_dir/virtualenvwrapper.sh
    [[ -f $vew_sh ]] || continue
    . $vew_sh
    break
done


