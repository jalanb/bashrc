# src/bash/git

This directory provides git-handling as a collection of `bash` functions
 - stored in a number of script files

## Scripts

### __init__.sh

This file is sourced from ../__init__.sh, which is sourced from ... ~/.bashrc at login

This file sources other files in the directory

### completion.sh

This script is intended to ensure integration of `git` commands and functions into bash's tab completion system

### functons.sh

This is a generic "catch all" script: if a git-related function does not fit into another specialised script, then it goes in here.

### hub.sh

Specific functions for dealing with GitHub

### gsi.sh

An app for reviewing, adding, commiting, etc, files in a menu system from CLI. It provides an "interactive status for git", hence the "gsi" name

Has many functions, but the first 4 in the file are used as entry points.

### status.sh 

Functions to parse output from `git status`

### Old code

Please ignore gfff.sh and statuses.sh


