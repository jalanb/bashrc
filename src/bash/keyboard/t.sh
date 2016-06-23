#! /bin/cat

# x

t () {
    wwts "$@"
}

# xx

tf () {
    [[ $? -eq 0 ]] && echo "true" || echo "false"
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
    cd $(tar ${contents}f $1 | hd1)
    ra
}

# xxx

ttt () {
    wwts tool
}

