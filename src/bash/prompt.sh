#! /bin/cat -n

Welcome_to $BASH_SOURCE


export PROMPT_COLOUR=none
if [[ "$1" == "green" ]]; then
    export PROMPT_COLOUR="$GREEN"
    export PROMPT_OPPOSITE_COLOUR="$MAGENTA"
elif [[ "$1" == "red" ]]; then
    export PROMPT_COLOUR="$RED"
    export PROMPT_OPPOSITE_COLOUR="$CYAN"
elif [[ "$1" == "blue" ]]; then
    export PROMPT_COLOUR="$LIGHT_BLUE"
    export PROMPT_OPPOSITE_COLOUR="$YELLOW"
else
    export PROMPT_COLOUR="$GREEN"
    export PROMPT_OPPOSITE_COLOUR="$MAGENTA"
fi

changes=0

get_repo_status () {
    PYTHON=${PYTHON:-mython}
    GIT_BRANCH=
    if git branch > /dev/null 2>&1; then
        if git status >/dev/null 2>&1; then
            local branch=$(git rev-parse --abbrev-ref HEAD)
            local modified=$(git status --porcelain | wc -l | tr -d ' ')
            local remote="$(\git config --get branch.${branch}.remote 2>/dev/null)"
            local remote_branch="$(\git config --get branch.${branch}.merge)"
            local pushes=$(git rev-list --count ${remote_branch/refs\/heads/refs\/remotes\/$remote}..HEAD 2>/dev/null)
            [[ -z $pushes ]] && pushes=?
            local pulls=$(git rev-list --count HEAD..${remote_branch/refs\/heads/refs\/remotes\/$remote} 2>/dev/null)
            [[ -z $pulls ]] && pulls=?
            if [[ $modified == 0 && $pushes == 0 && $pulls == 0 ]]; then
                GIT_BRANCH=" (${branch})"
            else
                if [[ $pulls == 0 ]]; then
                    if [[ $pushes == 0 ]]; then
                        GIT_BRANCH=" ${PROMPT_OPPOSITE_COLOUR}(${branch} $modified)${PROMPT_COLOUR}"
                    else
                        GIT_BRANCH=" ${PROMPT_OPPOSITE_COLOUR}(${branch} $modified.$pushes)${PROMPT_COLOUR}"
                    fi
                else
                    GIT_BRANCH=" ${PROMPT_OPPOSITE_COLOUR}(${branch} $modified.$pushes.$pulls)${PROMPT_COLOUR}"
                fi
            fi
            return 2
        fi
    fi
}

prompt_command () {
    if [[ -z "$1" ]]; then
        how_do_you_do_nothing_in_a_bash_script=0
    elif [[ $1 == 0 ]]; then
        export STATUS="${GREEN}$1${NO_COLOUR}"
    else
        export STATUS="${RED}$1${NO_COLOUR}"
    fi
    changes=0
    # set -x
    local _short_dir="$(mython ~/jab/bin/short_dir "${PWD}")"
    local Dir="${_short_dir}"
    [[ $? == 2 ]] && Dir="${PROMPT_OPPOSITE_COLOUR}${_short_dir}${PROMPT_COLOUR}"
    [[ -n $IGNORE_CHANGES ]] || get_repo_status
    Dir="${Dir}${GIT_BRANCH}"
    # set +x
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    console_whoami
    export PS1="$STATUS ${PROMPT_COLOUR}[\D{%A %Y-%m-%d.%T} $python_version \u@${HOSTNAME:-$(hostname -s)}:$Dir]${NO_COLOUR}\n$ "
    (what -q kd && kd --add . >/dev/null 2>&1)
    history -a
    local python_version=$($PYTHON --version 2>&1 | cut -d' ' -f2)
    if [[ -n "$VIRTUAL_ENV" ]]; then
        python_version=${python_version}.$(basename $VIRTUAL_ENV)
    fi
    export PS1="$STATUS ${PROMPT_COLOUR}\
[\D{%A %Y-%m-%d.%T} $python_version \u@${HOSTNAME:-$(hostname -s)}:$Dir]\
        ${NO_COLOUR}\n$ "
}

sp () {
    source ~/jab/src/bash/prompt.sh
}

vp () {
    _edit_jab src/bash/prompt.sh "$@"
}

if [[ -n "$MYVIMRC" ]]; then
    export PS1="\$? [\u@\h:\$PWD]\n$ "
    export PROMPT_COMMAND='prompt_command $?'
elif [[ "$PROMPT_COLOUR" == "none" ]]; then
    export PS1="\$? [\u@\h:\$PWD]\n$ "
else
    export PROMPT_COMMAND='prompt_command $?'
fi
export PS2="... "  # Continuation line
export PS3="#?"    # Prompt for select command
export PS4='+ [${BASH_SOURCE##*/}:${LINENO}] '  # Used by “set -x” to prefix tracing output
                                                # Thanks to pyenv for the (ahem) prompt
Bye_from $BASH_SOURCE
