""" User configuration file for IPython

This is a more flexible and safe way to configure ipython than *rc files
(ipythonrc, ipythonrc-pysh etc.)

This file is always imported on ipython startup. You can import the
ipython extensions you need here (see IPython/Extensions directory).

Feel free to edit this file to customize your ipython experience.

Note that as such this file does nothing, for backwards compatibility.
Consult e.g. file 'ipy_profile_sh.py' for an example of the things 
you can do here.

See http://ipython.scipy.org/moin/IpythonExtensionApi for detailed
description on what you could do here.
"""

# Most of your config files and extensions will probably start with this import

import config_helper_functions

def main():

	# uncomment if you want to get ipython -p sh behaviour
	# without having to use command line switches  
	# import ipy_profile_sh

	o = config_helper_functions.ip.options
	# An example on how to set options
	o.autocall = 2
	o.autoedit_syntax = 1
	o.autoindent = 1
	o.automagic = 1
	o.log = 1
	o.banner = 0
	o.pdb = 0
	o.pprint = 1
	o.readline = 1
	o.system_verbose = 0
	o.confirm_exit = 0

	config_helper_functions.import_mod('os sys re')
	config_helper_functions.import_some('path','makepath path')
	config_helper_functions.import_some('see','see code see_methods see_attributes')

	# -- prompt
	# A different, more compact set of prompts from the default ones, that
	# always show your current location in the filesystem:

	config_helper_functions.ip.ex('import time')
	o.prompt_in1 = r'\C_White0 \C_LightRed[\C_LightCyan${time.strftime("%A %Y-%m-%d.%H:%M:%S")} \u@\h:\w\C_LightRed]\C_Normal\n\C_Green\# '
	o.prompt_in2 = r'.\D: '
	o.prompt_out = r'[\#] '
	
	# Try one of these color settings if you can't read the text easily
	# autoexec is a list of IPython commands to execute on startup
	# o.autoexec.append('%colors LightBG')
	# o.autoexec.append('%colors NoColor')
	o.autoexec.append('%colors Linux')
	
	# for sane integer division that converts to float (1/2 == 0.5)
	o.autoexec.append('from __future__ import division')
	
	# For %tasks and %kill
	import jobctrl 
	
	# For autoreloading of modules (%autoreload, %aimport)	
	import ipy_autoreload
	
	# Tab completer that is not quite so picky (i.e. 
	# "foo".<TAB> and str(2).<TAB> will work). Complete 
	# at your own risk!
	# import ipy_greedycompleter
	
	# If you are on Linux, you may be annoyed by
	# "Display all N possibilities? (y or n)" on tab completion,
	# as well as the paging through "more". Uncomment the following
	# lines to disable that behaviour
	# import readline
	# readline.parse_and_bind('set completion-query-items 1000')
	# readline.parse_and_bind('set page-completions no')

	# Set up easier access to Altobridge data
	config_helper_functions.execf('~/.ipython/alto.py')
	# config_helper_functions.ip.ex('alto = AltobridgeVariables()')

main()
