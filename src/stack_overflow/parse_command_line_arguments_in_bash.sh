#! /bin/bash

# http://stackoverflow.com/a/14203146/500942

# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# > 1 ]]
do
key="$1"

case $key in
    -e|--extension)
    EXTENSION="$2"
    shift # past argument
    ;;
    -s|--searchpath)
    SEARCHPATH="$2"
    shift # past argument
    ;;
    -l|--lib)
    LIBPATH="$2"
    shift # past argument
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done
echo FILE EXTENSION  = "${EXTENSION}"
echo SEARCH PATH     = "${SEARCHPATH}"
echo LIBRARY PATH    = "${LIBPATH}"
echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi

