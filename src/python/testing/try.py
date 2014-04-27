"""Script to handle running of doctests"""


import re
import os
import imp
import sys
import doctest
import fnmatch
import commands
import datetime
import cStringIO
from pprint import pprint, pformat


from dotsite.paths import makepath
from see import see, see_methods, see_attributes, spread
import test_files
import try_plugins


class DoctestInterrupt(KeyboardInterrupt):
    """This exception is for better naming of the only thing to stop doctest"""
    pass

def no_print(method, *args, **kwargs):
    """Discard all writes to stdout"""
    old_stdout = sys.stdout
    try:
        sys.stdout = cStringIO.StringIO()
        return method(*args, **kwargs)
    finally:
        sys.stdout = old_stdout


def run_command(command):
    """Run a command in the local shell (usually bash)"""
    status, output = commands.getstatusoutput(command)
    if status:
        print 'FAIL: %s:%s' % (status, output)
        return False
    print output
    return True


def show(thing):
    """Pretty print the given thing

    Unless the thing is a module
        when we show the help for that module instead
    """
    if type(thing) == type(re):
        return pprint(help(thing))
    return pprint(thing)


class Test_Being_Run:
    """Encapsulation of the current test"""
    def __init__(self, that):
        self.here = makepath('.')
        self.home = makepath('~')
        self.username = os.environ['USER']
        try:
            self.host = os.environ['HOST']
        except KeyError:
            try:
                self.host = os.environ['HOSTNAME']
            except KeyError:
                self.host = None
                if self.home.startswith('/Users'):
                    self.host = 'jab.ook'
        self.user = '%s@%s' % (self.username, self.host)
        self.path = self.here.relpathto(that)
        base, ext = self.path.splitext()
        _ = [self.add_path(base, ext) for ext in ['py', 'test', 'tests', 'fail']]

    def __repr__(self):
        return '<%s %r>' % (self.__class__.__name__, str(self.path.short_relative_path_from_here()))

    def add_path(self, base, ext):
        """Add a path for base.ext as an attribute to self"""
        name = 'path_to_%s' % ext
        if hasattr(self, name):
            return
        path_to_ext = makepath('%s.%s' % (base, ext))
        if path_to_ext.isfile() or ext == 'fail':
            setattr(self, name, path_to_ext)


def command_line():
    """Handle options on the command line

    Destroy the option parser when finished (do not interfere with tests which use it
    """
    from optparse import OptionParser
    parser = OptionParser()
    parser.add_option('-s', '--show', dest='show', help='show files being tested', action='store_true')
    parser.add_option('-v', '--verbose', dest='verbose', help='Hello World', action='store_true')
    parser.add_option('-r', '--recursive', dest='recursive', help='recurse into any sub-directories found', action='store_true', default=False)
    parser.add_option('-a', '--all', dest='all', help='run all tests in each file (do not stop on first FAIL)', action='store_true', default=False)
    parser.add_option('-d', '--directory_all', dest='directory_all', help='run all test scripts in a directory (do not stop on first FAILing script)', action='store_true', default=False)
    parser.add_option('-q', '--quiet_on_success', dest='quiet_on_success', help='no output if all tests pass', action='store_true', default=False)
    parser.add_option('-p', '--persist', dest='persist', help='do not stop on DoctestInterrupts', action='store_true', default=False)
    options, args = parser.parse_args()
    if hasattr(parser, 'destroy'):
        parser.destroy()
    del parser
    if options.recursive:
        for arg in args:
            if os.path.isfile(arg):
                raise ValueError('Do not use --recursive with files (%s)' % arg)
    return options, args


class Sys_Path_Handler:
    def __init__(self):
        self.paths = []

    def add(self, item):
        """Add the item to sys.path"""
        directory = makepath(item).directory()
        if directory not in self.paths:
            self.paths.insert(0, directory)
            if directory not in sys.path:
                sys.path.insert(0, str(directory))

    def remove(self, item):
        """Remove the item from sys.path"""
        directory = makepath(item).directory()
        if directory in self.paths:
            self.paths.remove(directory)
            if directory in sys.path:
                sys.path.remove(directory)


def make_module(path_to_python):
    """The module object for the given python source code"""
    name = path_to_python.namebase
    try:
        return sys.modules[name]
    except KeyError:
        pass
    # If any of the following calls raises an exception,
    # there's a problem we can't handle -- let the caller handle it.
    try:
        fp, pathname, description = imp.find_module(name, [path_to_python.parent])
    except ImportError:
        try:
            fp, pathname, description = file(name), path_to_python, ('', 'r', imp.PY_SOURCE)
        except IOError:
            raise ImportError('Could not find a module for %r' % str(path_to_python))
    try:
        x = imp.load_module(name, fp, pathname, description)
        return x
    finally:
        if fp:
            fp.close()


def test_source(source_script, options):
    """Run tests in the given source"""
    message = 'py %s;' % source_script
    module = make_module(source_script)
    failures, tests_run = doctest.testmod(
        module,
        optionflags=get_doctest_options(options),
        verbose=options.verbose,
    )
    del module
    return failures, tests_run, message


def test_file(test_script, options):
    """Run tests in a doctest script"""
    message = 'try %s;' % test_script
    failures, tests_run = doctest.testfile(
        test_script,
        optionflags=get_doctest_options(options),
        module_relative=False,
        globs = {
            'test' : Test_Being_Run(test_script),
            'sys' : sys,
            'see' : see,
            'spread' : spread,
            'see_methods' : see_methods,
            'see_attributes' : see_attributes,
            'makepath' : makepath,
            'show' : show,
            'bash' : run_command,
            'DoctestInterrupt' : DoctestInterrupt,
            'no_print' : no_print,
        },
        verbose=options.verbose,
    )
    return failures, tests_run, message


def run_doctest(test_script, options):
    """Call the relevant doctest method for the given script"""
    if test_script.ext in ['', '.py']:
        try:
            return test_source(test_script, options)
        except ImportError:
            if test_script.ext:
                raise
            return 0, 0, ''
    return test_file(test_script, options)


def show_running_doctest(test_script, options):
    """Run a doctest for that script, showing progress on stdout/stderr"""
    old_argv = sys.argv[:]
    try:
        sys.argv = [test_script]
        try:
            if options.verbose or options.show:
                print 'Test', test_script
            return run_doctest(test_script, options)
        except DoctestInterrupt, e:
            if options.directory_all or options.persist:
                show_interruption(test_script, e)
                return 0, 0, ''
            raise
        except SyntaxError, e:
            if options.directory_all or options.persist:
                show_syntax(test_script, e)
                return 0, 0, ''
            raise
    finally:
        sys.argv[:] = old_argv


def get_doctest_options(options):
    """Convert the command line options to Doctest options"""
    result = doctest.ELLIPSIS | doctest.NORMALIZE_WHITESPACE
    if not options.all:
        result |= doctest.REPORT_ONLY_FIRST_FAILURE
    return result


def show_time_taken(start, messages, message, tests_run):
    """Add a message about the time taken dince start to the messages"""
    end = datetime.datetime.now()
    time_taken = end - start
    if time_taken.seconds:
        if time_taken.seconds > 1:
            time_msg = 'in %d seconds' % time_taken.seconds
        else:
            time_msg = 'quickly'
    else:
        time_msg = 'very quickly'
    messages.append('%s %s tests passed %s' % (message, tests_run, time_msg))
    return end


def show_syntax(test_script, interruption):
    """Show the reason for an interuption on stderr"""
    print >> sys.stderr, 'Bye from ', test_script
    print >> sys.stderr, 'Because:', interruption


def show_interruption(test_script, interruption):
    """Show the reason for an interuption on stderr"""
    print >> sys.stderr, '^c ^C ^c ^C ^c ^C ^c ^C ^c ^C ^c '
    print >> sys.stderr, 'Bye from ', test_script
    print >> sys.stderr, 'Because:', interruption


def test():
    """Run all tests"""
    sys_paths = Sys_Path_Handler()
    options, args = command_line()
    messages = ['']
    pwd = os.getcwd()
    end = start_all = datetime.datetime.now()
    run_all = 0
    failures_all = 0
    sys_paths.add('.')
    try:
        for test_script in test_files.paths_to_doctests(args, options.recursive):
            failures, tests_run, message = 0, 0, ''
            os.chdir(pwd)
            start = datetime.datetime.now()
            try:
                sys_paths.add(test_script)
                if try_plugins.pre_test(test_script):
                    failures, tests_run, message = show_running_doctest(test_script, options)
                    try_plugins.post_test(test_script, failures, tests_run)
            finally:
                sys_paths.remove(test_script)
            if tests_run:
                run_all += tests_run
                end = show_time_taken(start, messages, message, tests_run)
            else:
                show_time_taken(start, messages, message, tests_run)
            if failures:
                failures_all += failures
                if not options.directory_all:
                    return failures
    finally:
        time_taken = end - start_all
        messages.append('%s tests passed, %d failed, in %s seconds' % (run_all, failures_all, time_taken.seconds))
        messages.append('')
    if failures_all or not options.quiet_on_success:
        print '\n'.join(messages)
    return failures_all


def main():
    """Run the program"""
    try:
        return test()
    except test_files.UserMessage, e:
        print >> sys.stderr, e
    except KeyboardInterrupt, e:
        print >> sys.stderr, '^c ^C ^c ^C ^c ^C ^c ^C ^c ^C ^c '
        print >> sys.stderr, 'Bye now'
        if str(e):
            print >> sys.stderr, e


if __name__ == '__main__':
    sys.exit(main())
