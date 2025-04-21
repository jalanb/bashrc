#! /bin/cat

[[ $NO_COLOUR ]] || . ~/jab/environ.d/colour.sh

upper () {
    echo ${1^^}
}

rgb () {
    [[ $1 ]] || return 7
    local eol_=
    if [[ $* =~ (^|[\ ])-[l] ]]; then
        eol_="\n"
        shift
    fi
    [[ $1 =~ ^l?(off|red|green|blue|cyan|magenta|black|white)$ ]] || return 8
    local colour_=$1
    [[ $colour_ ]] || return 9
    shift

    local light_=
    [[ $colour_ =~ ^l ]] && light_=1
    [[ $light_ ]] && colour_=${colour_:1}
    colour_=${colour_^^}
    local ight_=NIGHT_
    [[ $light_ ]] && ight_=LIGHT_
    local foreground_="$ight_$colour_" background_=
    if [[ $1 =~ ^(red|green|blue|cyan|magenta|black|white)$ ]]; then
        background_="BACK_${1^^}"
        shift
    fi
    local text_="$@"
    colour_="${!foreground_}"
    [[ $background_ ]] && colour_="${colour_}${!background_}"
    if [[ "$text_" ]]; then printf -- "${colour_}${text_}""${NO_COLOUR}${eol_}"
    elif [ ! -t 0 ]; then printf -- "${colour_}$(cat)${NO_COLOUR}${eol_}"
    else printf -- "${NO_COLOUR}${eol_}"
    fi
}

show_data () {
    lblue_line "$@"
}

show_fail () {
    red_line "$@" >&2
    return 1
}

show_pass () {
    lgreen_line "$@"
    return 0
}

show_error () {
    show_fail "$@"
}

# xxxxxxxxxxx

# xxxxxxxxxxxx

show_command () {
    local verbose_=yes
    [[ $1 =~ -q ]] && verbose_=
    [[ $verbose_ ]] || shift
    local arg_= 
    lblack "$ "
    lgreen "$1 "
    shift
    for arg_ in "$@"; do
        [[ $arg_ =~ \  ]] && arg_="\"$arg_\""
        lblue "$arg_ "
    done
    [[ $verbose_ ]] && echo ""
}


show_run_command () {
    show_command "$@"
    echo
    "$@" > ~/fd1 2> ~/fd2
    if test -s ~/fd1; then
        local text_=
        grep -q '0m' ~/fd1 && cat ~/fd1 || lblue_line $(cat ~/fd1)
        else lblue_line $(cat ~/fd1)
    fi
    if test -s ~/fd2; then
        show_fail $(cat ~/fd2)
    fi
}

show_this_branch () {
    git branch $1 | grep --colour -B3 -A 3 $(get_branch)
}

crayons () {
    echo "${BASH_SOURCE}.sh"
}

crayon () {
    local function_name_=$1 rgb_colour_=$2
    [[ $rgb_colour_ ]] || rgb_colour_=$function_name_
    printf "$function_name_ () {\n    rgb $rgb_colour_ "'"$@"'" \n}\n\n" >> $(crayons)
}

crayon_line () {
    local function_name_=$1 rgb_colour_=$2
    [[ $rgb_colour_ ]] || rgb_colour_=$function_name_
    printf "$function_name_ () {\n    rgb -l $rgb_colour_  "'"$@"'" \n}\n\n" >> $(crayons)
}

source_crayons () {
    local crayons_=$(crayons)
    echo > $crayons_
    crayon no_colour off
    for colour in red green blue cyan magenta yellow black white; do
        [[ $colour == "black" ]] || crayon $colour
        crayon l$colour
        crayon_line ${colour}_line "$colour"
        crayon_line l${colour}_line "l$colour"
    done
    crayon grey lblack
    crayon_line grey lblack
    . $crayons_
}

if [[ ! $SOURCED_CRAYONS ]]; then
    source_crayons
    SOURCED_CRAYONS=1
fi
