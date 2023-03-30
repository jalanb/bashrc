"""Just work stuff"""

import os


def _name():
    return os.environ.get("WORK", "wwts")


def _join(strings):
    return ".".join(strings)


def _domain():
    return _join((_name(), "com"))


def server(name):
    domain_ = _domain()
    if name.endswith(domain_):
        return name
    return _join((name, domain_))
