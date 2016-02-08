from pprint import pprint as pp


import pudb


def configure(repl):
    repl.confirm_exit = False
    pudb.set_trace()
