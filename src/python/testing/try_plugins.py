"""This module holds plugins for try.py"""


def pre_test(_path_to_test_file):
    """This method is called before each test has been run

    If this method returns a false value then that file is not tested
    """
    return True


def post_test(_path_to_test_file, _failures, _tests_run):
    """This method is called after each test has been run"""
    check_bash()
    return True


def check_bash():
    try:
        import bash
    except ImportError:
        return
    shown = bash.BashOptions.verbosity.shown()
    if shown:
        print 'bash', ','.join(shown)
    del bash
