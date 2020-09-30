#! /bin/cat



[[ $NO_COLOUR ]] || . ~/jab/environ.d/colour.sh

# xxxxxxxx

show_red () {
    show_colour $RED "$*"
}

# xxxxxxxxxx

show_error () {
    show_red_line "$@"
    return 1
}

show_green () {
    show_colour $GREEN "$*"
}

# xxxxxxxxxxx

show_colour () {
    local line_=
    if [[ $1 =~ -n ]]; then
        line_="\n"
        shift
    fi
    if [[ "$@" ]];
    then printf "$*""${NO_COLOUR}${line_}"
    else printf "${GREEN}$(cat)${NO_COLOUR}${line_}"
    fi
}

# xxxxxxxxxxxx

is_command () {
    type $1 >/dev/null 2>&1
}

show_command () {
    if is_command w
    then w "$@"
    else show_blue_line '$ '"$*"
    fi
}

# xxxxxxxxxxxxx

show_red_line () {
    show_colour_line $RED "$*"
}
alias red_line=show_red_line
alias show_fail=show_red_line

# xxxxxxxxxxxxxxx

show_blue_line () {
    show_colour_line $LIGHT_BLUE "$*"
}
alias blue_line=show_blue_line
alias show_cmnd=show_blue_line
# xxxxxxxxxxxxxxx

show_green_line () {
    show_colour_line $GREEN "$*"
}
alias green_line=show_green_line
alias show_pass=show_green_line

# xxxxxxxxxxxxxxxx

show_colour_line () {
    show_colour -n "$@"
}

show_run_command () {
    show_command "$@"
    echo
    "$@" > ~/fd1 2> ~/fd2
    if grep -q '0m' ~/fd1
    then cat ~/fd1
    else show_colour $LIGHT_GREEN $(cat ~/fd1)
    fi
    show_colour $RED $(cat ~/fd2)
}

show_run_command_old () {
    show_command "$@"
    "$@"
}

show_this_branch () {
    git branch $1 | grep --colour -B3 -A 3 $(get_branch)
}

