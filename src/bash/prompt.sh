#! /bin/cat -n

Welcome_to $BASH_SOURCE


export FAIL_COLOUR=red
export PASS_COLOUR=green


get_git_branch () {
    git branch > /dev/null 2>&1 || return 1
    git status >/dev/null 2>&1 || return 1
    local _branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || return 1
    echo "$_branch"
}

get_git_status() {
    local _branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -z $_branch ]] && return 1
    local _branch_at=
    [[ $1 =~ [0-9] ]] && _branch_at="$_branch/$1" && shift
    local _modified=$(git status --porcelain | wc -l | tr -d ' ')
    local remote="$(\git config --get branch.${_branch}.remote 2>/dev/null)"
    local _remote_branch="$(\git config --get branch.${_branch}.merge)"
    local _pushes=$(git rev-list --count ${_remote_branch/refs\/heads/refs\/remotes\/$remote}..HEAD 2>/dev/null)
    [[ -z $_pushes ]] && _pushes=?
    local _pulls=$(git rev-list --count HEAD..${_remote_branch/refs\/heads/refs\/remotes\/$remote} 2>/dev/null)
    [[ -z $_pulls ]] && _pulls=?
    if [[ $_modified == 0 && $_pushes == 0 && $_pulls == 0 ]]; then
        echo $_branch_at 
        return 0
    fi
    local _git_branch=
    if [[ $_pulls == 0 ]]; then
        if [[ $_pushes == 0 ]]; then
            _git_branch="$_branch_at $_modified"
        else
            _git_branch="$_branch_at $_modified+$_pushes"
        fi
    else
        _git_branch="$_branch_at $_modified+$pushes-$_pulls"
    fi
    echo $_git_branch
    return 0
}

_get_status () {
    local _status=0
    if [[ -z "$1" ]]; then
        _status=$(_colour red "777 $1")
    elif [[ $1 == 0 ]]; then
        _status=$(_colour green "$1")
    else
        _status=$(_colour red "$1")
    fi
    export STATUS=$_status
}

_colour () {
    local _one="$1"; shift
    local _light=
    local _hue=$_one
    if [[ "$_one" =~ ^l_ ]]; then
        _light="LIGHT_"
        [[ $_one =~ l_red|green|blue ]] && _hue=${_one/l_/}
    fi
    local _var=
    if [[ $_hue =~ red|green|blue|cyan|magenta|yellow ]]; then
        [[ $_hue == red ]] && _var="${_light}RED"
        [[ $_hue == green ]] && _var="${_light}GREEN"
        [[ $_hue == blue ]] && _var="${_light}BLUE"
        [[ $_hue == cyan ]] && _var="${_light}CYAN"
        [[ $_hue == magenta ]] && _var="${_light}MAGENTA"
        [[ $_hue == yellow ]] && _var="${_light}YELLOW"
    fi
    local _hues=${!_var}
    echo -n "$_hues""$@""$NO_COLOUR"
}

_colour_pass () {
    local _test=$1
    local _result=$FAIL_COLOUR
    local _one=$1
    [[ -n $_one ]] && _test=$_one
    [[ $_test == 0 ]] && _result=$PASS_COLOUR
    echo $(_colour $_result "$@")
}

_colour_prompt () {
    local _status=$1; shift
    local _name="${USER:-$(whoami)}"
    local _where="${HOSTNAME:-$(hostname -s)}"
    local _here=$PWD
    local _dir="$(short_dir "$_here")"
    local _got_bump=$(bump get 2>/dev/null)
    local _bump_version=
    [[ -n $_got_bump ]] && _bump_version="$_got_bump"
    local _branch=$(get_git_branch)
    local _git=$(get_git_status $_bump_version)
    [[ -n $_git ]] && _branch="($_git)"
    local _py_vers=$(pyth --version 2>&1 | sed -e s/Python.//)
    local _venv=$(env | g VIRTUAL_ENV= | sed -e "s/[^=]*=//")
    local _py_venv=
    [[ -e $_venv ]] && _py_venv=$(basename_ $_venv)



    local _colour_status=$(_colour_pass $_status)
    local _colour_day=$(_colour l_green $(date +'%A'))
    local _colour_date=$(_colour green $(date +' %F %H:%M'))
    local _colour_name=$(_colour green $_name)
    local _colour_where=$(_colour green $_where)
    local _colour_user="${_colour_name}@$_colour_where"
    local _colour_dir=$(_colour l_blue "$_dir ")
    if [[ -n $_branch ]]; then
        local _colour_branch=$(_colour l_blue "$_branch")
        _colour_dir="$_colour_dir,$_colour_branch"
    fi
    if [[ -n $_py_venv ]]; then
        local _colour_version=$(_colour l_red "${_py_vers}")
        local _colour_virtual=$(_colour l_red "${_py_venv}")
        local _colour_python="$_colour_version.$_colour_virtual"
        printf "$_colour_status $_colour_date $_colour_day $_colour_user:$_colour_dir $_colour_python\n$ "
    else
        local _colour_python=$(_colour l_red "${_py_vers}")
        printf "$_colour_status $_colour_date $_colour_day $_colour_user:$_colour_dir $_colour_python \n$ "
    fi
}

_pre_prompt () {
    console_whoami
    (what -q py_cd && py_cd --add . >/dev/null 2>&1)
    history -a
}

prompt_command () {
    local _status=$1
    _pre_prompt
    export PS1=$(_colour_prompt $_status)
    _post_prompt "$@"
}

_post_prompt () {
    _get_status "$@"
}

sp () {
    source ~/bash/prompt.sh
}

vp () {
    _edit_source ~/bash/prompt.sh +/^_colour_prompt
}

export_prompt_colour () {
    local _prompt_colour=
    case $1 in
        green ) _prompt_colour="$GREEN";;
        red ) _prompt_colour="$RED";;
        blue ) _prompt_colour="$LIGHT_BLUE";;
    esac
    [[ -n $_prompt_colour ]] && shift || _prompt_colour="$GREEN"
    export PROMPT_COLOUR=$_prompt_colour
}

export_prompt_colour "$@"

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
