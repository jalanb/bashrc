#! /bin/cat

# x

if [[ -f /usr/local/bin/gls ]]; then
	l () {
	    /usr/local/bin/gls --group-directories-first --color -h "$@"
	}
else
    _dir_option=
    ls -l  --group-directories-first 2>&1 | grep -q unrecognized || _dir_option=--group-directories-first
    _color_option=
    ls -l --color 2>&1 | grep -q unrecognized || _color_option=--color
	l () {
	    ls $_dir_option $_color_option -h "$@"
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
