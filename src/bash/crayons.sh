#! /bin/cat

[[ $NO_COLOUR ]] || . ~/jab/environ.d/colour.sh

# xxxxxxxx

show_red () {
    show_colour $RED "$@"
}

# xxxxxxxx

show_blue () {
    show_colour $BLUE "$@"
}

# xxxxxxxxxx

show_error () {
    show_red_line "$@" >&2
    return 1
}
alias show_fail=show_error

show_lblue () {
    show_colour $LIGHT_BLUE "$@"
}

show_green () {
    show_colour $GREEN "$@"
}

# xxxxxxxxxxx

show_colour () {
    local colour_=$1
    shift
    local eol_= text_="$@"
    if [[ $* =~ (^|[\ ])-l ]]; then
        eol_="\n"
        text_=$(echo $text_ | sed -e 's,\(^\|[ ]\)-l,,g')
        shift
    fi
    if [[ "$text_" ]];
    then printf "${colour_}$text_""${NO_COLOUR}${eol_}"
    else printf "${colour_}$(cat)${NO_COLOUR}${eol_}"
    fi
}

# xxxxxxxxxxxx

is_command () {
    type $1 >/dev/null 2>&1
}

show_command () {
    show_lblue_line '$' "$@"
}

# xxxxxxxxxxxxx

show_red_line () {
    show_red "$@" -l
}
alias red_line=show_red_line

# xxxxxxxxxxxxxxx

show_blue_line () {
    show_blue "$@" -l
}
alias blue_line=show_blue_line
alias show_cmnd=show_blue_line
# xxxxxxxxxxxxxxx

show_green_line () {
    show_green "$@" -l
}
alias green_line=show_green_line
alias show_pass=show_green_line

show_lblue_line () {
    show_lblue "$@" -l
}
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
        else show_colour $LIGHT_GREEN $(cat ~/fd1)
        fi
    fi
    if test -s ~/fd2; then
        show_colour $RED $(cat ~/fd2)
    fi
}

show_run_command_old () {
    show_command "$@"
    "$@"
}

show_this_branch () {
    git branch $1 | grep --colour -B3 -A 3 $(get_branch)
}

