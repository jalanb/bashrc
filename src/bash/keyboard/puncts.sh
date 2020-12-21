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
# .x

.v () {
    . .venv/bin/activate
}
