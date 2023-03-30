"""Script to display a todo list"""


from __future__ import print_function
import re
import sys

try:
    from namedtuple import namedtuple  # pylint: disable=import-error
except ImportError:
    from collections import namedtuple


from pysyte.types.paths import path
from pysyte.colours import texts


def todo_file():
    """Get the filename from the environment"""
    # Tell pylint not to warn that this is a todo
    # pylint: disable=W0511
    if sys.argv[1:]:
        todo = path(sys.argv[1])
        if todo.isfile():
            return todo
    jab = path("~/jab")
    for ext in ("md", "txt"):
        todo = jab / f"todo.{ext}"
        if todo.isfile():
            return todo
    return path(None)


def read_todo(todo):
    lines = [_.rstrip() for _ in open(todo)]
    return [_ for _ in lines if _ and _[0] != "#"]


def as_todo_item(line):
    """Initialise a TodoItem from the line"""
    item_regexp = re.compile(
        "^(?P<text>.*), (?P<priority>[%s])$" % priority_keys_string()
    )
    match = item_regexp.match(line)
    TodoItem = namedtuple("TodoItem", "text, priority")
    if not match:
        return TodoItem(line, -1)
    text = match.groupdict()["text"]
    priority = match.groupdict()["priority"]
    return TodoItem(text, int(priority))


def read_items():
    """Extract a list of todo items from a list of lines

    Each item is a tuple of (text, priority)
    """
    todo = todo_file()
    lines = read_todo(todo) if todo else []
    return [as_todo_item(_) for _ in lines]


def priorities():
    """The recognised priorities in this system"""
    Priority = namedtuple("Priority", "number, name, colour")
    # pylint: disable=bad-whitespace
    # Yeah, fuck off!
    return [
        Priority(0, "bug", "red"),
        Priority(1, "yesterday", "magenta"),
        Priority(2, "today", "blue"),
        Priority(3, "tomorrow", "cyan"),
        Priority(4, "feature", "green"),
        Priority(5, "wish", "yellow"),
        Priority(6, "text", "gray"),
    ]


def priority_keys_string():
    """A string with the priority numbers in this system"""
    return "".join([str(priority.number) for priority in priorities()])


def priority_colour(priority_number):
    for priority in priorities():
        if priority_number == priority.number:
            return priority.colour
    return "white"


def show_item(item):
    """Show the item on screen, coloured by it's priority"""
    colour = priority_colour(item.priority)
    print(texts.colour_text(colour, item.text))


def main():
    """Read all todo items and show them on screen"""
    for item in read_items():
        show_item(item)
    return 0
