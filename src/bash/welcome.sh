[[ -f /tmp/welcomes ]] || touch /tmp/welcomes

echo_host () {
    [[ -z $WELCOME_BYE ]] && return
    local _arg="$1"
    shift
    echo "$_arg $(hostname -f): ""$*"
}

Welcome_to () {
    local _welcome_time=$(error_free_time)
    echo "$1:$_welcome_time" >> /tmp/welcomes
    # echo_host "Welcome to" $1
}

Bye_from () {
    local _welcome_time=$(grep $1 /tmp/welcomes | sed -e s,.*:,, )
    local _bye_time=$(error_free_time)
    local _name=${1//\//.}
    [[ $_name ]] && sed -i -e /$_name/d /tmp/welcomes
    local _diff=$(( $_bye_time - $_welcome_time ))
    [[ $_diff == 0 ]] && return 0
    echo "$_diff seconds: $1"
}


error_free_time () {
    python_time 2>/dev/null
}

python_time () {
    python << EOP
import datetime

def taken(diff, days=True):
    seconds = diff.seconds
    if not days:
        return seconds
    result = abs(diff.days * 24 * 60 * 60 + seconds)
    return result

then = datetime.datetime.fromtimestamp(0)
now = datetime.datetime.now()
since = now - then
print(taken(since))
EOP

}
