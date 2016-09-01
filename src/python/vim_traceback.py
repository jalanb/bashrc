"""Script to parse a Python traceback

Re-format the file list as suitable for a vim list

Running the script like this
    python vim_traceback.py /path/to/traceback.log
Or like this
    python crappy_program.py | python ~/jab/src/python/vim_traceback.py

Will display a vim command to open all files mentioned in the traceback
    That command will open each file in a new tab on the correct line
    Note: if the file is mentioned 5 times in the traceback it will be opened in 5 tabs

If the code works for you, then take it up a level by running the vim command directly:
    $(python vim_traceback.py /path/to/traceback.log)

If you prefer to use splits instead of tabs, add the option "-s", e.g
    $(python vim_traceback.py -s /path/to/traceback.log)

"""


import re
import os
import sys
import subprocess
from StringIO import StringIO


def get_clipboard_data():
    process = subprocess.Popen(['pbpaste'], stdout=subprocess.PIPE)
    retcode = process.wait()
    data = process.stdout.read()
    return data


def get_stream(arguments):
    """Open a stream for the first file in arguments, or stdin"""
    if not arguments:
        return sys.stdin
    elif arguments[0] == '-c':
        return StringIO(get_clipboard_data())
    for argument in arguments:
        if os.path.isfile(argument):
            return file(argument, 'r')
    return None


def line_regexp():
    """Regular expression to match a traceback file line"""
    return re.compile(r'''
        File\s
        (
            (
                ["']
                (?P<path_to_python>[^"']+)
                ["']
            ) | (
                (?P<spaceless_path_to_python>[^ ]+)
            )
        )
        ,\sline\s
        (?P<line_number>[0-9]+)
        ,.in..*
    ''', re.VERBOSE)


def parse_line(string):
    """Parse a single string as traceback line"""
    match = line_regexp().match(string)
    if match:
        matches = match.groupdict()
        line_number = matches['line_number']
        path_to_python = matches['path_to_python']
        spaceless_path_to_python = matches['spaceless_path_to_python']
        if path_to_python:
            return path_to_python, line_number
        elif spaceless_path_to_python:
            return spaceless_path_to_python, line_number


def as_vim_command(lines, use_splits):
    first, rest = lines[0], lines[1:]
    command = 'vim %s +%s' % first
    window = 'sp' if use_splits else 'tabnew'
    args = [str('+"tabnew +%s %s"' % (line, file_)) for file_, line in rest]
    args.insert(0, command)
    return ' '.join(args)


def main(args):
    """Run the script"""
    def digit_option(s):
        try:
            dash, letter = s[0], s[1]
        except IndexError:
            return False
        return dash == '-' and letter.isdigit()

    digit_args = [_ for _ in args if digit_option(_)]
    non_digit_args = [_ for _ in args if digit_option(_)]
    args = [_ for _ in args if _[:2] != '--']
    stream = get_stream(args)
    if not stream:
        print >> sys.stderr, 'No file specified'
        return 1
    lines = [parse_line(line.strip()) for line in stream]
    lines = [l for l in lines if l]
    print as_vim_command(lines, '-s' in args)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
