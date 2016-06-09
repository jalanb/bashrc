#! env cat
# $ /Users/jab/Library/Python/2.7/bin/ptpython --help
# ptpython: Interactive Python shell.
# Usage:
#     ptpython [ --vi ]
#              [ --config-dir=<directory> ] [ --interactive=<filename> ]
#              [--] [ <arg>... ]
#     ptpython -h | --help
#
# Options:
#     --vi                         : Use Vi keybindings instead of Emacs bindings.
#     --config-dir=<directory>     : Pass config directory. By default '~/.ptpython/'.
#     -i, --interactive=<filename> : Start interactive shell after executing this file.
#
# Other environment variables:
# PYTHONSTARTUP: file executed on interactive startup (no default)

. $HUB/what/what.sh
. ~/jab/jab/local/environ.sh

pt () {
    local __doc__="function to run https://github.com/jonathanslenders/ptpython, if installed"
    local _ptpython=
    what -q ptpython && _ptpython=$(what -f ptpython)
    [[ -z $_ptpython && -e $PTPYTHON ]] && _ptpython=$PTPYTHON
    [[ $1 != hub && -z $_ptpython && -d $HUB/ptpython ]] && (cd $HUB/pypython; python setup.py install) && pt hub
    if [[ $1 == -h || $1 == --help ]]; then
        $_ptpython -h
        return $?
    fi
    PT_CONFIG_DIR=$HOME/.config/ptpython
    [[ -d $PT_CONFIG_DIR ]] || mkdir -p $PT_CONFIG_DIR
    $_ptpython \
        --vi \
        --config-dir=$PT_CONFIG_DIR \
        --interactive=~/jab/jab/src/python/ptpython.py \
        -- "$@"
}
