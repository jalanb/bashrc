#! /bin/cat

[[ $NO_COLOUR ]] || . ~/jab/environ.d/colour.sh

upper () {
    echo "$@" | tr '[:lower:]' '[:upper:]'
}

rgb () {
    [[ $1 ]] || return 7
    [[ $1 =~ ^l?(off|red|green|blue|cyan|magenta|black|white)$ ]] || return 8
    local colour_=$1
    [[ $colour_ ]] || return 9
    shift

    local light_=
    [[ $colour_ =~ ^l ]] && light_=1
    [[ $light_ ]] && colour_=${colour_:1}
    colour_=$(echo $colour_ | tr [:lower:] [:upper:])
    local ight_=NIGHT_
    [[ $light_ ]] && ight_=LIGHT_
    local foreground_="$ight_$colour_" background_=
    if [[ $1 =~ ^(red|green|blue|cyan|magenta|black|white)$ ]]; then
        background_="BACK_$(echo $1 | tr [:lower:] [:upper:])"
        shift
    fi
    local eol_= text_="$@"
    if [[ $* =~ (^|[\ ])-[ln] ]]; then
        eol_="\n"
        text_=$(printf -- "$text_" | sed -e 's,\(^\|[ ]\)-[ln]\($\| \),,g')
        shift
    fi
    colour_="${!foreground_}"
    [[ $background_ ]] && colour_="${colour_}${!background_}"
    if [[ "$text_" ]];
    then printf -- "${colour_}$text_""${NO_COLOUR}${eol_}"
    else printf -- "${colour_}$(cat)${NO_COLOUR}${eol_}"
    fi
}

show_data () {
    lblue -n "$@"
}

show_fail () {
    red -n "$@" >&2
    return 1
}

show_pass () {
    lgreen -n "$@"
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
    local arg_= args_=("$@") out_=
    lblack "$ "
    lgreen "${args_[0]} "
    unset args_[0]
    for arg_ in "${args_[@]}"; do
        [[ $arg_ =~ \  ]] && arg_="\"$arg_\""
        out_="$out_ $arg_ "
    done
    lblue $out_
    [[ $verbose_ ]] && echo ""
}


rgb_line () {
    rgb -n "$@"
}

show_run_command () {
    show_command "$@"
    echo
    "$@" > ~/fd1 2> ~/fd2
    if test -s ~/fd1; then
        local text_=
        grep -q '0m' ~/fd1 && cat ~/fd1 || lblue -n $(cat ~/fd1)
        else lblue -n $(cat ~/fd1)
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
    local name_=$1 body_=$2
    [[ $body_ ]] || body_=$name_
    printf "$name_ () {\n    rgb $body_ "'"$@"'" \n}\n\n" >> $(crayons)
}

crayon_line () {
    local name_=$1 body_=$2
    [[ $body_ ]] || body_=$name_
    printf "$name_ () {\n    rgb -n $body_ "'"$@"'" \n}\n\n" >> $(crayons)
}

source_crayons () {
    local crayons_=$(crayons) name=$1 body_=$2
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
