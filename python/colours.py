"""Provide a method to add ANSI colour sequences to text

Inspired by http://stackoverflow.com/questions/384076/how-can-i-make-the-python-logging-output-to-be-colored
"""

# Names of the known colours
BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE = range(8)

# The background is set with 40 plus the number of the color, and the foreground with 30
_BACKGROUND = 40
_FOREGROUND = 30

def colour_off():
	return '\033[0m'

def colour_on(number):
	return '\033[1;%dm' % number

def foreground_on(number):
	return colour_on(_FOREGROUND + number)

def background_on(number):
	return colour_on(_BACKGROUND + number)

def bold_on():
	return '\033[1m'

def colour_text(text, colour_number):
	return '%s%s%s' % (foreground_on(colour_number), text, colour_off())

def colour_background(text, colour_number):
	return '%s%s%s' % (background_on(colour_number), text, colour_off())

def colour_both(text, background_colour_number, foreground_colour_number):
	return '%s%s%s%s' % (background_on(background_colour_number), foreground_on(foreground_colour_number), text, colour_off())

if __name__ == '__main__':
	print colour_text('red', RED)
	print colour_text('green', GREEN)
