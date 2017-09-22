#! env cat

Welcome_to $BASH_SOURCE
#
# $ /Users/jab/Library/Python/2.7/bin/ptpython --help
# pym: Interactive Python shell.
# Usage:
#     pym [ --vi ]
#              [ --config-dir=<directory> ] [ --interactive=<filename> ]
#              [--] [ <arg>... ]
#     pym -h | --help
#
# Options:
#     --vi                         : Use Vi keybindings instead of Emacs bindings.
#     --config-dir=<directory>     : Pass config directory. By default '~/.pym/'.
#     -i, --interactive=<filename> : Start interactive shell after executing this file.
#
# Other environment variables:
# PYTHONSTARTUP: file executed on interactive startup (no default)

. ~/jab/local/environ.sh optional

workon_pym () {
    [[ $VIRTUAL_ENV =~ /pym$ ]] || workon pym
    hub pym pym "$@"
}

pyi () {
    cd ~/hub/pym/pym
    add_to_a_path PATH ./bin
    add_to_a_path PYTHONPATH ./pym
    source ~/.virtualenvs/pym/bin/activate
    if [[ -n $* ]]; then
        if shift_dir "$@"; then
            shift
            cd $dir
        fi
    fi
    2
    pwd
    local _status=$(git status -s)
    if [[ -n $_status ]]; then
        echo -n "\$ git status -s: "
        git status -s
    else
        local has_dirs=
        for item in $(ls)
        do
            if [[ -d "$item" ]]; then
                has_dirs=1
                break
            fi
        done
        if [[ $has_dirs == 1 ]]; then
            3y -L 2 --noreport . | grep -v -e bdist.linux-x86_64 -e " _build$" -e __init__.py -e .egg-info
        fi
        echo
    fi
    if [[ -n $(ls *.py | grep -v __init__.py 2>/dev/null) ]]; then ly -q
    elif [[ -n $(ls * | grep -v __init__.py) ]]; then lk
    fi
    echo
    [[ -n $* ]] && "$@"
}

pym () {
    local __doc__="function to run https://github.com/jalanb/pym, if installed"
    [[ $VIRTUAL_ENV =~ /pym$ ]] || workon pym
    local _pym=~/hub/pym/pym/reply/main.py
    if [[ ! -f $_pym ]]; then
        echo $_pym is not a file >&2
        return 1
    fi
    if [[ $1 == -h ]]; then
        python $_pym -h
        return $?
    elif [[ $1 == --help ]]; then
        python $_pym --help
        return $?
    fi
    PYM_CONFIG_DIR=$HOME/.config/pym
    [[ -d $PYM_CONFIG_DIR ]] || mkdir -p $PYM_CONFIG_DIR
    python $_pym \
        --config-dir=$PYM_CONFIG_DIR \
        --interactive=~/jab/src/python/pym.py \
        -- "$@"
}

Bye_from $BASH_SOURCE
