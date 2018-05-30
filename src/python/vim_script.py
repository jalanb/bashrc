"""Script to set up a call to vim"""


from __future__ import print_function
import os
import re
import sys
from fnmatch import fnmatch
import tempfile
try:
    from subprocess import getoutput
except ImportError:
    from commands import getoutput


from pysyte.lists import de_duplicate


import script_paths


def path_to_editor():
    """Get the editor from the os, default to vim

    The rest of the script is predicated on using vim
        We are not expecting any other filename
        but will respect and directory which has been set

    >>> path_to_editor().endswith('vim')
    True
    """
    editor = os.environ.get('EDITOR', 'vim')
    if os.path.basename(editor) not in ['vim', 'gvim']:
        raise NotImplementedError(
            '%s can not work with %s' % (__file__, editor))
    return editor


class VimBashScript(object):
    """Write a bash script to run vim"""
    def __init__(self):
        self.lines = [
            '#! /bin/bash -x',
            '',
            'VIM_EDITOR="vim"',
            '. $(dirname $(readlink -f $BASH_SOURCE))/vim_functions.sh',
        ]

    def add(self, line):
        self.lines.append(line)

    @staticmethod
    def _script_stream():
        #  pylint: disable=no-self-use
        return tempfile.NamedTemporaryFile(
            mode='w',
            suffix='-vim.sh',
            dir=os.path.dirname(os.path.realpath(__file__)),
            delete=False)

    def write(self):
        self.add('rm -f $(readlink -f $0)')
        with self._script_stream() as stream:
            print('\n'.join(self.lines), file=stream)
            return stream.name


def quote(string):
    """Add quotation marks around the string

    Prefer doubles, then singles
    If neither are OK then
        escape any doubles in the string
        double-quote the entire string

    >>> quote('string') == '"string"'
    True

    Leave any matched quotes at start and end
    >>> quote('"string"') == '"string"'
    True
    """
    double = '"'
    single = "'"
    string = re.sub(r'([\'"])(.*)\1', r'\2', string)
    if double not in string:
        return '"%s"' % string
    if single not in string:
        return "'%s'" % string
    initial = string[0]
    if initial in [double, single] and initial == string[-1]:
        return string
    escaped = string.replace(double, r'\"')
    return '"%s"' % escaped


def quotes(strings):
    """Add quotation marks around each string

    >>> quotes(['a', "'b'"]) == ['"a"', '"b"']
    True
    """
    return [quote(string) for string in strings]


def escape_quotes(string):
    """Make the string accepatble to command line by esacping any quotes

    >>> escape_quotes('word"here') == r'word\\"here'
    True
    """
    return string.replace('"', r'\"').replace("'", r"\'")


def quote_finds(strings):
    """Add quotation marks around any sought items

    >>> quote_finds(['+1', '+/1']) == ['+1', '+/"1"']
    True
    """
    result = []
    for string in strings:
        if string.startswith('+/'):
            string = '+/%s' % quote(string[2:])
        result.append(string)
    return result


def is_final_option(string):
    """Whether that string means there will be no further options

    >>> is_final_option('--')
    True
    """
    return string == '--'


def is_dash_option(string):
    """Whether that string looks like an option

    >>> is_dash_option('-p')
    True
    """
    return string[0] == '-'


def is_plus_option(string):
    """Whether that string looks like an option

    >>> is_plus_option('+/sought')
    True
    """
    return string[0] == '+'


def is_option(string):
    """Whether that string looks like an option to vim

    >>> is_option('-p') and is_option('+/sought')
    True
    """
    end = 'finished'
    if is_final_option(string):
        setattr(is_option, end, True)
    if getattr(is_option, end, False):
        return False
    return is_dash_option(string) or is_plus_option(string)


def divide(items, divider):
    """Divide a list in two depending on the divider method

    >>> divide([0, 1, 2, 3], lambda x: x < 1) == ([0], [1, 2, 3])
    True
    """
    trues = []
    falses = []
    for item in items:
        if divider(item):
            trues.append(item)
        else:
            falses.append(item)
    return trues, falses


def missing_extension(string):
    """Whether that string looks like it's missing an extension

    >>> missing_extension('string.')
    True
    """
    return string[-1] == '.'


def extend(string):
    source_code_extensions = ['py', 'sh', 'c', 'cpp', ]
    for extension in source_code_extensions:
        extended_string = '%s%s' % (string, extension)
        yield extended_string


def realify(path_to_file):
    """Get the real path to the source text file"""
    return os.path.realpath(script_paths.pyc_to_py(path_to_file))


def get_globs(directory, glob):
    """A list of any files matching that glob in that directory"""
    if directory == '':
        directory = '.'
    path = os.path.expanduser(os.path.expandvars(directory))
    return [os.path.join(path, f)
            for f in os.listdir(path)
            if fnmatch(f, glob)]


def process_cwd(pid):
    """The current working directory for that process id

    >>> process_cwd(os.getpid()) == os.getcwd()
    True
    """
    command = '/usr/sbin/lsof -a -p %s -d cwd -Fn | grep "^n"' % pid
    output = getoutput(command)
    directory = output[1:]
    return directory


def real_path(path_to_directory, path_to_file):
    """The real path of that file relative to that directory

    >>> real_path('~/tmp', '../../../file') == '/file'
    True
    """
    full_path = os.path.join(path_to_directory, path_to_file)
    full_path = os.path.expanduser(full_path)
    return os.path.realpath(full_path)


def vimming_files(processes):
    """The files in that arg_string for those processes"""
    result = []
    for pid, arg_string in processes:
        args = arg_string.split()
        _vim_command, vim_args = args[0], args[1:]
        working_dir = process_cwd(pid)
        for vim_arg in vim_args:
            if not is_option(vim_arg):
                result.append((pid, real_path(working_dir, vim_arg)))
    return result


def find_vimming_process_command(path_to_file):
    """Make a command to look for a vim command in processes

    Pipe together commands to:
        Get pid and args of all commands
        Remove processes for grep and this script
            (unless path_to_file is this script)
        Find a vim command for that fileanme
    """
    path_to_file = realify(path_to_file)
    main_script = realify(sys.argv[0])
    this_script = realify(__file__)
    remove_knowns = ['grep -v -e grep']
    if path_to_file != main_script:
        remove_knowns.append(main_script)
    if path_to_file != this_script:
        remove_knowns.append(this_script)
    remove_string = ' -e '.join(remove_knowns)
    find_file = 'grep "vim.*\\s.*%s"' % os.path.basename(path_to_file)
    pipe = ' | '
    get_pids = 'ps -e -o pid,comm,args'
    return pipe.join([get_pids, remove_string, find_file])


def vimming_process(path_to_file):
    """Search for vim editting that file with the ps command"""
    filename = escape_quotes(os.path.basename(path_to_file))
    if not filename:
        return []
    command = find_vimming_process_command(path_to_file)
    output = getoutput(command)
    if not output:
        return []
    result = []
    for line in output.splitlines():
        pid, command, arg_string = line.split(' ', 2)
        if 'vim' not in command:
            continue
        arg_string = arg_string.strip()
        result.append((pid, arg_string))
    return result


def vimming(path_to_file):
    """Whether vim is currently editting that file"""
    processes = vimming_process(path_to_file)
    if not processes:
        return []
    pids_and_files = vimming_files(processes)
    if not pids_and_files:
        return []
    real_path_to_file = real_path(os.getcwd(), path_to_file)
    return [p for p, f in pids_and_files if f == real_path_to_file]


def has_swap_file(path_to_file):
    """Whether there exists a swap file which looks like it's for that file"""
    return any(get_swap_files(path_to_file))


def get_swap_files(path_to_file):
    """A list of all (potential) swap files based on that file"""
    if os.path.islink(path_to_file):
        path_to_file = os.readlink(path_to_file)
    directory = os.path.dirname(path_to_file)
    template = '%s.sw*' if path_to_file.startswith('.') else '.%s.sw*'
    glob = template % os.path.basename(path_to_file)
    return get_globs(directory, glob)


def separate_options(strings):
    result = []
    for string in strings:
        if is_plus_option(string):
            result.append(string)
        elif is_dash_option(string):
            for character in string[1:]:
                if character not in result:
                    result.append(character)
    return result


def interpret_sys_argv():
    """Interpret the args from a command line"""
    options, not_options = divide(strip_puv(sys.argv[1:]), is_option)
    options = separate_options(options)
    args = de_duplicate([script_paths.tab_complete(a) for a in not_options])
    paths = script_paths.arg_paths(args) or map(
        script_paths.pyc_to_py, map(script_paths.tab_complete, args))
    return paths, options


def _vim_options(text_files, options):
    """Get vim's options"""
    plussed = [_ for _ in options if _[0] == '+']
    dashed = [str('-%s' % _) for _ in options if _ not in plussed]
    if len(text_files) > 1 and '-p' not in dashed:
        dashed.insert(0, '-p')
    return quote_finds(dashed + plussed)


def _main_command(executable, text_files, options):
    """Make a vim command for those files and options"""
    command_words = [executable]
    command_words.extend(quotes(text_files))
    command_words.extend(options)
    return ' '.join(command_words)


def recover_old_swaps(text_file, swaps, source):
    """Add commands to recover old vim swap files"""
    if len(swaps) > 1:
        print('Too many swaps: %r' % ','.join(swaps), file=sys.stderr)
        return False
    swap = swaps[0]
    source.add('pre_vimming "%s" "%s"' % (text_file, swap))
    return True


def vimmable_files(text_files, source):
    result = []
    for text_file in text_files:
        if text_file in result:
            continue
        pids = vimming(text_file)
        if pids:
            echo = 'echo "A vim process (%s) is running for %s"'
            _ = [source.add(echo % (pid, text_file)) for pid in pids]
            continue
        swaps = get_swap_files(text_file)
        if any(swaps) and not recover_old_swaps(text_file, swaps, source):
            continue
        result.append(text_file)
    return result


def strip_puv(args):
    result = []
    for arg in args:
        if arg in ['--use_debugger', '--version', '--tabs']:
            continue
        try:
            dash = arg[0]
        except IndexError:
            continue
        if dash != '-':
            result.append(arg)
            continue
        string = ''.join([_ for _ in arg if _ not in 'pvU'])
        if string != '-':
            result.append(string)
    return result


def script():
    source = VimBashScript()
    try:
        text_files, options = interpret_sys_argv()
        if not text_files and not options:
            source.add('$VIM_EDITOR')
            print(source.write())
            return os.EX_OK
        vim_files = vimmable_files(text_files, source)
        if vim_files:
            vim_options = _vim_options(text_files, options)
            command = _main_command('$VIM_EDITOR', vim_files, vim_options)
            source.add(command)
            command = _main_command('post_vimming', vim_files, [])
            source.add(command)
            print(source.write())
        else:
            print(source.write())
    except (OSError, IOError) as e:
        print(e, file=sys.stderr)
        return os.EX_IOERR
    return os.EX_OK
