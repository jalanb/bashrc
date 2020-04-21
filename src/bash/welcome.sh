TMP_WELCOMES=/tmp/welcomes

[[ -f $TMP_WELCOMES ]] || touch $TMP_WELCOMES

echo_host () {
    [[ $WELCOME_BYE ]] || return
    local _arg="$1"
    shift
    echo "$_arg $(hostname -f): ""$*"
}

Welcome_to () {
    local _welcome_time=$(error_free_time)
    echo "$1:$_welcome_time" >> $TMP_WELCOMES
    # echo_host "Welcome to" $1
}

Bye_from () {
    local _welcome_time=$(grep $1 $TMP_WELCOMES 2>/dev/null | sed -e s,.*:,, )
    local _name=${1//\//.}
    [[ $_name ]] && sed -i -e "/$_name/d" $TMP_WELCOMES
    [[ $_welcome_time ]] || return 1
    local _bye_time=$(error_free_time)
    [[ $_bye_time ]] || return 1
    local _diff=$(( $_bye_time - $_welcome_time ))
    [[ $_diff == 0 ]] && return 0
    # echo_host "Bye from" $1
    echo "$_diff seconds: $1"
}


error_free_time () {
    python_time 2>/dev/null
}

clean_welcomes () {
    echo "" > $TMP_WELCOMES
}
