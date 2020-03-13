_echo () {
    [[ -z $WELCOME_BYE ]] && return
    echo "$1 $2 to $3 on $(hostname -f)" | grep --color "[/][^/]* "
    # [[ $4 ]] || return
    # local _start=0 _end=$4
    # echo $(( $_end - $_start ))
}

Welcome_to () {
    local _welcome_time=$(python_time $1)
    _echo Welcome to $1 at $_welcome_time
}

Bye_from () {
    local _bye_time=$(python_time $1)
    _echo Bye from  $1 at $_bye_time
}


python_time () {
    local _key=$1
    python << EOP
import datetime

def taken(diff, days=True):
    seconds = diff.seconds * 1_000 + diff.microseconds
    if days:
        return seconds
    result = abs(diff.days * 24 * 60 * 60 + seconds)
    return result

then = datetime.datetime.fromtimestamp(0)
now = datetime.datetime.now()
since = then - now
print(taken(since))
EOP

}

time_name () {
    sed -e "s:[/ ]*:_:g"
}

welcome_time () {
    local _key=$(time_name "$1") _value=$(python_time)
}
