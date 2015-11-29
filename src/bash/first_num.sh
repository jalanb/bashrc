
first_num () {
    num=$(mython $JAB/src/python/first_num.py "$@")
    args=$(mython $JAB/src/python/first_num.py --Invert "$@")
    [[ -n $num ]]
}
