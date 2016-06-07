"""Module to handle pudb"""


import inspect


from pudb import remote


remote.PUDB_RDB_PORT = 53337

def frame_above():
    return inspect.currentframe().f_back.f_back


def back_trace(term_size, frame=frame_above()):
    remote.set_trace(frame, term_size)
