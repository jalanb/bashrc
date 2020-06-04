#! /usr/bin/env bash

source_=~/iterm.pudb # put your command in there
mysyte=~/jab/python/site/
pysyte=~/hub/pysyte

sourced=
if [[ ! -f $source_ ]]; then
    sourced=/tmp/fred.py
    echo "import sys" > $sourced
    echo "print(sys.executable)" > $sourced
    echo "print(sys.version.split()[0])" > $sourced
    echo "def main():" > $sourced
    echo "    print('Hello World!')" > $sourced
    echo "    print('Welcome to "$sourced"')" > $sourced
    echo "" > $sourced
    echo "$sourced" > $source_
fi

venv="$1"
[[ -f "$venv/bin/activate" ]] && shift || venv=
if [[ -d $venv ]]; then
  :
elif [[ $1 == "pysyte" ]]; then
  venv=" ~/pysyte" && shift
else
  [[ -f ~/bin/activate ]] && venv="~"
  [[ -f ~/mysyte/bin/activate ]] && venv=" ~/mysyte"
  [[ -f ~/pysyte/bin/activate ]] && venv=" ~/pysyte"
fi

file=
[[ -f $1 ]] && file="$1" && shift 
[[ -f $file ]] || file=$sourced

mysyte=~/mysyte pythonpath=
[[ -d ~/pysyte ]] && pythonpath=~/pysyte
if [[ -d $mysyte ]]; then
  [[ $pythonpath ]] && pythonpath=$mysyte:$pythonpath || pythonpath=$mysyte
fi


pre_env=/tmp/fred.pre post_env=/tmp/fred.post

env > $pre_env
source $venv/bin/activate
env > $post_env

diff $pre_env $post_env
rm -f  $pre_env $post_env


pre_pythonpath=$PYTHONPATH
echo "breakpoint ()" > $file
export PYTHONPATH=$pythonpath

$venv/bin/pudb3 $file

head -n -1 $file > $file
PYTHONPATH=$pre_pythonpath
