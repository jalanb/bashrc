#! /bin/cat

# x

if [[ -f /usr/local/bin/gls ]]; then
	l () {
	    /usr/local/bin/gls --group-directories-first --color -h "$@"
	}
else
	l () {
	    ls -h "$@"
	}
fi


# xx

l1 () {
    l -1 "$@"
}

la () {
    l -a "$@"
}

lg () {
    l -g "$@"
}

ll () {
    l -l "$@"
}

lt () {
    l -t "$@"
}

# xxx

lal () {
    l -a -l "$@"
}

lll () {
    ll -a "$@"
}

ltr () {
    lt -r "$@"
}
