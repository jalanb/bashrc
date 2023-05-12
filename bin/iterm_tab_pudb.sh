#! /bin/bash
 
freds=$(fd -e py fred .)
$freds="$freds $(fd -e py fred ~/tmp)"
[[ $freds ]] || freds=$(fd -e py fred /tmp)

for fred in $freds; do
    pudb $fred
    break  # only debug first found
done
