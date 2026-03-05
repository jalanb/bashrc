#! /usr/bin/env bash

cd $(dirname "$BASH_SOURCE")
source local.env
bash in_projects.sh codex "$@"
