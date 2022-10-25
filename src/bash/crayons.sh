#! /bin/cat

[[ $NO_COLOUR ]] || . ~/jab/environ.d/colour.sh

# show_colours
# xxxxxxxx

off () {
    echo $NO_COLOUR
}

ansi_red () {
    echo $RED
}

ansi_green () {
    echo $GREEN
}

ansi_blue () {
    echo $LIGHT_BLUE
}

red () {
    coloured $(ansi_red) "$@"
}

blue () {
    coloured $(ansi_blue) "$@"
}


show_error () {
    red_line "$@" >&2
    return 1
}
alias show_fail=show_error

lblue () {
    coloured $(ansi_blue) "$@"
}

green () {
    coloured $(ansi_green) "$@"
}

# xxxxxxxxxxx

coloured () {
    [[ $1 ]] || return 7
    [[ $1 =~ ^l?(red|green|blue|cyan|magenta|black|white)$ ]] || return 8
    local upper_=$(echo $1 | tr [:lower:] [:upper:])
    [[ $1 =~ ^l ]] && upper_=${upper_:1}
    local fore_="NIGHT_$upper_"  back_= none_=
    [[ $1 =~ ^l ]] && fore_=${fore_/N/L}
    shift
    [[ $1 ]] || return 9
    if [[ $1 =~ ^(red|green|blue|cyan|magenta|black|white)$ ]]; then
        back_="BACK_$(echo $1 | tr [:lower:] [:upper:])"
        shift
    fi
    local colour_="${fore_}${back_}"
    local eol_= text_="$@"
    if [[ $* =~ (^|[\ ])-l ]]; then
        eol_="\n"
        text_=$(echo $text_ | sed -e 's,\(^\|[ ]\)-l\($\| \),,g')
        shift
    fi
    [[ $back_ ]] || back_=none_
    if [[ "$text_" ]];
    then printf "${!fore_}${!back_}$text_""${NO_COLOUR}${eol_}"
    else printf "${!fore_}${!back_}$(cat)${NO_COLOUR}${eol_}"
    fi
}

# xxxxxxxxxxxx

is_command () {
    type $1 >/dev/null 2>&1
}

show_data () {
    lblue_line "$@"
}

show_command () {
    local arg_= args_=("$@")
    lgreen "$ ${args_[0]} "
    unset args_[0]
    for arg_ in "${args_[@]}"; do
        [[ $arg_ =~ \  ]] && arg_="\"$arg_\""
        lgreen "$arg_ "
    done
    echo ""
}

# xxxxxxxxxxxxx

# xxxxxxxxxxxxxxx
red_line () {
    red -l "$@"
}
alias show_red_line=red_line

# xxxxxxxxxxxxxxx

alias show_pass=green_line
blue_line () {
    blue -l "$@"
}
alias show_blue_line=blue_line
alias show_cmnd=show_blue_line
# xxxxxxxxxxxxxxx
green_line () {
    green -l "$@"
}
alias show_green_line=green_line
alias show_pass=show_green_line

lblue_line () {
    lblue -l "$@"
}
# xxxxxxxxxxxxxxxx

coloured_line () {
    coloured -l "$@"
}

show_run_command () {
    show_command "$@"
    printf
    "$@" > ~/fd1 2> ~/fd2
    if test -s ~/fd1; then
        if grep -q '0m' ~/fd1
        then cat ~/fd1
        else lblue_line $(cat ~/fd1)
        fi
    fi
    if test -s ~/fd2; then
        red_line $(cat ~/fd2)
    fi
}

show_this_branch () {
    git branch $1 | grep --colour -B3 -A 3 $(get_branch)
}

source_colour_functions () {
    local function_script_=${BASH_SOURCE}.sh
    echo > $function_script_
    printf "no_colour () {\n show_colour "'$NO_COLOR'" \n}\n\n" >> $function_script_
    for colour in red green blue cyan magenta yellow black white; do
        [[ $colour == "black" ]] || printf "$colour () {\n show_colour $colour "'"$@"'"\n}\n\n" >> $function_script_
        printf "l$colour () {\n show_colour l$colour "'"$@"'"\n}\n\n" >> $function_script_
        printf "${colour}_line () {\n show_colour $colour -l "'"$@"'"\n}\n\n" >> $function_script_
        printf "l${colour}_line () {\n show_colour l$colour -l "'"$@"'"\n}\n\n" >> $function_script_
    done
    . $function_script_
    # rm -f $function_script_
    SOURCED_COLOUR_FUNCTIONS=1
}

[[ $SOURCED_COLOUR_FUNCTIONS ]] || source_colour_functions
