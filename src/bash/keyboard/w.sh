#! /bin/cat

typed () {
    type "$1" >/dev/null 2>&1
}

if [[  -f ~/whyp.sh ]]; then
    missing_w=
    typed w || missing_w=w 
    typed ww || missing_w=ww
    [[ $missing_w ]] && . ~/whyp.sh
else
    alias .=whyp_source
    alias w=whyp
    alias .w="whyp_source $WHYP_SOURCE"
    alias wq="quietly whyp "
fi
