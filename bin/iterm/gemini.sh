#! /usr/bin/env bash

cd $(dirname "$BASH_SOURCE")
source local.env
bash in_projects.sh /opt/homebrew/bin/gemini
# bash in_projects.sh npx --yes https://github.com/google-gemini/gemini-cli
