#! /bin/bash -x

git fetch --prune --all
git remote update origin --prune
git fetch --tags --prune-tags --prune origin refs/tags/*:refs/tags/*
git gc
git branch
(set +x; git branch | grep -q '[*] master') || git checkout master
git pull --rebase
git status --short
git lg -n3
