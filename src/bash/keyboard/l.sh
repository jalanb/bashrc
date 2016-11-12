#! /bin/cat

# x

if [[ -f /usr/local/bin/gls ]]; then
	l () {
	    /usr/local/bin/gls --group-directories-first --color "$@"
	}
else
	l () {
	    ls "$@"
	}
fi


# xx

la () {
    l -a "$@"
}

li () {
    l -g "$@"
}

ll () {
    l -l "$@"
}

lo () {
    ll -htr "$@"
}

lp () {
    l "$@" *.py
}

# xxx

lll () {
    lo -a "$@"
}
