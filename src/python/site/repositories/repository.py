"""This module handles repositories generically"""


from repositories import git
from repositories import svn


def is_repository_path(path):
	"""Whether the path is in a repository sub-directory

	>>> is_repository_path('/path/to/.svn/file')
	True
	>>> is_repository_path('/path/to/.git/file')
	True
	"""
	return git.is_git_path(path) or svn.is_svn_path(path)
