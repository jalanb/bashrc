
first_num () {
    num=$(mython $JAB_SRC/python/first_num.py "$@")
    args=$(mython $JAB_SRC/python/first_num.py --Invert "$@")
    [[ -n $num ]]
}
