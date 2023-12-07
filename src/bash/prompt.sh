#! /bin/cat -n

[[ $SOURCED_CRAYONS ]] || source  ~/bash/crayons.sh.sh
declare | grep -q "^git_root" || source ~/bash/git/functons.sh

export FAIL_COLOUR=red
export PASS_COLOUR=green


get_git_status() {
    local branch_=$1; shift
    local bump_version_=$1; shift
    [[ $bump_version_ =~ [0-9] ]] && branch_="$branch_ v$bump_version_"
    local modified_=$(quietly git status --porcelain | wc -l | tr -d " ")
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

upper () {
    echo "$@" | tr "[:lower:]" "[:upper:]"
}

pro_rgb () {
    local no_colour_="\033[0m"
    local regexp_="red|green|blue|cyan|magenta|yellow"
    local hue_="$1"; shift
    local light_=NIGHT_
    if [[ "$hue_" =~ ^l_ ]]; then
        light_="LIGHT_"
        [[ $one_ =~ l_$regexp_ ]] && hue_=${one_/l_/}
    fi
    local var_=
    if [[ $hue_ =~ $regexp_ ]]; then
        for rgb_ in red green blue cyan magenta yellow; do
            RGB_=$(upper $rgb_)
            [[ $hue_ == $rgb_ ]] && HUE_="${light_}${RGB_}"
        done
    fi
    local hue_=${!HUE_}
    echo -n "$hue_""$@""$no_colour_"
}

emoji_errors () {
    if [[ $1 == 0 ]]; then
        echo "😎 "
    else
        local faces_=(👿 👎 💀 👻 💩 😢 😥 😰 😮 😫 😲 ☹️  😤 😭 😦 😧 😨 😩 🤯 😬 😱 🥵 🥶 😳 🤢 🤮 🤨 😐 😑 )
        echo "${faces_[$1]} "
    fi
}

red_date () {
    local red_day_=$(red $(date +"%A"))
    local lred_date_=$(lred $(date +" %F %H:%M"))
    echo $red_day_ $lred_date_
}

path_to_venv () {
    local path_to_venv_=$(env | grep VIRTUAL_ENV= | cut -d= -f2)
    local join_="/"
    [[ $path_to_venv_ =~ ~ ]] && join_="~"
    [[ $path_to_venv_ =~ ^[.] ]] && join_="."
}

lgreen_venv() {
    local path_to_venv_=$(path_to_venv)
    [[ -e $path_to_venv_ ]] || return 1
    local venv_name_=$(basename "$path_to_venv_")
    if [[ $venv_name_ == ".venv" ]]; then
        local parent_=$(dirname $path_to_venv_)
        local parent_name_=$(basename $parent_)
        venv_name_=$parent_name_
    fi
    local lgreen_python_=$(lgreen "${venv_name_/./}")
    echo $lgreen_python_
}

green_python () {
    local virtual_env_name_=
    [[ $VIRTUAL_ENV ]] && virtual_env_name_=$(basename "$VIRTUAL_ENV")
    if [[ $virtual_env_name_ == ".venv" ]]; then
        local virtual_env_directory_=$(dirname $VIRTUAL_ENV)
        virtual_env_name_=$(basename "$virtual_env_directory_")
    fi

    local python_version_=$(python -V 2>&1 | head -n1 | cut -d" " -f2)
    local green_python_=$(green "${python_version_}")
    local lgreen_venv_=$(lgreen_venv)
    if [[ ! $lgreen_venv_ ]]; then
        echo $green_python_
        return 0
    fi
    local path_to_venv_=$(path_to_venv)
    local join_="/"
    [[ $path_to_venv_ =~ ~ ]] && join_="~"
    [[ $path_to_venv_ =~ ^[.] ]] && join_="."
    echo "${green_python_}${join_}${lgreen_venv_}"
}

short_pwd () {
    echo $(PYTHONPATH="$HOME/pysyte/" ~/pysyte/bin/short_dir "$PWD" 2> /dev/null)
}

git_data () {
    local branch_name_="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    local git_data_=
    if [[ $branch_name_ ]]; then
        local bump_version_="v$(bump get)"
        [[ $bump_version_ == v ]] && bump_version_=
        git_data_=":$branch_name_ $bump_version_"
    fi
    local project_=$(git remote get-url origin 2>/dev/null | sed -e "s,.*[/]\([A-Za-z.-]*\)[/]\([A-Za-z.-]*\).git,\1/\2.git,")
    [[ $project_ ]] && git_data_="${project_}${git_data_}"
    echo $git_data_
}

dir_data () {
    local rlf_="$(readlink -f .)"
    [[ "$rlf_" == "$PROMPT_RLF" ]] && basename "$rlf_" || echo "$rlf_"
}

lblue_dir () {
    local dir_=$(dir_data)
    local git_=$(git_data)
    lblue "$git_ $dir_"
}

colour_prompt () {
    local __doc__="""Use a coloured prompt with helpful info"""
    printf " \n$(emoji_errors $1) $(red_date) $(green_python) $(lblue_dir)\n $ "
}

blue_user () {
    local user_=$(whoami)
    local blue_user_=$(blue ${user_:$USER})
    # echo "${lblue_user_}@$(lblue_host)"
    echo "${blue_user_}"
}

lblue_host () {
    local hostname_=$(hostname -s)
    local lblue_host_=$(lblue ${hostname_:-$HOSTNAME})
    echo "$lblue_host_"
}

set_status_bit () {
    local __doc__="""Set the status bit from $?"""
    local one_=$1; shift
    local status_=
    [[ -z "$one_" ]] && one_="-z \$?"
    local status_color_=red
    [[ $one_ == 0 ]] && status_color_=green
    status_=$(rgb $status_color_ $one_)
    export STATUS=$status_
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

pre_pses () {
    local __doc__="""Stuff to do before setting the prompt"""
    console_whoami
    cde_python --add . >/dev/null 2>&1
    history -a
}

post_pses () {
    local __doc__="""Stuff to do after setting the prompt"""
    PROMPT_RLF=$(readlink -f .)
    export PROMPT_RLF
}

export_pses () {
    local __doc__="""Set all PS* symbols (which control prompts"""
    local status_=$1
    PROMPT_STATUS=$status_
    export PROMPT_STATUS
    # export ITERM2_SQUELCH_MARK=1
    pre_pses
    export PS1=$(colour_prompt $status_)
    export PS2="... "  # Continuation line
    export PS3="#?"    # Prompt for select command
    export PS4='+ [${BASH_SOURCE##*/}:${LINENO}] '  # Used by “set -x” to prefix tracing output
                                                    # Thanks to pyenv for the (ahem) prompt
    post_pses "$@"
}


export PROMPT_COLOUR=$(echo_prompt_colour "$@")
if [[ "$PROMPT_COLOUR" == "None" ]]; then
    export PS1="\$? [\u@\h:\$PWD]\n$ "
else
    export_pses
    export PROMPT_COMMAND="export_pses $?"
fi
