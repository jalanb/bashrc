#! /bin/cat -n

PROMPT_SOURCE=$(readlink -f "$BASH_SOURCE")

[[ $SOURCED_CRAYONS ]] || source  ~/bash/crayons.sh.sh
declare | grep -q "^git_root" || source ~/bash/git/functons.sh

export FAIL_COLOUR=red
export PASS_COLOUR=green


get_git_status() {
    local branch_=$1; shift
    local bump_version_=$1; shift
    [[ $bump_version_ =~ [0-9] ]] && branch_="$branch_ v$bump_version_"
    local modified_=$(quietly git status --porcelain | wc -l | tr -d " ")
    local remote="$(quietly git config --get branch.${branch_}.remote )"
    local remote_branch_="$(git config --get branch.${branch_}.merge)"
    local pushes_=$(quietly git rev-list --count ${remote_branch_/refs\/heads/refs\/remotes\/$remote}..HEAD )
    [[ -z $pushes_ ]] && pushes_=?
    local pulls_=$(quietly git rev-list --count HEAD..${remote_branch_/refs\/heads/refs\/remotes\/$remote} )
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
        short_branch_="$short_branch_ $modified_+$pushes_-$pulls_"
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
    env | grep VIRTUAL_ENV= | cut -d= -f2
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

    local python_app_=$(command -v python3 || command -v python)
    [[ $python_app_ ]] || return 1
    local python_version_=$($python_app_ -V 2>&1 | head -n1 | cut -d" " -f2)
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
    echo $(PYTHONPATH="$HOME/pysyte/" quietly ~/pysyte/bin/short_dir "$PWD" )
}

git_data () {
    local branch_name_="$(quietly git rev-parse --abbrev-ref HEAD )"
    local git_data_=
    if [[ $branch_name_ ]]; then
        versioned_branch_=" $branch_name_"
        local bump_version_="v$(quietly bump get)"
        [[ $bump_version_ == v ]] && bump_version_=
        [[ $bump_version_ ]] && versioned_branch_+=" $bump_version_"
    fi
    local project_=$(quietly git remote get-url origin \
        | sed -e "s,://[^@]*@,://," \
              -e "s,.*[/]\([A-Za-z._-]*\)[/]\([A-Za-z._-]*\)[.]git.*$,\1/\2," \
              -e "s,.*[/]\([A-Za-z._-]*\)[/]\([A-Za-z._-]*\)$,\1/\2," \
)
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
    [[ $git_ =~ $dir_ ]] && dir_=.
    git_=${git_/SMBCGitHub\/SMBC-JRIA-/SMBC\/}
    lblue "$git_ $dir_"
}

colour_prompt () {
    local __doc__="""Use a coloured prompt with helpful info"""
    printf " \n$(emoji_errors $1) $(red_date) $(green_python) $(blue_user) $(lblue_dir)\n "
}

blue_user () {
    local user_=$(whoami)
    local blue_user_=$(blue ${user_:$USER})
    local show_host_=
    if [[ $WORK ]]; then
        show_host_=$(env | grep -v WORK= | grep -q $WORK)
    fi
    if [[ $show_host_ ]]; then
        echo "${blue_user_}@$(lblue_host)"
    else
        echo "${blue_user_}"
    fi
}

lblue_host () {
    local hostname_=$(hostname -s)
    local lblue_host_=$(lblue ${hostname_:-$HOSTNAME})
    echo "$lblue_host_"
}

set_status_bit () {
    local __doc__="""Set the status bit from $?"""
    local one_=$1; shift
    [[ -z "$one_" ]] && one_="-z \$?"
    local status_color_=red
    [[ $one_ == 0 ]] && status_color_=green
    local status_=
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
         * ) return 1;;
    esac
    echo $prompt_colour_
}

reload_prompt_if_changed () {
    local current_mtime_=$(quietly stat -f %m "$PROMPT_SOURCE" )
    [[ $current_mtime_ != $PROMPT_MTIME ]] && source "$PROMPT_SOURCE"
}

pre_pses () {
    local __doc__="""Stuff to do before setting the prompt"""
    reload_prompt_if_changed
    console_whoami
    QUIETLY cde_python --add .
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
    pre_pses
    export PS1=$(colour_prompt $status_)
    # Continuation line
    export PS2="... "
    # Prompt for select command
    export PS3="#?"
    # Used by “set -x” to prefix tracing output
    # export PS4="+ [${BASH_SOURCE##*/}:${FUNCNAME[0]}():${LINENO}] "
    export PS4='+ [${BASH_SOURCE##*/}::${FUNCNAME[0]}():${LINENO}] '
    set_status_bit "$status_"
    post_pses
}


export PROMPT_MTIME=$(quietly stat -f %m "$PROMPT_SOURCE" )
export PROMPT_COLOUR=$(echo_prompt_colour "$@")
if [[ "$PROMPT_COLOUR" == "None" ]]; then
    export PS1="\$? [\u@\h:\$PWD]\n$ "
else
    export_pses
    export PROMPT_COMMAND=" export_pses $? "
fi
