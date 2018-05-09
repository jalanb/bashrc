#! /bin/cat

_link_to_usr_local_gnu () {
    for f in $( (cd /usr/local; (cd bin; ls g*;) | ( ([[ -d gnu ]] || mkdir gnu); (cd gnu; sed -e s/^g//;) )) ); do
        [[ -f $f ]] || ln -s ../bin/g${f} $f
    done 2> ~/bash/fd/2 | lines_to_spaces
}

prefer_gnu () {
    _link_to_usr_local_gnu
    export PATH=/usr/local/gnu:$PATH
}


