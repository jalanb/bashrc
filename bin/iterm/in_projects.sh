#! /usr/bin/env bash

dir_="${ITERM3_START_DIR:-/opt/clones/github/jalanb}"
[[ -d "$dir_" ]] && cd "$dir_" || exit 1
pwd
export PATH=~/.local/bin:/opt/homebrew/bin:$PATH
"$@"

