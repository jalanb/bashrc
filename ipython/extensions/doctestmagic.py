"""
``%doctest`` magic for IPython
==============================

License
-------

ipython-doctestmagic is licensed under the term of the Simplified
BSD License (BSD 2-clause license), as follows:

Copyright (c) 2012 Takafumi Arakaki
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""


import doctest
from contextlib import contextmanager

from IPython.core.magic import Magics, magics_class, line_magic, cell_magic
from IPython.core.magic_arguments import (argument, magic_arguments,
                                          parse_argstring)


class DummyForDoctest(object):
    pass


def common_doctest_arguments(func):
    commons = [
        argument(
            '-x', '--stop', default=False, action='store_true',
            help="""
            Stop running tests after the first error or failure.
            When this option is specified, the error is recorded
            in IPython shell so that you can debug the error by
            turning on pdb flag before doctest (see ``%%pdb``) or
            use ``%%debug`` magic command afterward.
            """,
        ),
        argument(
            '-v', '--verbose', default=False, action='store_true',
            help='See :func:`doctest.run_docstring_examples`.',
        ),
        argument(
            '-n', '--name', default='NoName',
            help='See :func:`doctest.run_docstring_examples`.',
        ),
    ]
    for c in commons:
        func = c(func)
    return func


@magics_class
class DoctestMagic(Magics):

    def _run_docstring_examples(self, obj, args):
        verbose = args.verbose
        name = args.name
        optionflags = 0
        globs = self.shell.user_ns
        FinderClass = doctest.DocTestFinder
        RunnerClass = doctest.DebugRunner if args.stop else \
                      doctest.DocTestRunner
        finder = FinderClass(verbose=verbose, recurse=False)
        runner = RunnerClass(verbose=verbose, optionflags=optionflags)
        for test in finder.find(obj, name, globs=globs):
            runner.run(test, compileflags=None)
            self._test_tries += runner.tries
            self._test_failures += runner.failures

    @contextmanager
    def _doctest_report(self, num_objects=None):
        self._test_tries = 0
        self._test_failures = 0
        try:
            yield
            self._print_report(num_objects)
        except doctest.UnexpectedException as e:
            print("Unexpected exception while running doctests!")
            self.shell.InteractiveTB(*e.exc_info)
            # To make %debug magic work
            self.shell.InteractiveTB.tb = e.exc_info[2]

    def _print_report(self, num_objects=None):
        if num_objects is None:
            in_objects_message = ''
        else:
            in_objects_message = ' in {0} objects'.format(num_objects)
        print("Ran {0} tests{1}, {2} tests failed.".format(
            self._test_tries, in_objects_message, self._test_failures))

    @magic_arguments()
    @argument(
        'object', nargs='+',
        help='Doctest is ran against docstrings of this object.',
    )
    @common_doctest_arguments
    @line_magic('doctest')
    def doctest_object(self, line):
        """
        Run doctest of given objects.

        Example::

          %doctest some_object other_object  # run doctest for several objects
          %doctest -v some_object            # verbose ouput
          %doctest -x some_object            # debug doctest

        Use the cell magic version of this magic command (``%%doctest``)
        to write doctest directly in IPython shell.

        """
        args = parse_argstring(self.doctest_object, line)
        objects = map(self.shell.ev, args.object)

        with self._doctest_report(len(objects)):
            for obj in objects:
                self._run_docstring_examples(obj, args)

    @magic_arguments()
    @common_doctest_arguments
    @cell_magic('doctest')
    def doctest_cell(self, line, cell):
        """
        Run doctest written in a cell.
        """
        args = parse_argstring(self.doctest_cell, line)
        obj = DummyForDoctest()
        obj.__doc__ = cell
        with self._doctest_report():
            self._run_docstring_examples(obj, args)


def load_ipython_extension(ip):
    """Load the extension in IPython."""
    global _loaded
    if not _loaded:
        ip.register_magics(DoctestMagic)
        _loaded = True

_loaded = False
