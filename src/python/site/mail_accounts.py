"""Module to provide details for my mail accounts"""


import os
from ConfigParser import SafeConfigParser


def _credentials(server, username):
    def read_passes():
        passes = {}
        parser = SafeConfigParser()
        parser.read('%s/.config/mailservers.ini' % os.environ['HOME'])
        for section in parser.sections():
            passes[section] = {}
            for key, value in parser.items(section):
                passes[section][key] = value
        return passes

    try:
        passes = _credentials.passes
    except AttributeError:
        _credentials.passes = read_passes()
        passes = _credentials.passes
    try:
        password = passes[server][username]
    except KeyError:
        raise KeyError('User "%s" unknown for server "%s"' %
                       (username, server))
    return server, username, password


def main_personal():
    """My main personal account"""
    return _credentials('imap.gmail.com', 'algotrhythm')


def second_personal():
    """My other personal account"""
    return _credentials('imap.gmail.com', 'algotother')


def employee():
    """My email account at work"""
    return _credentials('excork2.cork.s3group.com')


def second_employee():
    """My second work account"""
    return _credentials('imap.gmail.com', 'ctyi.tralee')
