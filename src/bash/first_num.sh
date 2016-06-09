
first_num () {
    num=$(mython ~/jab/src/python/first_num.py "$@")
    args=$(mython ~/jab/src/python/first_num.py --Invert "$@")
    [[ -n $num ]]
}
