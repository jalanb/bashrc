
bashed=
[[ "$BASH_SOURCE" == "$0" ]] && bashed=1

sourced=
[[ "$BASH_SOURCE" != "$0" ]] && sourced=1

[[ $bashed ]] && echo bashed
[[ $sourced ]] && echo sourced
