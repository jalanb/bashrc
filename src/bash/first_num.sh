
first_num () {
    num=$(mython ~/jab/jab/src/python/first_num.py "$@")
    args=$(mython ~/jab/jab/src/python/first_num.py --Invert "$@")
    [[ -n $num ]]
}
