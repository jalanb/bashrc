#! /bin/cat

# x

t () {
    c "$@"
    tig -- .
}

# xx

tl () {
    tree -d -L 1
    l "$@"
}
    
tt () {
    try .
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

