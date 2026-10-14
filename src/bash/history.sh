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
    # Update: Since bash 4.3 blank values here suppress history
    # These should be set to negative values instead to always work
    # This is explained at https://stackoverflow.com/questions/9457233/unlimited-bash-history#12234989
    export HISTFILESIZE=-1
    export HISTSIZE=-1
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

big_history_grep () {
    local number_=32
    if [[ $1 == "-n" && $2 =~ ^[0-9]*$ ]]; then
        number_=$2
        shift 2
    fi
    grep "$@" ~/.b*history | tail -n $number_ | sed -e "s,[^:]*:,," | grep --color "$@"
}

history_grep () {
    local __doc__="grep in history"
    [[ $1 =~ (-h|--help) ]] && ww history_grep && return 0
    local back_= date_=
    [[ $1 =~ -B[0-9] ]] && back_=$1 && shift
    [[ $1 =~ -d ]] && date_=--date && shift
    local sought_="$@"
    history_read $date_ | sed -es':^ *::' -e 's: *$::' | grep --color $back_ "${sought_/ /.}"
}

history_read () {
    local history_command_="^history\(_[a-z-]*\)*" history_search_="^[Hh][Gghnt]" h_command="^h [0-9][0-9]*$"
    local history_log_="-e $history_command_ -e $history_search_ -e $h_command"
    local format_=
    if [[ $1 =~ [-]+d[ate]* ]]; then
        shift
        format_="%Y/%m/%d:%H:%M:%S "
    fi
    HISTTIMEFORMAT="$format_" history "$@" | sed -e "s/^ *[0-9]*  //"  | grep -v "$history_log_"
}

history_view () {
    local __doc__="view history"
    local viewer_=
    type_executable "$1" && viewer_="$1"
    [[ $viewer_ ]] && shift || viewer_="tail"
    local lines_="-n $(( LINES - 8 ))"
    if [[ $1 =~ ^[0-9] ]]; then
        lines_="-n $1"
        shift
    elif [[ $1 =~ ^- ]]; then
        if [[ $1 == -n ]]; then
            shift
            lines_="-n $1"
            shift
        elif [[ $1 =~ ^-[0-9] ]]; then
            lines_="-n ${1#-}"
            shift
        fi
    fi
    history_read "$@" | "$viewer_" "$lines_"
}

history_vim () {
    local __doc__="edit history"
    local tmp_=~/tmp/history.tmp historian_= 
    [[ $1 == -[ ]] && shift && historian_="history -p !-$1" && shift
    [[ $1 == -h ]] && shift && historian_=h
    [[ $historian_ ]] || historian_=history_read
    $historian_ "$@" > $tmp_
    local vim_suffix_=+
    if [[ -n $* ]]; then
        [[ "$@" =~ ^+ ]] && vim_suffix_="$@" || vim_suffix_=+/"$@"
    fi
    vim $tmp_ $vim_suffix_
}

[[ $HISTFILE =~ eternal ]] || set_history_file
