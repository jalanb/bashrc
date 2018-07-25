"""Provide paths for known scripts"""


from pysyte.vim.args import sift
from pysyte import paths


def arg_paths(sys_args):
    arg_files = paths.files(sift(sys_args))
    return arg_files if arg_files else map(
        paths.pyc_to_py, map(paths.tab_complete, args))
