"""Maintains a jump-list of the directories you actually use


INSTALL:
	* put something like this in your .bashrc:
		export JPY=/path/to/j.py  # tells j.sh where the python script is
		. /path/to/j.sh		  # provides the j() function
	* make sure j.py is executable
	* cd around for a while to build up the db


USE:
	* j foo	  # goes to most frecent dir matching foo
	* j foo bar  # goes to most frecent dir matching foo and bar
	* j -t rank  # goes to highest ranked dir matching foo
	* j -l foo  # list all dirs matching foo
"""


import os
import sys
import time
from optparse import OptionParser


def shortest(strings):
	"""A list of all the strings in the list which are not longer than the shortest string in the list"""
	lengths = [(len(string), string) for string in strings]
	minimum = min(lengths)[0]
	return [string for length, string in lengths if length == minimum]


def first_shortest(strings):
	"""The first string in the list of shortest strings in the list"""
	return shortest(strings)[0]


def first_shortest_to(strings, substring):
	"""Chop the each string at the first occurrence of substring
	Then find the shortest strings
	Then return the first of those
	"""
	chopped_strings = [string[:string.find(substring) + len(substring)] for string in strings]
	return first_shortest(chopped_strings)


def read_data_file(path_to_old_directories):
	"""Read cache data from the given path

	Data is stored as path|rank|atime
	"""
	if not os.path.isfile(path_to_old_directories):
		return []
	old_directories = [line.strip().split('|') for line in file(path_to_old_directories, 'r')]
	result = []
	for old_directory in old_directories:
		try:
			path, rank, atime = old_directory
		except ValueError:
			continue
		result.append((path, float(rank), int(atime)))
	return result


def write_data_file(path_to_old_directories, data):
	"""Write the given data to the given file

	Data is stored as path|rank|atime
	"""
	out = None
	try:
		out = file(path_to_old_directories, 'w')
		for path, rank, atime in data:
			print >> out, '%s|%s|%s' % (path, rank, atime)
	finally:
		if out:
			out.close()


def rewrite_data_file(path_to_old_directories):
	"""Read data, the write it back out again

	Rewiting is preserves format (strips spaces, removes any line without "|"
	"""
	data = read_data_file(path_to_old_directories)
	write_data_file(path_to_old_directories, data)
	return data


def datum_to_match(datum):
	"""Convert from data format (time since epoch) to match format (seconds since use)"""
	path, rank, atime = datum
	seconds_since_use = int(time.time()) - atime
	return rank, seconds_since_use, path


class DirectoryMemory(object):
	"""Cache used directories to disk"""

	def __init__(self, data):
		self.data = data
		self.all_arguments_match_a_common_prefix = None
		self.path_matches = [datum_to_match(d) for d in data]
		self.ranking_methods = {
			'rank' : self.rank,
			'recent' : self.recent,
			'frecent': self.frecent
	}

	def pretty(self, ranking_algorithm):
		""" return a listing by ranking_algorithm """
		if ranking_algorithm not in self.ranking_methods:
			return ''
		result = ['by %s' % ranking_algorithm]
		result.extend(['%-15s %s' % i for i in self.ranking_methods[ranking_algorithm]()])
		return '\n'.join(result)

	def find_destination(self, ranking_algorithm):
		"""Find a destination by using the given ranking_algorithm """
		if ranking_algorithm == 'common':
			return self.all_arguments_match_a_common_prefix
		if self.path_matches and ranking_algorithm in self.ranking_methods:
			return self.ranking_methods[ranking_algorithm]()[-1][1]

	def rank(self):
		""" time spent/aging, taken care of in .sh """
		return sorted(([(i[0], i[2]) for i in self.path_matches]))

	def recent(self):
		""" by recently accessed """
		return  sorted(([(i[1], i[2]) for i in self.path_matches]), reverse = True)

	def frecent(self):
		""" rank weighted by recently accessed """
		result = []
		one_hour = (3600, 4.0)
		one_day = (86400, 2.0)
		one_week = (604800, 0.5)
		for rank, seconds_since_match, path in self.path_matches:
			for seconds, factor in [one_hour, one_day, one_week]:
				if seconds_since_match < seconds:
					result.append((rank * factor, path))
					break
			else:
				result.append((rank * 0.25, path))
		return sorted(result)

	def matches(self, arguments, ignore_case=False):
		"""
		set self.path_matches to a list of possibly case sensitive path matches
		m format: (rank, atime, path)
		"""
		# pylint is not good at distinguishing sub-methods
		# so ignore the warning about "Too many branches"
		# pylint: disable-msg=R0912
		def all_arguments_match_a_common_prefix(matches):
			"""
			return prefix if there's a common prefix to all matches,
			the prefix is in the list,
			and all the arguments match in it
			"""
			if not matches:
				return None
			prefix = os.path.commonprefix([i[2] for i in matches])
			if not prefix or prefix == '/':
				return None
			prefixed_matches = [i for i in self.path_matches if i[2] == prefix]
			if not prefixed_matches:
				return None
			if ignore_case:
				prefix = prefix.lower()
			for argument in arguments:
				if argument not in prefix:
					return None
			return prefixed_matches[0][2]

		def every_item_has(path):
			""" every item in list arguments must match in path path """
			match = True
			if ignore_case:
				path = path.lower()
			for argument in arguments:
				if argument not in path:
					match = False
			return match

		self.path_matches = []
		if ignore_case:
			arguments = [i.lower() for i in arguments]
		for path, rank, atime in self.data:
			if not every_item_has(path):
				continue
			seconds_since_use = int(time.time()) - atime
			path_match = (rank, seconds_since_use, path)
			self.path_matches.append(path_match)
		self.all_arguments_match_a_common_prefix = all_arguments_match_a_common_prefix(self.path_matches)
		return self.path_matches

	def add_path(self, new_path):
		"""Add the given path to self.data

		Do not add $HOME

		If there enough old paths then age them (reduce their rank by 10%)
		"""
		if os.path.realpath(new_path) == os.path.realpath(os.path.expanduser('~')):
			return
		new_rank = 1
		new_data = []
		sum_of_ranks = 0.0
		for old_path, rank, atime in self.data:
			sum_of_ranks += rank
			if old_path == new_path:
				new_rank = rank + 1
			else:
				new_data.append((old_path, rank, atime))
		new_data.append((new_path, new_rank, int(time.time())))
		max_sum = 1000.0
		if sum_of_ranks > max_sum:
			self.data = [(path, rank * max_sum / sum_of_ranks, atime) for path, rank, atime in new_data]
		else:
			self.data = new_data

	def complete_path(self, string_to_complete, ranking_algorithm):
		"""Complete a path for the shell

		Return the highest ranked path whose name starts with the given string
		If there is none like that then
			gather all the paths who have some directory starting with the string
			find the shortest of those
			return the highest ranked path of same length as shortest
		"""
		def completion_result(strings):
			"""Format the strings as a result usable by the calling script"""
			return '%s--%s' % (' '.join(strings), first_shortest_to(strings, string_to_complete))

		if self.path_matches and ranking_algorithm in self.ranking_methods:
			strings = []
			method = self.ranking_methods[ranking_algorithm]
			lower_ranked_first = method()
			if string_to_complete[0] == '/':
				for _, path in reversed(lower_ranked_first):
					if path.startswith(string_to_complete):
						strings.append(path)
			else:
				for _, path in reversed(lower_ranked_first):
					if os.path.basename(path).startswith(string_to_complete):
						strings.append(path)
			if strings:
				return completion_result(strings)
			for _, path in reversed(lower_ranked_first):
				for part in path.split(os.path.sep):
					if part.startswith(string_to_complete):
						strings.append((len(path), path))
			if strings:
				shortest_length = min([length for length, path in strings])
				shortest_strings = []
				for length, path in strings:
					if length == shortest_length:
						shortest_strings.append(path)
				return completion_result(shortest_strings)
		return string_to_complete


def handle_command_line():
	"""Read the command line and parse to options and arguments"""
	parser = OptionParser(usage='%prog [options] part of a directory name')
	parser.add_option('-a', '--add', dest='add_path', help='Add a path to the store')
	parser.add_option('-c', '--complete', dest='complete', help='Complete a path for the shell')
	parser.add_option('-f', '--file', dest='path_to_old_directories', help='where previously used directories are stored')
	parser.add_option('-r', '--ranking', dest = 'ranking_algorithm', default='frecent', help='The ranking algorithm to use which is one of "frecent" (default), "rank" or "recent"')
	parser.add_option('-l', '--list', dest='list', action='store_true', default=False, help='List all known directories')
	parser.add_option('-d', '--documentation', action='store_true', default=False, help='documentation')
	options, arguments = parser.parse_args()
	if options.documentation:
		sys.exit(__doc__)
	if not options.path_to_old_directories:
		options.path_to_old_directories = os.path.expanduser('~/.j2')
	if options.ranking_algorithm not in ['frecent', 'rank', 'recent']:
		print >> sys.stderr
		print >> sys.stderr, '%r is not a known ranking algorithm' % options.ranking_algorithm
		print >> sys.stderr
		sys.exit(__doc__)
	return options, arguments

def final_argument_is_a_directory(arguments):
	"""If we hit enter on a completion, go there"""
	if not arguments:
		return False
	final_argument = arguments[-1]
	if os.path.isdir(final_argument):
		print final_argument
		return True
	return False


def main():
	""" make sure the only thing that gets to stdout is a place to cd """
	options, arguments = handle_command_line()
	if final_argument_is_a_directory(arguments):
		return 0
	data = rewrite_data_file(options.path_to_old_directories)
	directory_memory = DirectoryMemory(data)
	if options.complete:
		output = directory_memory.complete_path(options.complete, options.ranking_algorithm)
	elif options.add_path:
		directory_memory.add_path(options.add_path)
		write_data_file(options.path_to_old_directories, directory_memory.data)
		return 0
	elif options.list or not arguments:
		output = directory_memory.pretty(options.ranking_algorithm)
	else:
		if not directory_memory.matches(arguments):
			directory_memory.matches(arguments, True)
		output = directory_memory.find_destination(options.ranking_algorithm)
	if output:
		print output
	return 0


if __name__ == '__main__':
	sys.exit(main())
