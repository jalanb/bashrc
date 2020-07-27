
type_ () {
    type "$1" 2>/dev/null
}

typed () {
    type "$1" >/dev/null 2>&1
}

