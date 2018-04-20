#! /bin/cat

# x

if [[ -f /usr/local/bin/gls ]]; then
	lj () {
	    /usr/local/bin/gls --group-directories-first --color -h "$@"
	}
else
    _lj_dir_option=
    ls -l  --group-directories-first 2>&1 | grep -q unrecognized || _lj_dir_option=--group-directories-first
    _lj_color_option=
    ls -l --color 2>&1 | grep -q unrecognized || _lj_color_option=--color
	lj () {
	    ls $_lj_dir_option $_lj_color_option -h "$@"
	}
fi

l () {
    lj "$@"
}

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
