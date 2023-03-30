"""Convert a traceback to breakpoint lines for use with pudb"""


import os
import sys

from pysyte.cli import arguments
from pysyte.cli import streams


def de_quote(string):
    """Remove leading/trailing double quotes

    >>> de_quote('"fred"') == 'fred'
    True
    """
    return string.strip('"')


def de_comma(string):
    """Remove any trailing commas

    >>> de_comma(',fred,,')  == ',fred'
    True
    """
    return string.rstrip(",")


def de_punctuate(string):
    """Remove quotes and trailing commas

    >>> de_punctuate('"stuff and nonsense",') == 'stuff and nonsense'
    True
    """
    return de_quote(de_comma(string))


def de_punctuate_word(words, i):
    """Remove quotes and trailing commas from the i'th word

    >>> de_punctuate_word(['"1"', '"2",'], 1) == '2'
    True
    """
    return de_punctuate(words[i])


def as_words(string):
    """Split the string into words

    >>> as_words('\tfred was here    ') == ['fred', 'was', 'here']
    True
    """
    return string.strip().split()


def lines_of_words(lines):
    """Read the file, spilt text into lines of words

    >>> lines = lines_of_words(open(__file__).readlines())
    >>> this_line = [_ for _ in lines if 'this_line' in _][0]
    >>> this_line[:3] == ['>>>', 'this_line', '=']
    True
    """
    return [as_words(_) for _ in lines]


def filter_by_word(lines, word_index, expected_word):
    """Exclude all lines without that word at that index

    >>> lines = [['one', 'two', 'three'], ['four', 'five']]
    >>> filter_by_word(lines, 1, 'five') == [['four', 'five']]
    True
    """
    return [_ for _ in lines if _ and _[word_index] == expected_word]


def parse_traceback_lines(lines):
    """Extract filename and line number from traceback lines

    >>> lines = [
    ...     'File "build.py", line 86, in time',
    ...     '    return main()',
    ...     'File "build.py", line 52, in main',
    ... ]
    >>> parse_traceback_lines(lines)
    [('build.py', '86'), ('build.py', '52')]
    """
    lines = lines_of_words(lines)
    file_lines = filter_by_word(lines, 0, "File")
    return [(de_punctuate_word(_, 1), de_punctuate_word(_, 3)) for _ in file_lines]


def parse_args():
    """Parse out command line arguments"""
    parser = arguments.parser(__doc__)
    parser.positional("file", help="File with traceback data")
    parser.boolean("-p", "--paste", help="Paste text from clipboard")
    parser.boolean("-i", "--stdin", help="Wait for text from stdin")
    return parser.parse_args()


def main(_args):
    """Use command line args as files containing tracebacks"""
    args = parse_args()
    streams_ = streams.args(args, "file")
    if not streams_:
        print("No traceback file specified", file=sys.stderr)
        return not os.EX_OK
    for stream in streams_:
        for line in parse_traceback_lines(streams_.full_lines(stream)):
            print("b", ":".join(line))
    return os.EX_OK


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
