#! /bin/cat


# x
# _
# x
# ,x

.a () {
    . $(aliases)
}

.b () {
    sb
}

.f () {
    sf
}

.g () {
    sgf
}

.l () {
    slf
}

.x () {
    export PS4='+ [${BASH_SOURCE##*/}:${LINENO}]'
    set -x
}

.z () {
    set +x
    export PS4=
}


