---
name: Jab shell project
description: Architecture, key facts, and in-flight work for jalanb/bashrc (the ~/jab project)
type: project
---

Main repo: https://github.com/jalanb/bashrc — lives at ~/jab (also at /opt/clones/github/jalanb/bashrcs/jab)

## Startup chain
~/.bashrc → ~/jab/home/bashrc → ~/jab/__init__.sh → ~/jab/src/bash/__init__.sh

__init__.sh sources external projects: whyp.sh, ackvim.sh, pyth.sh, cde.sh, jab/environ.d/__init__.sh, jab/src/bash/__init__.sh

src/bash/__init__.sh sources: tput.sh, aliases.sh, asserts.sh, crayons.sh, functons.sh, github.sh, hosts.sh, history.sh, jabnet.sh, prompt.sh, python.sh, work.sh, git/__init__.sh, keys.sh → then calls keys_read

## Helper projects (external GitHub repos)
- cde: enhanced cd with directory prediction from history
- whyp: enhanced `type` command
- ackvim (jalanb/avs): find with ack, send paths to vim
- pysyte: Python "extra batteries" library
- pyth (jalanb/pyth): another Python helper

## Key modules
- functons.sh: 1500+ lines, primary function library
- crayons.sh: color system, auto-generates crayons.sh.sh with named color functions
- git/: comprehensive git workflow (git/functons.sh ~1500+ lines)
- keyboard/: ultra-short aliases (a.sh-z.sh, 1/2/3 letter functions), dynamically compiled at startup
- keys.sh: manages keyboard system, git branch for keys
- prompt.sh: custom prompt (day/time in red, python venv in green, git in blue, emoji for exit code)
- history.sh: eternal bash history in ~/.bash_eternal_history (never pruned)

## Home symlinks
~/.bashrc → ~/jab/home/bashrc
~/bash → ~/jab/src/bash
~/keys → ~/jab/src/bash/keyboard/
~/python → ~/jab/src/python
~/prompt.sh, ~/bash.sh, ~/git.sh → src/bash files

## Python side
Python 3.13+, tox, uv, venv at ~/jab/.venv (auto-activated), pyproject.toml
Testing: py.test --doctest-modules

## Clone structure
/opt/clones/github/jalanb/bashrcs/ contains jab/ (__main__) and alan/ clones
Multiple clones per project is Alan's standard pattern; `__main__` is preferred, then project-name clone, then most recently modified.
`projects-clones` tool (planned) will deduplicate paths by project across clone dirs.

## hub/ directory
Alan uses hub/ as a design-doc/planning area for in-flight ideas:
- hub/sibh.md — "sibh" (pronounced "shiv"): planned iTerm2 + Textual command picker overlay (fzf-style for entire command ecosystem). iTerm2 KeystrokeMonitor + Textual UI. Lives in ~/jab/bin/sibh + ~/jab/src/python/site/sibh.py
- hub/pyv.md — pyv: Python version switcher via /opt/pythons PATH manipulation (no shims, no pyenv indirection). Partially implemented in src/bash/python.sh. /opt/pythons doesn't exist yet.
- hub/review-jab.md — IN PROGRESS: making bashrcs user-agnostic (remove 185 hardcoded "jab" path refs in 44 files). home/.link done; home/bashrc, __init__.sh, environ.d/jab.sh, src/bash/*.sh still TODO.
- hub/wishes.md — wishlist: better tab completion, usage-frequency charts for functions (mine bash_eternal_history), Python wrappers for bash functions.
- hub/projects-clones.md — tool to deduplicate paths by project across multiple clones.

## Project goal (in this Cowork session)
"Make me a better shell, starting at my bashrc" — ongoing improvement project.

**Why:** Decades of accumulation = bloat. DRY and YAGNI need enforcement.
**How to apply:** Before suggesting new functions, check what exists. Before adding complexity, check if it's actually used. Check existing in-flight work in hub/ before suggesting new ideas.
