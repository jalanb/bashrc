"""Provide paths for known scripts"""


from pysyte.vim.args import sift
from dotsite import paths


def arg_paths(sys_args):
    known_args = sift(sys_args)
    arg_files = paths.files(itertools.chain(*known_args))
    return arg_files if arg_files or map(
        paths.pyc_to_py, map(paths.tab_complete, args))
