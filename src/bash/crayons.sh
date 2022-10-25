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

rgb () {
    [[ $1 ]] || return 7
    [[ $1 =~ ^l?(off|red|green|blue|cyan|magenta|black|white)$ ]] || return 8
    local colour_=$1
    [[ $colour_ ]] || return 9
    shift
    local light_=
    [[ $colour_ =~ ^l ]] && light_=1
    [[ $light_ ]] && colour_=${colour:1}
    colour_=$(echo $colour_ | tr [:lower:] [:upper:])
    local ight_=NIGHT_
    [[ $light_ ]] && ight_=LIGHT_
    local foreground_="$ight_$colour_" background_=
    if [[ $1 =~ ^(red|green|blue|cyan|magenta|black|white)$ ]]; then
        background_="BACK_$(echo $1 | tr [:lower:] [:upper:])"
        shift
    fi
    local eol_= text_="$@"
    if [[ $* =~ (^|[\ ])-l ]]; then
        eol_="\n"
        text_=$(echo $text_ | sed -e 's,\(^\|[ ]\)-l\($\| \),,g')
        shift
    fi
    if [[ "$text_" ]];
    then printf "${!foreground_}${!background_}$text_""${NO_COLOUR}${eol_}"
    else printf "${!foreground_}${!background_}$(cat)${NO_COLOUR}${eol_}"
    fi
}

red () {
    rgb red "$@"
}

green () {
    rgb green "$@"
}

blue () {
    rgb blue "$@"
}


show_error () {
    red_line "$@" >&2
    return 1
}
alias show_fail=show_error

lblue () {
    rgb lblue "$@"
}

# xxxxxxxxxxx

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

rgbl () {
    rgb -l "$@"
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

crayons () {
    echo "${BASH_SOURCE}.sh"
}

crayon () {
    local name_=$1 body_=$2
    [[ $body_ ]] || body_=$name_
    printf "$name_ () {\n rgb $body_ "'"$@"'" \n}\n\n" >> $(crayons)
}

source_crayon_functions () {
    local crayons_=$(crayons) name=$1 body_=$2
    echo > $crayons_
    crayon no_colour off
    for colour in red green blue cyan magenta yellow black white; do
        crayon $colour
        crayon l$colour
        crayon ${colour}_line "$colour -l"
        crayon l${colour}_line "$colour -l"
    done
    . $crayons_
}

if [[ ! $SOURCED_CRAYON_FUNCTIONS ]]; then
    source_crayon_functions
    SOURCED_CRAYON_FUNCTIONS=1
fi
