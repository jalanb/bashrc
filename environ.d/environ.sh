#! /bin/bash

_source_jab_environ () {
    EX_OK=0
    EX_BAD=1

    if [[ ! -d $JAB ]]; then
        source $JAB/environ.d/jab.sh
    fi

    export COLUMNS

    export EXITSTATUS="$?"
    export FIGNORE=.pyc:.swp:~:.o

    #export DISPLAY=:0

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
    export HISTIGNORE="bg:fg:history:gh:hh"
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
    # correct minor spelling errors for cd
    shopt -s cdspell
    #
    # some interesting paths
    #
    GIT_BUCKET=no_bucket; [[ -d ~/src/git/bucket ]] && GIT_BUCKET=~/src/git/bucket; export GIT_BUCKET
    HG_BUCKET=no_bucket; [[ -d ~/src/hg/bucket ]] && HG_BUCKET=~/src/hg/bucket; export HG_BUCKET
    BUCKET=no_bucket
    if [[ -d $HG_BUCKET ]]; then
        BUCKET=$HG_BUCKET
    elif [[ -d $GIT_BUCKET ]]; then
        BUCKET=$GIT_BUCKET
    fi
    export BUCKET
    if [[ -f /usr/local/bin/gls ]]; then
        export LS_PROGRAM=/usr/local/bin/gls
        DIRCOLORS=/usr/local/bin/gdircolors
    else
        export LS_PROGRAM=/bin/ls
        [[ -f /usr/bin/dircolors ]] && DIRCOLORS=/usr/bin/dircolors
    fi
    if $LS_PROGRAM -@ >/dev/null 2>&1; then
        export LS_COLOUR_OPTION='-@'
    elif $LS_PROGRAM --color=auto >/dev/null 2>&1; then
        export LS_COLOUR_OPTION='--color=auto'
    else
        export LS_COLOUR_OPTION=
    fi
    if $LS_PROGRAM --group-directories-first >/dev/null 2>&1; then
        export LS_DIRS_OPTION='--group-directories-first'
    else
        export LS_DIRS_OPTION=
    fi
    [[ -n $DIRCOLORS ]] && eval $($DIRCOLORS ~/.dir_colors | sed -e "s/setenv LS_COLORS /export LS_COLORS=/")
    OLD_PATH=$PATH
    if [[ -d $JAB ]]; then
        source $JAB/bin/add_to_a_path.sh
        PATH=
        add_to_a_path PATH $HOME/bin
        add_to_a_path PATH $JAB/bin
        add_to_a_path PATH $HOME/.local
        add_to_a_path PATH $HOME/.local/bin
        add_to_a_path PATH /usr/local/gnu
        add_to_a_path PATH /bin
        add_to_a_path PATH /usr/local/bin
        add_to_a_path PATH /usr/bin
        add_to_a_path PATH /usr/local/sbin
        add_to_a_path PATH $HOME/git/bin
        add_to_a_path PATH /opt/local/bin
        add_to_a_path PATH /sbin
        add_to_a_path PATH /usr/sbin
        add_to_a_path PATH /usr/local/go/bin
        export PATH
    else
        echo JAB is not a directory
    fi
    echo PATH is now
    echo $PATH | tr ':' '\n' | sed -e "s:/:      /:"
    export PS1

    #
    # Path dependencies
    #

    if [[ -x /usr/local/bin/which ]]; then
        export WHICH=/usr/local/bin/which
    else
        export WHICH=/usr/bin/which
    fi
    export EDITOR=vim
    export EMAIL="dotjab@al-got-rhythm.net"

    if [[ -d $JAB ]]; then
        source_path $JAB/environ.d/colour.sh
    fi

    RE_IP="\<\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\>"
    export LOG_LINES_ON_CD_GIT_DIR=7

    set -o vi
}

_source_jab_environ
