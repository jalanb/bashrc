#! /bin/cat

Welcome_to $BASH_SOURCE

clock () {
    while sleep 1
    do
        tput sc
        tput cup 0 $(($(tput cols)-29))
        date
        tput rc
    done &
}

screen_height () {
    tput lines
}

screen_width () {
    tput cols
}

Bye_from $BASH_SOURCE
