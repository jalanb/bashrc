"""Dirty up the main namespace with some extra imports"""

try:
    see  # type: ignore
except NameError:

    def see(thing, regexp=None):
        """layout a dir listing filtered by the given regexp"""
        if regexp:
            import re

            print(
                "\n".join(
                    sorted([item for item in dir(thing) if re.match(regexp, item)])
                )
            )
        else:
            print("\n".join(sorted(dir(thing))))


def _path_to_history(os):
    """Get the path to our history file - hidden in the home directory"""
    path_to_history = os.path.expanduser("~/.pythonhistory")
    if not os.path.isfile(path_to_history):
        open(path_to_history, "w").close()
    return path_to_history


def _write_time_stamp(path_to_history):
    """Add a commented time stamp to that history file"""
    import datetime

    with open(path_to_history, "a") as history_file:
        print("# %s" % datetime.datetime.now().ctime(), file=history_file)


def _read_history(readline):
    """Load the history (if any) into readline"""
    import os
    import atexit

    path_to_history = _path_to_history(os)
    if os.path.isfile(path_to_history):
        _write_time_stamp(path_to_history)
        try:
            readline.read_history_file(path_to_history)
        except IOError:
            pass
    atexit.register(readline.write_history_file, path_to_history)


def complete():
    try:
        import readline

        readline.parse_and_bind("tab: complete")
        _read_history(readline)
    except (OSError, ImportError) as e:
        import sys

        print(
            "Python shell enhancement modules not available because %s" % e,
            file=sys.stderr,
        )


def set_prompt():
    """set shell prompt"""
    import sys

    sys.ps1 = "\033[1;32m>>>\033[0m "
    sys.ps2 = "\033[1;34m...\033[0m "


complete()
set_prompt()


# https://www.reddit.com/r/Python/comments/4ivd2k/what_is_your_favorite_python_error_message/d329j8l
class Quit(object):
    def __repr__(self):
        exit()


quit = Quit()
