"""Module to provide a prompt I like for ipython"""

import os
import time

from IPython.utils import coloransi
from IPython.core.prompts import LazyEvaluate as promptify

@promptify
def prompt():
	color = coloransi.TermColors()
	return '%s0 %s[%s%s %s@%s:%s%s]%s%s\n>>> ' % (
		color.White,
		color.LightRed,
		color.LightCyan,
		time.strftime("%A %Y-%m-%d.%H:%M:%S"),
		os.environ.get('USER','nobody'),
		os.uname()[1],
		os.getcwd(),
		color.LightRed,
		color.Normal,
		color.Green,
	)

my_prompt = prompt()
