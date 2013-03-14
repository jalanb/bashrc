ackg
====

With `ackg` for Linux you can search folders of your harddrive for
source files containing a given pattern, similar to grep.

As `ackg` does not search all files, but only files that are supposed
to contain code, it can be faster than grep.

It attempts to be a more convenient method of calling GNU find, xargs,
(or parallel) and grep, by providing better default options and
command line structure.

`ackg` was inspired by `ack-grep <http://betterthangrep.com/>`_
a.k.a. just `ack`, whichis more portable than `ackg`.

License
-------
Copyright(C) 2012 Thibault Kruse
BSD License

Download
--------

For installation (and update to latest version) use pip::

  $ sudo pip install -U ackg

Source code and issue tracker at:
http://github.com/tkruse/ackg

Usage
-----

ackg is a command line tool.

usage: ackg [OPTIONS] PATTERN [PATH*]

* OPTIONS allows to change the behavior
* PATTERN defines what you search for
* PATH is a list of locations to search, defaults to current folder

See `ackg --help` for more details

Most useful options::

  -j=N runs your search in parallel, using multiple CPU cores if you have them. j=-1 is the default using one job less than the number of CPUs. See GNU parallel help on -j option.
  --dry tells you what command ackg runs, you can copy this and tweak it further. Note you have to have GNU parallel installed for that option.


.. contents::

Questions
=========

Why ackg?
---------

`ackg` attempt to make life easier for developers new to the command
line. `grep` is a useful tool to search files, but it does not have
convenient default behavior with respect to files you usually do not
want to search in as a developer, such a binary files, temporary
files, or files in version control repository folders like .svn or
.git.

`ackg` was created as an alternative to `ack-grep`. `ack-grep` does
whitelisted code-search, but reinvents the wheel by reimplementing
search, and it is written in Perl, which is not everyone's cup of
tea. The only advantage `ack-grep` has over `ackg` is portability to
other operating systems.

`ackg` is usually faster than `ack-grep` because it relies on
optimized code written in C to do the heavy lifting, and because
it offers to parallelize jobs, making full use of multiple CPUs.

`ackg` is free and open, you can read the code and contribute.

Alternatives
------------

Under Linux, `grep -ir PATTERN FOLDER*` will get you a long way. You
can make that your default behavior for searching within files. In
comparison to ackg, it will return some results you never cared about,
and it might be slower, though it can also be faster, in particular for
small searches.

`ack-grep` is useful for other operating systems, and it provides some
options ackg does not provide.

`grin` is another project that attempts to provide a more convenient
code search, but follows a different strategy. It does not even come
close to whitelisted search in terms of search performance, but may
still be your thing.

Combinations of find and grep exist that you might prefer.

If you search the same files regularly, indexed search can boost your
speed even more. Examples are Tracker, Beagle and Google Desktop.

For searching for function names in programming languages, tagging
solutions exist for most languages, but you have to read up on that.

How does it work?
-----------------

`ackg` creates a command that is run on the command line, and you can
see what it would run by using the --dry command.

As one example, the command::

  $ ackg foo

is translated to::

  $ find  .   -type f -not -iwholename '*/_darcs/*' -not -iwholename '*/SCCS/*'
  -not -iwholename '*/.hg/*' -not -iwholename '*/blib/*' -not -iwholename '*/~.dot/*'
  -not -iwholename '*/_MTN/*' -not -iwholename '*/_sgbak/*' -not -iwholename '*/cover_db/*'
  -not -iwholename '*/CVS/*' -not -iwholename '*/.pc/*' -not -iwholename '*/.cdv/*'
  -not -iwholename '*/.bzr/*' -not -iwholename '*/autom4te.cache/*' -not -iwholename '*/~.dep/*'
  -not -iwholename '*/~.plst/*' -not -iwholename '*/.svn/*' -not -iwholename '*/~.nib/*'
  -not -iwholename '*/RCS/*' -not -iwholename '*/.git/*' -not -iwholename '*/_build/*'
  -regex '\(.*/[^.]*\)\|\(.*\.\(c\|h\|xs\|txt\|rst\|md\|me\|vim\|m\|h\|hs\|lhs\|cs\|go\|pt\|cpt\|metadata\|cpy\|py\|xml\|dtd\|xsl\|xslt\|ent\|java\|properties\|yaml\|yml\|tt\|tt2\|ttml\|pl\|pm\|pm6\|pod\|t\|f\|f77\|f90\|f95\|f03\|for\|ftn\|fpp\|ada\|adb\|ads\|scm\|ss\|sh\|bash\|csh\|tcsh\|ksh\|zsh\|py\|rake\|h\|rb\|rhtml\|rjs\|rxml\|erb\|rake\|spec\|groovy\|gtmpl\|gpp\|grunit\|erl\|hrl\|pir\|pasm\|pmc\|ops\|pod\|pg\|tg\|lisp\|lsp\|tcl\|itcl\|itk\|bas\|cls\|frm\|ctl\|vb\|resx\|vhd\|vhdl\|el\|bat\|cmd\|tex\|cls\|sty\|bib\|faq\|man\|st\|scala\|pas\|int\|dfm\|nfm\|dof\|dpk\|dproj\|groupproj\|bdsgroup\|bdsproj\|mas\|mhtml\|mpl\|mtxt\|lua\|htm\|html\|shtml\|xhtml\|v\|vh\|sv\|as\|mxml\|css\|js\|jsp\|jspx\|jhtm\|jhtml\|sql\|ctl\|php\|phpt\|php3\|php4\|php5\|pht\|asm\|s\|mm\|h\|ml\|mli\|cpp\|cc\|cxx\|m\|hpp\|hh\|h\|hxx\|clj\|cfc\|cfm\|cfml\|mk\|mak\|make\|cmake\)$\)'
  -print0 | sort -z | xargs -0 -n 1000 grep --binary-files=without-match --color --line-number --with-filename foo | group_grep_output -k foo

Which would you rather type?

Looking a bit closer, the command looks like this::

  $ find . [options] -print0 | xargs -n 1000 [options] grep [options] | group_grep_output [options]

* find returns all files that satisfy the criteria given, which excludes certain folders and whitelists files by extention.
* xargs splits this list into chunks of 1000, and for each chunk invokes grep
* grep takes the argument foo and the list of files and prints the results
* group_grep_output formats the grep output like `ack-grep`

How much faster is ackg to ackgrep?
-----------------------------------

First of all I am neither an expert on file search nor on benchmarks,
so if I made a mistake in the following, please contact me (e.g. by
creating an issue on github).

Obviously this depends on plenty of circumstances. Any benchmark is
flawed, but I created a benchmark anyway as evidence to my claim.  You
can run the script test/benchmark/benchmark.py yourself. It downloads
the Linux kernel as a sample for a large codebase, and searches for
the word 'system' in the files using different methods.

The results I got were::

    2012-09-30
    CPUs: 8
    Python 2.7.2+ (default, Oct  4 2011, 20:06:09)
    [GCC 4.6.1]
    ('Ubuntu', '11.10', 'oneiric') 3.0.0-26-generic
    ('64bit', 'ELF')
    x86_64
    ack-grep 1.92
    Running under Perl 5.12.4

    'grep -r system': 4.28649616241, 4.29447007179
    'ackg --cpp -m 1000000 system': 7.71272993088, 7.7925620079
    'ackg --cpp system': 8.59431195259, 8.58715605736
    'ackg system': 8.59835219383, 8.63630700111
    'ackg --cpp -j=4 system': 10.3086640835, 10.1002981663
    'ack-grep --cpp system': 18.235612154, 18.1877188683
    'ack-grep system': 82.6627929211, 82.7030930519
    'ack-grep --no-group system': 82.8340058327, 82.9688789845

The numbers are the length of the runs. Grep alone rules this field,
and `ackg` can be in the same order by using a large argument to -m,
which will basically just call grep once with whitelisted files. For
the case of not specifying a filetype, this is by one order of
magnitude.

Note that to ackg, it does not matter much performance-wise to restrict the
search to c++ files, whereas to ack-grep that changes alot.  Obviously
you get more results without that restriction.  Also note in this case
the parallel option made things worse, so parallel search does not
bring a benefit in this case.

The other case is searching with the -i/--ignore-case option on::

    'ackg -i -j 4 --cpp system': 15.642608881, 15.7389969826
    'ack-grep -i --cpp system': 22.4900281429, 22.8398988247
    'ackg -i -j 2 --cpp system': 26.7036519051, 26.8606569767
    'ackg -i -j 150% --cpp system': 26.7330582142, 27.1521790028
    'ackg -i --cpp system': 44.4448950291, 44.3980340958
    'ackg -i -j -1 --cpp system': 49.479544878, 49.5985279083
    'grep -ir system': 190.462072134, 191.806163073

As you can see grep is far off, whereas `ackg` -j 4 beats `ack-grep`.
Note `ackg` without the -j option performs much worse than `ack-grep`.

I tried combining find parallel and ack-grep, but ack-grep did not
like acting as a filter and getting filenames.

What options are the fastest?
-----------------------------

This depends on several circumstances, things to tweak are the -m
option deciding how many files each grep commands get, the -j option
deciding whether to use GNU parallel instead of xargs, the value to -j
deciding the number of jobs to use.


Why Python?
-----------

I don't claim Python to be the best choice, but I like Python and it's
the script-language I have the most experience with.

Why GNU parallel instead of xargs -P?
-------------------------------------

xargs -P jumbles the file order, and older versions seem to interleave output.
but --xargs option uses xargs when -j is given.

Get GNU parallel here:
https://build.opensuse.org/package/show?package=parallel&project=home:tange
It is also part of Ubuntu package moreutils, but not as a recent version.

Known Limitations/TODOs
=======================

- -j option may break colored output
- -j default=4 may not be well chosen
- would be good to offer more of the grep options
- would be good to consider grep variants, agrep, fgrep
- --sorted causes output to start later
- highlighting might not work with certain regular expressions
- grouping is vulnerable to other formatting
- argument order seems to cause bugs sometimes, needs fixing
- searching non-binaries without extension (scripts) is a bad default behavior
- --help does not yet show type --options like --cpp etc.
- more docs needed, examples etc.
- more unit tests needed
- need to test on other systems (Unix, BSD) and python3
- would be good to read .ackrc
- need to support more inverse options if supporting ackrc

Changelog
=========

0.0.5 (2013-03-08)
------------------

- fix find command broken with 0.0.4
- restore inclusion of scriptfiles (files without extention) for script language types
- integartion tests

0.0.4 (2013-03-08)
------------------

- fix #2 include CMakeLists.txt for make
- fix #1 folders listed with newlines now
- some docu
- fix variable not initialized error

0.0.3 (2013-06-03)
------------------

- fix #3 missing hyphens around search pattern

0.0.2 (2012-09-30)
------------------

- grouped output
- options --sorted, --ack, --xargs,
- -i option not default
- benchmark added
- several small bugs fixed

0.0.1 (2012-09-29)
------------------

- initial version
