# ~/jab

This directory holds my expanded `.bashrc`

It started as a (normal) single file `~/.bashrc`, but has now expanded into this project, and at least four other (bash and python)

Hence: this directory is a clone from https://github.com/jalanb/bashrc.git

## Links from $HOME

Very many of the "normal $HOME files", are actually links into `~/jab`, for example
- ~/.bashrc -> ~/jab/home/bashrc
- ~/.bash_profile -> ~/jab/home/bash_profile
- ~/.editrc -> ~/jab/home/editrc
- ~/.gitconfig -> ~/jab/home/gitconfig
- ~/.inputrc -> ~/jab/home/inputrc
- ~/.vimrc -> ~/jab/home/vimrc

Similarly a lot of the "significant sub-dirs" under ~/jab are linked to $HOME, for example
- ~/bash -> ~/jab/src/bash
- ~/keys -> ~/jab/src/bash/keyboard/
- ~/python -> ~/jab/src/python
- ~/vim -> ~/jab/vim

And, files that I need to edit often, for example
- ~/prompt.sh -> ~/jab/src/bash/prompt.sh
- ~/bash.sh -> ~/jab/src/bash/functons.sh
- ~/git.sh -> ~/jab/src/bash/git/functons.sh

## Helper projects

Sub-projects that have been separated out of the main project over the years, but are still called from this one are

- cde: An enhanced version of `cd` that predicts next dir from history
- whyp: An enhanced version of `type`
- ackvim: Find with ack, send paths to vim
- pysyte: A python project that provides the "extra batteries" needed for all this

## Startup

In the normal way: bash calls `~./bashrc`
  - `jab/bashrc` sources `jab/__init__.sh`
  - `jab/__init__.sh` sources
    - cde.sh
    - whyp.sh
    - ackvim.sh
    - jab/environ.d/__init__.sh
    - jab/bash/__init.sh
    - etc
  - `jab/bash/__init__.sh` sources
    - `jab/bash/crayons.sh`
    - `jab/bash/functons.sh`
    - `jab/bash/hosts.sh`
    - `jab/bash/prompt.sh`
    - `jab/bash/python.sh`
    - `jab/bash/keys.sh`
    - etc
- `jab/bash/keys.sh` calls `read_keys` 
    - `read_keys` concatenates `jab/bash/keyboard/*.sh` into `jab/bash/keyboard/__init__.sh
    - `jab/bash/keys.sh` then sources `jab/bash/keyboard/__init__.sh`

One other file is special:
- `bash/crayons.sh` writes `bash/crayons.sh.sh` and then sources that.
   - `crayons.sh` has all the generic colour-related functions, e.g. "show_command, show_fail, etc"
   - `crayons.sh.sh` has functions like, e.g., "red, red_line, green, green_line, cyan, cyan_line, etc" 
 

## Sources

As an "extended bashrc" the vast majority of sources here are in `bash`. There are a few python scripts too, and a few other bits 'n' bobs, but mainly bash.

And very few "scripts" - pretty much all the files should be _sourced_, not "run", and enhance the interacctive shell with bash functions

Pretty much any command I've used in the last few decades which was too long (all of them!) or too complicated (many of them) got written into a function.

There's an entire sub-dir dedicated to "too long": `jab/bash/keyboard`, which has files `jab/bash/keyboard/a.sh`, `jab/bash/keyboard/b.sh`, `jab/bash/keyboard/c.sh`, etc.
    And they all have functions with 1/2/3 letter names, like `v` to run `MacVim`, `vv` to run `vim` in cli, `vvv` to `vim ~/.vimrc`, and so on
    There may be a few functions in there with 4/5/... letter names, but I should extract them.

## Clean out

We have `git` for history, and should not get sentimental, nor scared.

So the entire set of functions needs a clean-out!
Project idea: search through entire bash history, see how often /how long since each function was called, and then remove the functions that are called less often.

## Features

Some features of the code

### History

We store a full history in `~/.bash_eternal_history` (not `~/.bashrc_history`)

And "full history" means we _never_ prune it. It should be the entire history of this $USER since first day on this machine.

Plus: we have history from other machines in archives, and available on request.

### Prompt

Shows day in red, time in light red; python version in green, python venv in light green; git origin in blue, git branch in light blue
Next line: shows an emoji for `$?` of last command (smiley for `0`/success, various icky emojis for error code)

### Etc

Ask me to add any more sections you need here
