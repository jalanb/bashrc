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

emoji_error () {
    if [[ $1 == 0 ]]; then 
        echo "😎 "
    else
        local _faces=(👿 👎 💀 👻 💩 🤨  😐 😑 😥 😮 😫 😲 ☹️  😤 😢 😭 😦 😧 😨 😩 🤯  😬 😰 😱 🥵  🥶  😳 🤢 🤮 )
        echo "${_faces[$1]} "
    fi
}

_colour_prompt () {
    local __doc__="""Use a coloured prompt with helpful info"""
    printf "$(emoji_error $1) $(green_date) $(blue_user):$(blue_pwd_git) $(red_python)\n$ "
}

path_to_venv () {
    env | g VIRTUAL_ENV= | cut -d= -f2
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
    echo $(_colour l_red "${_venv_name/./}")
}

green_date () {
    local _colour_day=$(_colour green $(date +'%A'))
    local _colour_date=$(_colour l_green $(date +' %F %H:%M'))
    echo $_colour_day $_colour_date
}

_short_dir () {
    local _short=$(which short_dir 2> /dev/null)
    [[ $_short ]] || return 1
    $_short "$1"
}

blue_pwd_git () {
    local _text_branch="$(get_branch)"
    local _branch_version=
    if [[ $_text_branch ]]; then
        local _project_version="v$(bump get 2>/dev/null)"
        [[ $_project_version == v ]] && _project_version=
        _branch_version=", $_text_branch $_project_version"
    fi
    local _text_dir="$(_short_dir "$PWD")"
    [[ $_text_dir ]] || _text_dir=../$(basename "$(readlink -f .)")
    echo $(_colour l_blue "${_text_dir}${_branch_version}")
}

blue_user () {
    local _colour_username=$(_colour blue ${USER:-$(whoami)})
    local _colour_host=$(_colour blue ${HOSTNAME:-$(hostname -s)})
    echo "${_colour_username}@$_colour_host"
}

red_python () {

    local _virtual_env_name=
    local _virtual_env_root=$(env | g VIRTUAL_ENV | cut -d= -f2)
    [[ $_virtual_env_root ]] && _virtual_env_name=$(basename "$_virtual_env_root")
    if [[ $_virtual_env_name == ".venv" ]]; then
        local _virtual_env_directory=$(dirname $_virtual_env_root)
        _virtual_env_name=$(basename "$_virtual_env_directory")
    fi

    local _python_version=$(python -V 2>&1 | head -n1 | cut -d' ' -f2)
    local _colour_python=$(_colour l_red "${_python_version}")
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
    (cde_python --add . >/dev/null 2>&1)
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
