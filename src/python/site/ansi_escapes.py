"""This module provides some known ANSI escape codes which work with terminals

All numbers used in this file are values usable in an ANSI escape sequence
    See http://en.wikipedia.org/wiki/ANSI_escape_code for values
"""


def escape(string):
    return '\033%s' % string


def escape_sequence(string):
    return escape('[%sm' % string)


def bold():
    return escape_sequence('1')


def no_bold():
    return escape_sequence('22')


def no_colour():
    return escape_sequence('2') + escape_sequence('0')


def no_prompt():
    return prompt(no_colour())


def _colour_16(ground, i):
    if i > 7:
        prefix = bold()
        i = i - 8
    else:
        prefix = ''
    return '%s%s' % (prefix, escape('[%d%dm' % (ground, i)))


def _colour_256(ground, i):
    return escape_sequence('%s;5;%d') % (ground, i)


def _background_16(i):
    return _colour_16(4, i)


def _background_256(i):
    return _colour_256(48, i)


def _foreground_16(i):
    return _colour_16(3, i)


def _foreground_256(i):
    return _colour_256(38, i)


def _small_colour_number(i):
    return i < 16


def foreground(i):
    return _small_colour_number(i) and _foreground_16(i) or _foreground_256(i)


def background(i):
    return _small_colour_number(i) and _background_16(i) or _background_256(i)


def prompt(string):
    return '\001%s\002' % string


def foreground_string(text, i):
    return '%s%s%s' % (foreground(i), text, no_colour())


def background_string(text, i):
    return '%s%s%s' % (background(i), text, no_colour())


def grounds_string(text, background_colour, foreground_colour):
    return '%s%s%s%s' % (
        background(background_colour),
        foreground(foreground_colour),
        text,
        no_colour())


def prompt_string(text, i):
    string = foreground(i)
    return '%s%s%s' % (prompt(string), text, no_prompt())
