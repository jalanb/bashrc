#! /bin/cat

[[ $NO_COLOUR ]] || . ~/jab/environ.d/colour.sh

# show_colours

# xxxxxxxx



show_error () {
    show_red_line "$@" >&2
    return 1
}
alias show_fail=show_error

# xxxxxxxxxxx

show_colour () {
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

show_command () {
    lgreen_line '$' "$@"
}

# xxxxxxxxxxxxx

# xxxxxxxxxxxxxxx

# xxxxxxxxxxxxxxx

alias show_pass=green_line

# xxxxxxxxxxxxxxxx

show_colour_line () {
    show_colour "$@" -l
}

show_run_command () {
    show_command "$@"
    echo
    "$@" > ~/fd1 2> ~/fd2
    if test -s ~/fd1; then
        if grep -q '0m' ~/fd1
        then cat ~/fd1
        else light_blue_line $(cat ~/fd1)
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
        printf "$colour () {\n show_colour $colour "'"$@"'"\n}\n\n" >> $function_script_
        printf "l$colour () {\n show_colour l$colour "'"$@"'"\n}\n\n" >> $function_script_
        printf "${colour}_line () {\n show_colour $colour -l "'"$@"'"\n}\n\n" >> $function_script_
        printf "l${colour}_line () {\n show_colour l$colour -l "'"$@"'"\n}\n\n" >> $function_script_
    done
    . $function_script_
    # rm -f $function_script_
    SOURCED_COLOUR_FUNCTIONS=1
}

[[ $SOURCED_COLOUR_FUNCTIONS ]] || source_colour_functions
