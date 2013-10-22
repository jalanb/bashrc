"""A script to run ifconfig, extract IP addresses"""


import os
import re
import sys
import commands

def run_ifconfig():
	"""return the output from ifconfig as a list of lines"""
	command = 'ifconfig -a'
	_status, output = commands.getstatusoutput(command)
	return output.splitlines()


def get_ip_addresses(lines):
	"""Find the IP addresses is the given lines"""
	ip_regexp = re.compile(r"(\b(([0-9]{1,3}\.){3})([0-9]{1,3})\b)")
	ip_addresses = [ip_regexp.search(l).group(0) for l in lines if ip_regexp.search(l)]
	return sorted(ip_addresses)


def make_chooser(args):
	"""Make a method to choose one of the args, or anything if args are empty"""
	if not args:
		return lambda x: True
	def choose(string):
		for arg in args:
			if re.search(arg, string):
				return True
	return choose


def main(args):
	"""Run the program"""
	result = os.EX_UNAVAILABLE
	choose = make_chooser(args)
	lines = run_ifconfig()
	for ip_address in get_ip_addresses(lines):
		if choose(ip_address):
			print ip_address
			result = os.EX_OK
	return result

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))
