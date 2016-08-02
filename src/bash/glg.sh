glg () {
    _glg _glg_header "$@"
    local _header=$1; shift
}

_glg () {
    local _header=$1; shift
    local _number_of_commits=7
    if [[ $1 =~ [[:digit:]] ]]; then
        _number_of_commits=$1
        shift
    fi
    git log -n$_number_of_commits --stat --color "$@" | $header
    _gl lg -n$_number_of_commits "$@" | _call_me_alan | sed -e "s/ ago//"
}

glog () {
    _glg _glog_header "$@"
}

_glg_header () {
    head -n $(( $LINES / 3 ))
}

_glog_header () {
    cat
}


