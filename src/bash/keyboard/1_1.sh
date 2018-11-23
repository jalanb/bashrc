#! /bin/cat

Welcome_to $BASH_SOURCE

known_subs () {
    local _parent=$(basename $(readlink -f .))
    echo "$_parent bin local development master"
}

first_sub () {
    for dir in $(known_subs "$1"); do
        test -d $dir || continue
        break
    done
    echo "$dir"
}

home_path () {
    readlink -f ~/"$1"
}

. ~/bash/add_to_a_path.sh

. ~/bash/keyboard/2.sh
