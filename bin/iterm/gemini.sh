#! /usr/bin/env bash

cd /opt/clones/github/jalanb
pwd
export PATH=/opt/homebrew/bin:$PATH
source ./local.env
npx https://github.com/google-gemini/gemini-cli
