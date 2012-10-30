"""This module provides some known ANSI escape codes which may work with terminals

All numbers used in this file refer to values usable directly in an ANSI escape sequence
	See http://en.wikipedia.org/wiki/ANSI_escape_code for values
"""


def bold():
	return '\033[1m'


def no_bold():
	return '\033[22m'


def no_colour():
	return '\033[2m\033[0m'


def _colour_16(ground, i):
	if i > 7:
		return '\033[1m\033[%d%dm' % (ground, i - 8)
	return '\033[%d%dm' % (ground, i)


def _colour_256(ground, i):
	return '\033[%s;5;%dm' % (ground, i)


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


def foreground_string(text, i):
	return '%s%s%s' % (foreground(i), text, no_colour())


def background_string(text, i):
	return '%s%s%s' % (background(i), text, no_colour())


def grounds_string(text, background_colour, foreground_colour):
	return '%s%s%s%s' % (background(background_colour), foreground(foreground_colour), text, no_colour())


