#! /bin/bash
 
quietly () {
    "$@" 2>/dev/null
}

fred_py () {
    quietly fd -e py fred "$1"
}

for dir in "." "~/tmp" "/tmp"; do
    freds=$(fred_py $dir )
    for fred in freds; do
        pudb $fred
    done
done
