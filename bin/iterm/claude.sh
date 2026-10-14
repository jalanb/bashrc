#! /usr/bin/env bash
export ITERM3_START_DIR=/opt/clones/github/jalanb
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export DISABLE_GROWTHBOOK=1

dir_="$(dirname "${BASH_SOURCE[0]}")"
run_="$(readlink -f "$dir_/in_projects.sh")"
bash "$run_" claude "$@"
