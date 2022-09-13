#! /bin/cat

typed () {
    type "$1" >/dev/null 2>&1
}

if [[  -f ~/whyp.sh ]]; then
    missing_w=
    typed w || missing_w=w 
    typed ww || missing_w=ww
    [[ $missing_w ]] && . ~/whyp.sh
fi

wtf () {
    local status_=$1 name_=Pass out_=1 err_=1
#   [[ $PROMPT_STATUS ]] && status_=$PROMPT_STATUS
    [[ $1 ]] && status_=$1 && shift
    [[ $status_ == 0 ]] || name_=Fail
    [[ $name_ == Fail ]] && out_=
    [[ $name_ == Pass ]] && err_=
    [[ $1 =~ -[qQ] ]] && out_=
    [[ $1 =~ -[Q] ]] && err_=
    message_="$name_ $status_ $(face $status_)" 
    if [[ $name_ == Pass ]]; then
        [[ $out_ ]] && echo $message_
    elif [[ $name_ == Fail ]]; then
        [[ $err_ ]] && echo $message_ >&2
    fi
    [[ $name_ == Fail ]] && return $status_
    return 0
    local __doc__="""Errors from a status"""
}
