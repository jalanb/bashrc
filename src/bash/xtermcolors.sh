#!/bin/bash
# Copyright (C) 2012 Trevor Woerner <twoerner@gmail.com>

which tput > /dev/null 2>&1
if [ $? -ne 0 ]; then
        echo "sorry, the required program 'tput' can't be found"
        exit 1
fi

COLOUR=0
MAXCOLOUR=$(tput colors)
echo "TERM = $TERM"
echo "this terminal type supports $MAXCOLOUR colour(s)"

WIDE=0
LINES=$(tput lines)
if [ $MAXCOLOUR -gt $LINES ]; then
        WIDE=1
fi

MAXCOLS=$(tput cols)
COL=1
while [ 1 ]; do
        ESC=$(tput setaf $COLOUR 2> /dev/null)
        printf "%s%3d" $ESC $COLOUR
        COL=`expr $COL + 3`
        if [ $WIDE -eq 0 ]; then
                echo ""
                COL=1
        else
                if [ `expr $COL + 4` -gt $MAXCOLS ]; then
                        echo ""
                        COL=1
                else
                        echo -n " "
                        COL=`expr $COL + 3`
                fi
        fi

        COLOUR=`expr $COLOUR + 1`
        if [ $COLOUR -gt $MAXCOLOUR ]; then
                break
        fi
done
echo ""

exit 0

