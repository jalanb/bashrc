#! /bin/cat

. ~/bash/welcome.sh

Welcome_to $BASH_SOURCE

# xxxxxxxx

show_red () {
    show_colour "${RED}""$*"
}

# xxxxxxxxxx

show_error () {
    show_red_line "$@"
    return 1
}

show_green () {
    show_colour "${GREEN}""$*"
}

# xxxxxxxxxxx

show_colour () {
    printf "$*""${NO_COLOUR}" >&2
}

# xxxxxxxxxxxx

show_command () {
    show_green_line "$ ""$*"
}

# xxxxxxxxxxxxx

show_red_line () {
    show_colour_line "${RED}""$*"
}
alias red_line=show_red_line
alias show_fail=show_red_line

# xxxxxxxxxxxxxxx

show_green_line () {
    show_colour_line "${GREEN}""$*"
}
alias green_line=show_green_line
alias show_pass=show_green_line

# xxxxxxxxxxxxxxxx

show_colour_line () {
    printf "$*""${NO_COLOUR}\n" >&2
}

show_run_command () {
    show_command "$@"
    "$@"
}

show_this_branch () {
    git branch $1 | grep --colour -B3 -A 3 $(current_branch)
}

Bye_from $BASH_SOURCE
