#! /bin/cat

# x

t () {
    c "$@"
    tig -- .
}

# xx

tf () {
    [[ $? -eq 0 ]] && echo "true" || echo "false"
}

tl () {
    tree -d -L 1
    l "$@"
}
    
tm () {
    if [[ -z $1 ]]; then SESSION=$(jostname)
    else
        SESSION=$1
        shift
    fi
    ! tmux attach-session -t $SESSION "$@" && tmux new-session -s $SESSION "$@"
}

tt () {
    if echo $1 | grep -q "gz$"; then
        contents=tz
        extract=xz
    else
        contents=t
        extract=x
    fi
    tar ${extract}f $1
    cd $(tar ${contents}f $1 | head -n 1)
    ranger
}

tx () {
    if echo $1 | grep -q "gz$"; then
        contents=tz
        extract=xz
    else
        contents=t
        extract=x
    fi
    tar ${extract}f $1
    cd $(tar ${contents}f $1 | hd1)
    ra
}

# xxx
#
tel () {
    # Using "$*" instead of "$@" deliberately here
    # Side effect: args are now text, not args
    HEADLINES=${HEADLINES:-(( ${LINES:-$(screen_height)} / 2 ))}
    head -n ${1:-$HEADLINES} "$@"
    lines=$(echo "$*" | sed -e "s/ *-n.\([0-9]\+\)/\1/")
    if [[ -n $lines ]]; then
        args=$(echo "$*" | sed -e "s/^\(.*\) *-n.\([0-9]\+\)\(.*\)/\1\3/")
        echo tel $lines $args
        tail -n $lines $args
    else
        tail -n $(( ${LINES:-$(screen_height)} / 2 )) "$@"
    fi
}

tma () {
    tmux new-session -A -s jabtmux
}

tmp () {
    cde ~/tmp
}

too () {
    PYTHONPATH= tox "$@"
}

tti () {
    tty | cut -d'/' -f3
}
