Welcome_to () {
    [[ -z $WELCOME_BYE ]] && return
    echo "Welcome to $1 on $(hostname -f)"
}

Bye_from () {
    [[ -z $WELCOME_BYE ]] && return
    echo "Bye from  $1 on $(hostname -f)"
}


