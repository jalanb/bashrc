#! /bin/cat


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

