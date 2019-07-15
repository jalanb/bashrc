#! /bin/cat -n

Welcome_to $BASH_SOURCE


export FAIL_COLOUR=red
export PASS_COLOUR=green


get_git_branch () {
    git branch > /dev/null 2>&1 || return 1
    git status >/dev/null 2>&1 || return 1
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

get_git_status() {
    local _branch=$1; shift
    local _bump_version=$1; shift
    local _branch_at="$_branch"
    [[ $_bump_version =~ [0-9] ]] && _branch_at="$_branch v$_bump_version"
    local _modified=$(quietly git status --porcelain | wc -l | tr -d ' ')
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
    if [[ $_pulls == 0 ]]; then
        if [[ $_pushes == 0 ]]; then
            _branch_at="$_branch_at $_modified"
        else
            _branch_at="$_branch_at $_modified+$_pushes"
        fi
    else
        _branch_at="$_branch_at $_modified+$pushes-$_pulls"
    fi
    echo $_branch_at
    return 0
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
    if [[ $_test == 0 ]]; then # && _result=$PASS_COLOUR
        echo "😎 "
    else
        local _faces=(👿 👎 💀 👻 💩 🤨  😐 😑 😥 😮 😫 😲 ☹️  😤 😢 😭 😦 😧 😨 😩 🤯  😬 😰 😱 🥵  🥶  😳 🤢 🤮 )
        echo "${_faces[$?]} "
    fi
}

_colour_prompt () {
    local __doc__="""Use a coloured prompt with helpful info"""
    local _status=$1; shift
    local _where="${HOSTNAME:-$(hostname -s)}"
    local _dir="$(short_dir "$PWD" 2>/dev/null)"

    [[ -n $_dir ]] || _dir=$(basename $(readlink -f .))
    local _got_bump=$(bump get 2>/dev/null)
    local _bump_version=
    [[ -n $_got_bump ]] && _bump_version="$_got_bump"
    local _branch=$(get_git_branch)
    local _branch=$(quietly git rev-parse --abbrev-ref HEAD)
    local _branch_at=$(get_git_status $_branch $_bump_version)
    [[ -n $_branch_at ]] && _branch="($_branch_at)"
    local _py_vers=$(python --version 2>&1 | sed -e s/Python.//)
    local _path_to_venv=$(env | g VIRTUAL_ENV= | cut -d= -f2)
    local _venv_name=
    [[ -n $_path_to_venv ]] && _venv_name=$(basename $_path_to_venv)
    if [[ $_venv_name == ".venv" ]]; then
        local _parent=$(dirname $_path_to_venv)
        local _parent_name=$(basename $_parent)
        _path_to_venv=$_parent_name
    fi
    local _python_name=
    [[ -e $_venv_name ]] && _python_name=$(basename $_venv_name)



    local _colour_status=$(_colour_pass $_status)
    local _colour_day=$(_colour l_green $(date +'%A'))
    local _colour_date=$(_colour green $(date +' %F %H:%M'))
    local _colour_username=$(_colour green ${USER:-$(whoami)})
    local _colour_where=$(_colour green ${HOSTNAME:-$(hostname -s)})
    local _colour_user="${_colour_username}@$_colour_where"
    local _version="v$(bump get 2>/dev/null)"
    [[ $_version == v ]] && _version=
    local _colour_branch=
    [[ $_branch ]] && _colour_branch="$(_colour l_blue $_branch)"
    local _text_dir="$(short_dir $PWD 2>/dev/null)"
    [[ $_text_dir ]] || _text_dir=$(basename $(readlink -f .))
    local _colour_dir=$(_colour l_blue "$_text_dir")
    [[ $_colour_branch ]] && _colour_dir="$_colour_dir, $_colour_branch"
    local _text_dir="$(short_dir $PWD 2>/dev/null)"
    [[ $_text_dir ]] || _text_dir=$(basename $(readlink -f .))
    local _python_version=$(python -V 2>&1 | cut -d' ' -f2)
    local _colour_python=$(_colour l_red "${_python_version}")
    if [[ -n $_python_name ]]; then
        local _colour_version=$(_colour l_red "${_python_version}")
        local _colour_name=$(_colour l_red "${_python_name/./}")
        local _join='/'
        [[ $_path_to_venv =~ ~ ]] && _join='~'
        [[ $_path_to_venv =~ ^[.] ]] && _join='.'
        _colour_python="$_colour_version${_join}${_colour_name}"
    fi
    local _local_colour=$_colour_user:$_colour_dir
    printf "$_colour_status $_colour_date $_colour_day $_local_colour $_colour_python\n$ "
}

sp () {
    source ~/bash/prompt.sh
}

vp () {
    _edit_source ~/bash/prompt.sh +/^_colour_prompt
}

set_status_bit () {
    local __doc__="""Set the status bit from $?"""
    local _one=$1; shift
    local _status=
    [[ -z "$_one" ]] && _one="-z \$?"
    local _status_color=red
    [[ $_one == 0 ]] && _status_color=green
    _status=$(_colour $_status_color $_one)
    export STATUS=$_status
}

export_prompt_colour () {
    local __doc__="""Interpret first arg as main colour for the prompt"""
    local _prompt_colour=
    case $1 in
        green ) _prompt_colour="$GREEN";;
        red ) _prompt_colour="$RED";;
        blue ) _prompt_colour="$LIGHT_BLUE";;
    esac
    [[ -n $_prompt_colour ]] && shift || _prompt_colour=None
    export PROMPT_COLOUR=$_prompt_colour
}

_pre_pses () {
    local __doc__="""Stuff to do before setting the prompt"""
    console_whoami
    (whyp-whyp -q py_cd && py_cd --add . >/dev/null 2>&1)
    history -a
}

_post_pses () {
    local __doc__="""Stuff to do after setting the prompt"""
    set_status_bit "$@"
}

export_pses () {
    local __doc__="""Set all PS* symbols (which control prompts"""
    local _status=$1
    _pre_pses
    export PS1=$(_colour_prompt $_status)
    export PS2="... "  # Continuation line
    export PS3="#?"    # Prompt for select command
    export PS4='+ [${BASH_SOURCE##*/}:${LINENO}] '  # Used by “set -x” to prefix tracing output
                                                    # Thanks to pyenv for the (ahem) prompt
    _post_pses "$@"
}

export_prompt_colour "$@"
[[ "$PROMPT_COLOUR" == "None" ]] && export PS1="\$? [\u@\h:\$PWD]\n$ " || export PROMPT_COMMAND='export_pses $?'
Bye_from $BASH_SOURCE
