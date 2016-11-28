#! /bin/cat

# x

if [[ -f /usr/local/bin/gls ]]; then
	l () {
	    /usr/local/bin/gls --group-directories-first --color -htr "$@"
	}
else
	l () {
	    ls -htr "$@"
	}
fi


# xx

la () {
    l -a "$@"
}

lg () {
    l -g "$@"
}

ll () {
    l -l "$@"
}

# xxx

lal () {
    l -a -l "$@"
}

lll () {
    ll -a "$@"
}
