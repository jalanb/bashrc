from pprint import pprint as pp


import pudb


def configure(repl):
    """Configure pym"""
    repl.confirm_exit = False
    pudb.set_trace()
