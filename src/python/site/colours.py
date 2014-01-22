"""Provide methods to handle colour values


Inspired by http://stackoverflow.com/questions/384076/how-can-i-make-the-python-logging-output-to-be-colored
Conversion from RGB to xterm 256 colours based on values in http://www.frexx.de/xterm-256-notes/data/xterm-colortest
Conversion from rgb.txt names to RGB inspired by https://github.com/lilydjwg/winterpy/blob/master/pyexe/gui2term.py
"""


import os


import ansi_escapes
import colour_numbers


def colour_text(string, name):
    number = colour_numbers.name_to_number(name)
    return ansi_escapes.foreground_string(string, number)


def prompt_text(string, name):
    number = colour_numbers.name_to_number(name)
    return ansi_escapes.prompt_string(string, number)


def test():
    return ansi_escapes.foreground_string(
        'hello', colour_numbers.html_to_integer('0x00FF00'))


def main():
    for b in range(8):
        print ansi_escapes.background(b),
        for f in range(8):
            print '%s%s%s%s%s' % (
                ansi_escapes.foreground(f),
                ansi_escapes.bold(),
                'hello ',
                ansi_escapes.no_bold(),
                'world'),
        print ansi_escapes.no_colour()

    term = os.environ.get('TERM', '')
    if '256' in term or term == 'linux':
        for foregound in ['8b4513', '00ff7f', 'ff1493']:
            print ansi_escapes.foreground_string('hello', colour_numbers.html_to_integer(foregound))
        print ansi_escapes.no_colour()


if __name__ == '__main__':
    main()
