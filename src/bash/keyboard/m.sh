#! /bin/cat


# _
# x

alias m=echo
# _x
# xx

mvim () {
    local _mvim=/Applications/MacVim.app/Contents/bin/mvim 
    ([[ "$@" ]] && $_mvim --remote-tab "$@" || $_mvim --remote) > ~/log/mvim.log 2> ~/log/mvim.err
}

