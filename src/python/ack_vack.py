"""Script to change -v for an ack command to vack"""

import re
import sys

def main(args):
	words = ['ack']
	for word in args:
		if re.match('-[a-uw-z]*[vV][a-uw-z]*', word):
			words[0] = 'vack'
			words.append(word)
		else:
			if ' ' in word:
				if ' $' in word:
					words.append("'%s'" % word)
				else:
					words.append('"%s"' % word)
			else:
				words.append(word)
	print ' '.join(words)

if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))
