"""Dirty up the main namespace with some extra imports"""



def _set_up():
	# Too many dynamic items here to take E0602 (undefined variable) seriously
	# and pylint is no good at recognising methods in methods when counting branches - R0912
	# pylint: disable-msg=E0602,R0912
	global _set_up

	def show_import(name, fromlist=None):
		try:
			module = __import__(name, fromlist=fromlist or [])
			if fromlist:
				loaded_items = []
				for name in fromlist:
					try:
						name, alias = name
						loaded_items.append('%s as %s' % (name, alias))
					except ValueError:
						alias = name
						loaded_items.append(name)
					item = getattr(module, name)
					globals()[alias] = item
				print 'from', module.__file__, 'import', ', '.join(loaded_items)
			else:
				globals()[name] = module
				try:
					out = module.__file__
				except AttributeError:
					out = name
				print 'import', out
		except ImportError:
			print 'Failed to import', name


	def complete_python():
		def path_to_history_file():
			return '%s.history' % os.path.splitext(os.path.realpath(__file__))[0]
		show_import('readline')
		show_import('rlcompleter')
		show_import('atexit')
		if 'libedit' in readline.__doc__:
			readline.parse_and_bind("bind ^I rl_complete")
		else:
			readline.parse_and_bind("tab: complete")
		if not os.path.isfile(path_to_history_file()):
			file(path_to_history_file(), 'w').close()
		readline.read_history_file(path_to_history_file())
		atexit.register(readline.write_history_file, path_to_history_file())
		unlimited_history = -1
		readline.set_history_length(unlimited_history)


	def show_imports():
		print
		show_import('sys')
		print 'sys.path:', [p for p in sys.path if not p.startswith('%s/lib' % sys.prefix)]
		show_import('os')
		show_import('environ')
		show_import('paths')
		show_import('see', ['see', 'see_methods', 'see_attributes', 'spread'])
		show_import('see_code', ['highlight_method'])
		show_import('tempfile', ['mkstemp'])
		print

	def prettify():
		show_import('pprint', [('pprint', 'show')])
		show_import('colours')
		sys.ps1 = colours.colour_text('>>> ', 'green')
		sys.ps2 = colours.colour_text('... ', 'light green')
		sys.displayhook = show

	show_imports()
	complete_python()
	prettify()

	del _set_up


def _make_console():
	from code import InteractiveConsole
	class Mython(InteractiveConsole):
		def __init__(self, *args, **kwargs):
			self.last_buffer = [] # This holds the last executed statement
			self.editor = os.environ.get('EDITOR', 'vim')
			self.edit_command = 'vim'
			self.quit_command = 'q'
			InteractiveConsole.__init__(self, *args, **kwargs)

		def runsource(self, source, *args):
			self.last_buffer = [ source.encode('latin-1') ]
			return InteractiveConsole.runsource(self, source, *args)

		def raw_input(self, *args):
			line = InteractiveConsole.raw_input(self, *args)
			if line == self.edit_command:
				fd, tmpfl = mkstemp('.py')
				os.write(fd, b'\n'.join(self.last_buffer))
				os.close(fd)
				os.system('%s %s' % (self.editor, tmpfl))
				line = open(tmpfl).read()
				os.unlink(tmpfl)
				tmpfl = ''
				lines = line.split( '\n' )
				for i in range(len(lines) - 1): self.push( lines[i] )
				line = lines[-1]
			elif line == self.quit_command:
				sys.exit(0)
			return line
	print
	while True:
		console = Mython(locals=globals())
		try:
			if console.interact() is None:
				return
		except (SystemExit, KeyboardInterrupt):
			raise

_set_up()
_make_console()
