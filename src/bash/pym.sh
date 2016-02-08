#! env cat
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

. $HUB/what/what.sh
. $JAB/local/environ.sh

workon_pym () {
    [[ ! $VIRTUAL_ENV =~ /pym$ ]] && workon pym
    hub pym pym "$@"
}

pyi () {
    cd $HUB/pym/pym
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

pym ()
{
    local __doc__="function to run https://github.com/jalanb/pym, if installed"
    local _pym=
    what -q pym && _pym=$(what -f pym)
    [[ -z $_pym && -e $pym ]] && _pym=$pym
    [[ $1 != hub && -z $_pym && -f $HUB/pym/setup.py ]] && (cd $HUB/pym; python setup.py install)
    if [[ $1 == -h ]]; then
        $_pym -h
        return $?
    elif [[ $1 == --help ]]; then
        $_pym --help
        return $?
    fi
    $_pym \
        --vi \
        --config-dir=$JAB/etc \
        --interactive=$JAB/src/python/pym.py \
        -- "$@"
}
