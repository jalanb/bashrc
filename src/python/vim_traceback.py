"""Script to parse a Python traceback

Re-format the file list as suitable for a vim list
"""


import re
import os
import sys


def get_stream(arguments):
    """Open a stream for the first file in arguments, or stdin"""
    if not arguments:
        return sys.stdin
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


def as_vim_command(lines):
    first, rest = lines[0], lines[1:]
    command = 'vim %s +%s' % first
    args = [str('+"tabnew +%s %s"' % (line, file_)) for file_, line in rest]
    args.insert(0, command)
    return ' '.join(args)


def main(args):
    """Run the script"""
    stream = get_stream(args)
    if not stream:
        print >> sys.stderr, 'No file specified'
        return 1
    lines = [parse_line(line.strip()) for line in stream]
    lines = [l for l in lines if l]
    print as_vim_command(lines)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
