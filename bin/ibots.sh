#! /usr/bin/env bash

hash -d python3 ipython3

extra () {
    local wwts_="https://pypi.wwts.com"
    local extra_="--extra-index-url=$wwts_"
    curl -s --head  --request GET $wwts_ >/dev/null 2>&1 && echo "--extra-index-url=$wwts_"
}

pip_upgrade () {
    python3 -m pip install -v $(extra) --upgrade "$@" | grep -v \
        -e already \
        -e Looking \
        -e [uU]ninstall \
        -e [cC]ached \
        -e [cC]ollecting \
        -e build \
        -e Removing.file \
        -e changing.mode \
        -e Found.existing 
}

main () {
    local clone_=~/bots/iterm
    cd $clone_
    echo "cd $clone_"
    echo Updating git
    git checkout -q __main__
    git pull -q --rebase | grep -v Already
    source .venv/bin/activate
    echo Upgrading pip packages
    pip_upgrade pip pysyte
    [[ $(extra) ]] || /usr/bin/sed --in-place --expression="/wwts.com/d" requirements/requirements.txt
    echo Upgrading developer requirements
    pip_upgrade -r requirements/development.txt
    [[ $(extra) ]] || git restore requirements/

    export PYTHONHTTPSVERIFY=0
    export TERM=xterm-256color
    PATH=$clone_/.venv/bin:/usr/local/gnu:/usr/local/bin:/Users/jab/bin:/Users/jab/jab/bin:/Users/jab/.local:/bin:/usr/bin \
      PYTHONPATH=. \
      .venv/bin/ipython3 \
        --profile=ibots \
        --no-confirm-exit
}

main
