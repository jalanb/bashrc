#! /bin/bash
 
quietly () {
    "$@" 2>/dev/null
}

find_freds () {
    quietly fd -e py fred "$1"
}

for dir in "." "~/tmp" "/tmp"; do
    freds=$(find_freds $dir )
    [[ $freds ]] && break
done

for fred in $freds; do
    pudb $fred
    break  # only debug first found
done
