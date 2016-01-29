#! /bin/cat


_find_python () {
    [[ -e $PYTHON ]] && return 0
    MY_PATH=$jab/bin:$HOME/bin:/usr/local/bin:/usr/bin
    PYTHON=$(PATH=$MY_PATH which python2.7 2>/dev/null)
    [[ -z $PYTHON ]] && PYTHON=$(which python2.7 2>/dev/null)
    export PYTHON
    [[ -n $PYTHON ]]
}

_run_python () {
    local script=$1; shift
    if [[ -f "$script" ]]; then
        if _find_python; then
            $PYTHON $script "$@"
        else
            echo "Could not find python" >&2
            return 1
        fi
    else
        echo $script is not a file >&2
    fi
}

