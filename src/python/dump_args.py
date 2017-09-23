from __future__ import print_function
def dump_args(func):
    "This decorator dumps out"
    argnames = func.func_code.co_varnames[:func.func_code.co_argcount]
    fname = func.func_name
    def echo_func(*a, **kw):
        print(fname, ": ")
        return func(*a, **kw)
    return echo_func

@dump_args
def f1(a, b, c):
    print(a + b +c)

f1(1, 2, 3)
