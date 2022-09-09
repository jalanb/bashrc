#! /bin/cat -n



export FAIL_COLOUR=red
export PASS_COLOUR=green


get_git_status() {
    local branch_=$1; shift
    local bump_version_=$1; shift
    [[ $bump_version_ =~ [0-9] ]] && branch_="$branch_ v$bump_version_"
    local modified_=$(quietly git status --porcelain | wc -l | tr -d ' ')
    local remote="$(git config --get branch.${branch_}.remote 2>/dev/null)"
    local remote_branch_="$(git config --get branch.${branch_}.merge)"
    local pushes_=$(git rev-list --count ${remote_branch_/refs\/heads/refs\/remotes\/$remote}..HEAD 2>/dev/null)
    [[ -z $pushes_ ]] && pushes_=?
    local pulls_=$(git rev-list --count HEAD..${remote_branch_/refs\/heads/refs\/remotes\/$remote} 2>/dev/null)
    [[ -z $pulls_ ]] && pulls_=?
    local short_branch_=$branch_
    [[ $branch_ =~ [A-Z][A-Z][A-Z][A-Z][-] ]] && short_branch_=$(echo $branch | sed -e "s,\(....-[0-9]*\).*,\1,")
    if [[ $modified_ == 0 && $pushes_ == 0 && $pulls_ == 0 ]]; then
        echo $short_branch_
        return 0
    fi
    if [[ $pulls_ == 0 ]]; then
        if [[ $pushes_ == 0 ]]; then
            short_branch_="$short_branch_ $modified_"
        else
            short_branch_="$short_branch_ $modified_+$pushes_"
        fi
    else
        short_branch_="$short_branch_ $modified_+$pushes-$pulls_"
    fi
    echo $short_branch_
    return 0
}

_colour () {
    local one_="$1"; shift
    local light_= no_colour_="\033[0m"
    local regexp_="red|green|blue|cyan|magenta|yellow"
    local hue_=$one_
    if [[ "$one_" =~ ^l_ ]]; then
        light_="LIGHT_"
        [[ $one_ =~ l_$regexp_ ]] && hue_=${one_/l_/}
    fi
    local var_=
    if [[ $hue_ =~ $regexp_ ]]; then
        [[ $hue_ == red ]] && var_="${light_}RED"
        [[ $hue_ == green ]] && var_="${light_}GREEN"
        [[ $hue_ == blue ]] && var_="${light_}BLUE"
        [[ $hue_ == cyan ]] && var_="${light_}CYAN"
        [[ $hue_ == magenta ]] && var_="${light_}MAGENTA"
        [[ $hue_ == yellow ]] && var_="${light_}YELLOW"
    fi
    local hues_=${!var_}
    echo -n "$hues_""$@""$no_colour_"
}

blue_ () {
    _colour blue "$@"
}

green_ () {
    _colour green "$@"
}

l_blue_ () {
    _colour l_blue "$@"
}

l_green_ () {
    _colour l_green "$@"
}

l_red_ () {
    _colour l_red "$@"
}

emoji_error () {
    if [[ $1 == 0 ]]; then
        echo "😎 "
    else
        local _faces=(👿 👎 💀 👻 💩 😢 😥 😰 😮 😫 😲 ☹️  😤 😭 😦 😧 😨 😩 🤯 😬 😱 🥵 🥶 😳 🤢 🤮 🤨 😐 😑 )
        echo "${_faces[$1]} "
    fi
}

_colour_prompt () {
    local __doc__="""Use a coloured prompt with helpful info"""
    echo
    printf "$(emoji_error $1) $(green_date) $(blue_user):$(blue_pwd_git) $(red_python)\n$ "
    #printf "$(emoji_error $1) $(green_date) $(blue_user):$(blue_pwd_git) $(red_python)\n\[$(iterm2_prompt_mark)\]$ "
}

path_to_venv () {
    env | grep VIRTUAL_ENV= | cut -d= -f2
}

venv_name () {
    local _path_to_venv=$(path_to_venv)
    [[ -e $_path_to_venv ]] || return 1
    local _venv_name=$(basename "$_path_to_venv")
    if [[ $_venv_name == ".venv" ]]; then
        local _parent=$(dirname $_path_to_venv)
        local _parent_name=$(basename $_parent)
        _venv_name=$_parent_name
    fi
    echo $(l_red_ "${_venv_name/./}")
}

green_date () {
    local _colour_day=$(green_ $(date +'%A'))
    local _colour_date=$(l_green_ $(date +' %F %H:%M'))
    echo $_colour_day $_colour_date
}

short_pwd () {
    echo $(PYTHONPATH="$HOME/pysyte/" ~/pysyte/bin/short_dir "$PWD" 2> /dev/null)
}

blue_pwd_git () {
    local _branch_name="$(get_branch)"
    local _version=
    if [[ $_branch_name ]]; then
        local _bump_version="v$(bump get 2>/dev/null)"
        [[ $_bump_version == v ]] && _bump_version=
        _version=", $_branch_name $_bump_version"
    fi
    local pwd_="$(short_pwd)"
    [[ $pwd_ ]] || pwd_=$(basename "$(readlink -f .)")
    local project_=$(git remote get-url origin 2>/dev/null | sed -e "s,.*/\([a-z.]*\)/\([a-z.]*\)[.git]*,\1/\2,")
    [[ $project_ ]] && pwd_="${project_}:${pwd_}"
    echo $(l_blue_ "${pwd_}${_version}")
}

blue_user () {
    local _colour_username=$(blue_ ${USER:-$(whoami)})
    local _colour_host=$(blue_ ${HOSTNAME:-$(hostname -s)})
    echo "${_colour_username}@$_colour_host"
}

red_python () {

    local _virtual_env_name=
    local _virtual_env_root=$(env | grep VIRTUAL_ENV | cut -d= -f2)
    [[ $_virtual_env_root ]] && _virtual_env_name=$(basename "$_virtual_env_root")
    if [[ $_virtual_env_name == ".venv" ]]; then
        local _virtual_env_directory=$(dirname $_virtual_env_root)
        _virtual_env_name=$(basename "$_virtual_env_directory")
    fi

    local _python_version=$(python -V 2>&1 | head -n1 | cut -d' ' -f2)
    local _colour_python=$(l_red_ "${_python_version}")
    local _colour_venv=$(venv_name)
    if [[ ! $_colour_venv ]]; then
        echo $_colour_python
        return 0
    fi
    local _path_to_venv=$(path_to_venv)
    local _join='/'
    [[ $_path_to_venv =~ ~ ]] && _join='~'
    [[ $_path_to_venv =~ ^[.] ]] && _join='.'
    echo "${_colour_python}${_join}${_colour_venv}"
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

echo_prompt_colour () {
    local __doc__="""Interpret first arg as main colour for the prompt"""
    local prompt_colour_=
    case $1 in
        green ) prompt_colour_="$LIGHT_GREEN";;
          red ) prompt_colour_="$LIGHT_RED";;
         blue ) prompt_colour_="$LIGHT_BLUE";;
    esac
    [[ -n $prompt_colour_ ]] && shift || prompt_colour_=None
    echo $prompt_colour_
}

_pre_pses () {
    local __doc__="""Stuff to do before setting the prompt"""
    console_whoami
    cde_python --add . >/dev/null 2>&1
    history -a
}

_post_pses () {
    local __doc__="""Stuff to do after setting the prompt"""
    set_status_bit "$@"
}

export_pses () {
    local __doc__="""Set all PS* symbols (which control prompts"""
    local _status=$1
    PROMPT_STATUS=$_status
    export PROMPT_STATUS
    # export ITERM2_SQUELCH_MARK=1
    _pre_pses
    export PS1=$(_colour_prompt $_status)
    export PS2="... "  # Continuation line
    export PS3="#?"    # Prompt for select command
    export PS4='+ [${BASH_SOURCE##*/}:${LINENO}] '  # Used by “set -x” to prefix tracing output
                                                    # Thanks to pyenv for the (ahem) prompt
    _post_pses "$@"
}


export PROMPT_COLOUR=$(echo_prompt_colour "$@")
if [[ "$PROMPT_COLOUR" == "None" ]]; then
    export PS1="\$? [\u@\h:\$PWD]\n$ "
else
    export_pses
    export PROMPT_COMMAND='export_pses $?'
fi
