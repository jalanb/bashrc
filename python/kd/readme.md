kd
==

kd is a smarter cd.

It knows more about the directories you are going to because it knows which ones you have gone to. It is written in Python for use at the bash shell.

The script gets a close match to a directory from command line arguments then prints that to stdout which allows a usage in bash like

    $ cd $(python kd.py /usr local bin)
    $ cd $(python kd.py /bin/ls)

Setup
-----

For convenience a bash function is also provided, which can be set up like

    $ source kd.sh

Then one can use `kd` as a replacement for cd

    $ cd /usr/local/lib/python2.7/site-packages
    $ kd /usr lo li py si

Use
---

First argument is a directory, subsequent arguments are prefixes of sub-directories. For example:

    $ kd /usr/local bi

is equivalent to

    $ cd /usr/local/bin

Or first argument is a file (cd'ing to a file can be very handy in conjuction with copy-and-paste of filenames), for example

    $ kd /bin/ls
    
is equivalent to

	$ cd /bin

Or the first argument is a stem of a directory/file. kd.py will add `*` on to such a stem, and cd to whatever that matches (see below). For example, `/bin/l*` matches `/bin/ls`, which is an existing file, whose parent is `/bin`. This can be handy when tab-completion only finds part of a filename

    $ kd /bin/l

If nothing matches then it tries directories in $PATH which have matching executables. For example, this will give `/bin`:

    $ kd ls

When looking for partial names kd will look for each of these in turn, stopping as soon as it gets some match

1. directories with the same name
2. directories that start with the given part
3. files that start with the given part
4. directories with the part in their name
4. files with the part in their name
