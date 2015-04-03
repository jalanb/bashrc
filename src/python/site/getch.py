"""Provide a getch() method to get single chars from a terminal

Do not wait on carriage returns

Adapted from
    http://code.activestate.com/recipes/134892/
    Without the redundant classes of that code
        but keeping the implementatation

    And reducing down to just the tty version
        No need here for Windows/Carbon
"""


import sys
import tty
import termios
import curses.ascii


def getch():
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(sys.stdin.fileno())
        return sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)


def get_ord_ch():
    return ord(getch())


def get_key():
    i = get_ord_ch()
    if not i:
        return i, getch()
    if i == 27:
        return i, getch(), getch()
    return (i,)


def test():
    key = get_key()
    k = key[0]
    c = chr(k)
    if curses.ascii.isgraph(c):
        print repr(c),
    else:
        print repr(k),
    print key[1:]


if __name__ == '__main__':
    test()
