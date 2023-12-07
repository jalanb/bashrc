#! /bin/cat


# x
# _
# x
# ,x

,. () {
    [[ -f .cd ]] && . .cd
}

,, () {
    cde . "$@"
}

,c () {
    . $CDE.sh
}

,w () {
    . $WHYP.sh
}

.a () {
    . $(aliases)
}

.b () {
    . ~/.bashrc
}

.c () {
    . ~/cde.sh
}

.f () {
    . $(functons)
}

.g () {
    . $(functons -g)
}

.l () {
    JAB_LOCAL_FUNCS= . $(functons -l)
}

.p () {
    . ~/prompt.sh "$@"
}

.w () {
    . ~/whyp.sh
}

.x () {
    export PS4='+ [${BASH_SOURCE##*/}:${LINENO}]'
    set -x
}

.z () {
    set +x
    export PS4=
}


