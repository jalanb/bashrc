#! /bin/cat

SHELL_SESSION_HISTORY=0

# x
# xx
# xxx
# xxxx
# xxxxx

vhist () {
    local __doc__="edit unplugged stuff from history"
    _tease_history | [[ -n $* ]] && vim - +/"$@"
}

# xxxxxx
# xxxxxxx
# xxxxxxxx
# xxxxxxxxx
# xxxxxxxxxx
# xxxxxxxxxxx
# xxxxxxxxxxxx
# xxxxxxxxxxxxx

_tease_history () {
    history "$@" | sed -e "s/^ *[0-9]*  //"  | grep -v "\<\(history\|[tg]h\)\>"
}

_strip_history () {
    local _grep=
    if [[ $1 =~ [g?/] ]]; then
        shift
        _grep="$1"; shift
        HISTTIMEFORMAT= _tease_history "$@" | grep $_grep
    else
        HISTTIMEFORMAT= _tease_history "$@"
    fi
}

# xxxxxxxxxxxxxx
# xxxxxxxxxxxxxxx

_history_commands () {
    _strip_history "$@" | \
        sed "s/^(//" | \     # remove leading (
        g -v '^["$!)-]' | \  # remove quotes, symbol use, history expansions, cd -
        cut -d' ' -f 1 | \   # take first word (command)
        sed -e "s/[);]$//" \ # remove trailing chars
            -e "s/^\(.\|..\)$//" | \    # remove small commands
        grep -v "^$" | \     # remove blank lines
        sort | uniq | \      # sort and get unique words
        # grep "=" | \         # find assignments
        # wc -l | \            # count
        cat                  # send to stdout
}

# xxxxxxxxxxxxxxxx

set_history_file () {
    # OK, let's try again - the HIST...SIZE variables should be set, but have no value
    # This is explained at https://stackoverflow.com/questions/9457233/unlimited-bash-history/19533853#19533853
    # and https://superuser.com/questions/479726/how-to-get-infinite-command-history-in-bash/479727#479727
    export HISTFILESIZE=
    export HISTSIZE=
    # Change the file location because certain bash sessions truncate .bash_history file upon close
    # http://stackoverflow.com/a/19533853/500942
    export HISTFILE=~/.bash_eternal_history
    # format history times
    export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
    # ignore some simple commands in history
    export HISTIGNORE="bg:fg:history:gh:hh:th:z:za:zg:zk:zl:zp:zv:zx:zva:zvv:zvvv:upset"
    #  remember multi-line commands
    shopt -s cmdhist
    # edit a failed history substitution (default just ignores them)
    shopt -s histreedit
    # edit history line before executing
    shopt -s histverify
    # save multi-line commands to history with "\n", not ":"
    shopt -s lithist
    # Make bash check its window size after a process completes
    shopt -s checkwinsize
    # append to the history file, don't overwrite it
    shopt -s histappend
}

[[ $HISTFILE =~ eternal ]] || set_history_file
