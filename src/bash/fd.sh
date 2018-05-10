devnull0 () {
    cat 
}


devnull1 () {
    cat > /dev/null
}
alias devnull=devnull1

devnull2 () {
    cat 2> /dev/null
}

alias fd0=devnull0
alias fd1=devnull1
alias fd2=devnull2

alias  fd=devnull

