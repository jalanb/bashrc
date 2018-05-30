#! /bin/cat

# x

if [[ -f /usr/local/bin/gls ]]; then
	jl () {
	    /usr/local/bin/gls --group-directories-first --color -h "$@"
	}
else
    _lj_dir_option=
    ls -l  --group-directories-first 2>&1 | grep -q unrecognized || _lj_dir_option=--group-directories-first
    _lj_color_option=
    ls -l --color 2>&1 | grep -q unrecognized || _lj_color_option=--color
	jl () {
	    ls $_lj_dir_option $_lj_color_option -h "$@"
	}
fi

l () {
    local _one=-1
    if [[ $* =~ "-1" ]]; then
        _one=
        shift
    fi
    jl $_one "$@"
}

# xx

l0 () {
    ll -htrLo "$@"
}

lo () {
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

lr () {
    ll -htr "$@"
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
