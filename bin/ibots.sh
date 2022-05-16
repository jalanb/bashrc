#! /usr/bin/env bash

hash -d python3 ipython3

pip_upgrade () {
    python3 -m pip install --index-url=https://pypi.wwts.com --upgrade --no-deps "$@" | grep -v -e already -e Looking -e [uU]ninstall -e [cC]ached -e [cC]ollecting
}

main () {
    local clone_=~/bots/bots/iterm
    cd $clone_
    git checkout -q __main__ 
    git pull -q --rebase | grep -v Already
    source .venv/bin/activate
    pip_upgrade pip
    pip_upgrade pysyte
    pip_upgrade -r requirements/development.txt
    export PYTHONHTTPSVERIFY=0
    export TERM=xterm-256color
    PATH=$clone_/.venv/bin:/usr/local/gnu:/usr/local/bin:/Users/jab/bin:/Users/jab/jab/bin:/Users/jab/.local:/bin:/usr/bin \
      PYTHONPATH=. \
      .venv/bin/ipython3 \
        --profile=bots \
        --no-confirm-exit
}

main
