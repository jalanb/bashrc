"""This module holds plugins for try.py"""

from __future__ import print_function

def pre_test(_path_to_test_file):
    """This method is called before each test has been run

    If this method returns a false value then that file is not tested
    """
    return True


def post_test(_path_to_test_file, _failures, _tests_run):
    """This method is called after each test has been run"""
    return True
