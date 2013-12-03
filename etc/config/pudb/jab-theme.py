# Supported 16 color values:
# 'h0' (color number 0) through 'h15' (color number 15)
# or
# 'default' (use the terminal's default foreground),
# 'black', 'dark red', 'dark green', 'brown', 'dark blue',
# 'dark magenta', 'dark cyan', 'light gray', 'dark gray',
# 'light red', 'light green', 'yellow', 'light blue',
# 'light magenta', 'light cyan', 'white'
#
# Supported 256 color values:
# 'h0' (color number 0) through 'h255' (color number 255)
#
# 256 color chart: http://en.wikipedia.org/wiki/File:Xterm_color_chart.png
#
# "setting_name": (foreground_color, background_color),

# See this URL to see what keys there are:
# https://github.com/inducer/pudb/blob/master/pudb/theme.py

# This file is exec'd by pudb, so does not play nice with pylint
# Specifically - some globals are supplied, with look undefined to pylint
#
# pylint: disable-msg=E0602

# Initially set a palette to dark vim
palette.update({
	"header": ("black", "light gray", "standout"),
	# {{{ variables view
		"variables": ("black", "dark gray"),
		"variable separator": ("dark cyan", "light gray"),
		"var label": ("light gray", "dark gray"),
		"var value": ("white", "dark gray"),
		"focused var label": ("light gray", "light blue"),
		"focused var value": ("white", "light blue"),
		"highlighted var label": ("light gray", "dark green"),
		"highlighted var value": ("white", "dark green"),
		"focused highlighted var label": ("light gray", "light blue"),
		"focused highlighted var value": ("white", "light blue"),
		"return label": ("light gray", "dark gray"),
		"return value": ("light cyan", "dark gray"),
		"focused return label": ("yellow", "light blue"),
		"focused return value": ("white", "light blue"),
	# }}}
	# {{{ stack view
		"stack": ("black", "dark gray"),
		"frame name": ("light gray", "dark gray"),
		"focused frame name": ("light gray", "light blue"),
		"frame class": ("dark blue", "dark gray"),
		"focused frame class": ("dark blue", "light blue"),
		"frame location": ("white", "dark gray"),
		"focused frame location": ("white", "light blue"),
		"current frame name":
			(add_setting("white", "bold"), "dark gray"),
		"focused current frame name":
			(add_setting("white", "bold"), "light blue", "bold"),
		"current frame class": ("dark blue", "dark gray"),
		"focused current frame class": ("dark blue", "dark green"),
		"current frame location": ("light cyan", "dark gray"),
		"focused current frame location": ("light cyan", "light blue"),
	# }}}
	# {{{ breakpoint view
		"breakpoint": ("light gray", "dark gray"),
		"focused breakpoint": ("light gray", "light blue"),
		"current breakpoint":
			(add_setting("white", "bold"), "dark gray"),
		"focused current breakpoint":
			(add_setting("white", "bold"), "light blue"),
	# }}}
	# {{{ ui widgets
		"selectable": ("light gray", "dark gray"),
		"focused selectable": ("white", "light blue"),
		"button": ("light gray", "dark gray"),
		"focused button": ("white", "light blue"),
		"background": ("black", "light gray"),
		"hotkey":
			(add_setting("black", "underline"), "light gray", "underline"),
		"focused sidebar": ("light blue", "light gray", "standout"),
		"warning":
			(add_setting("white", "bold"), "dark red", "standout"),
		"label": ("black", "light gray"),
		"value": ("white", "dark gray"),
		"fixed value": ("light gray", "dark gray"),
		"search box": ("white", "dark gray"),
		"search not found": ("white", "dark red"),
		"dialog title":
			(add_setting("white", "bold"), "dark gray"),
	# }}}
	# {{{ source view
		"breakpoint marker": ("dark red", "black"),
		"breakpoint source": ("light gray", "dark red"),
		"breakpoint focused source": ("black", "dark red"),
		"current breakpoint source": ("black", "dark red"),
		"current breakpoint focused source": ("white", "dark red"),
	# }}}
	# {{{ highlighting
		"source": ("white", "black"),
		"focused source": ("white", "light blue"),
		"highlighted source": ("black", "dark magenta"),
		"current source": ("black", "light gray"),
		"current focused source": ("white", "dark cyan"),
		"current highlighted source": ("white", "dark cyan"),
		"line number": ("dark gray", "black"),
		"keyword": ("yellow", "black"),
		"literal": ("dark magenta", "black"),
		"string": ("dark magenta", "black"),
		"doublestring": ("dark magenta", "black"),
		"singlestring": ("dark magenta", "black"),
		"docstring": ("dark magenta", "black"),
		"name": ("light cyan", "black"),
		"punctuation": ("yellow", "black"),
		"comment": ("light blue", "black"),
	# }}}
	# {{{ shell
		"command line edit": ("white", "black"),
		"command line prompt":
			(add_setting("yellow", "bold"), "black"),
		"command line output":
			(add_setting("yellow", "bold"), "black"),
		"command line input": ("white", "black"),
		"command line error":
			(add_setting("light red", "bold"), "black"),
		"focused command line output": ("black", "light blue"),
		"focused command line input":
			(add_setting("light cyan", "bold"), "light blue"),
		"focused command line error": ("black", "light blue"),
	# }}}
})
#
# Then customize to local colours
#
palette.update({
	"variables": ("dark red", "dark gray"),
	"breakpoint source":
		(add_setting("light red", 'underline'), "black"),
	"breakpoint focused source":
		(add_setting("light red", 'underline'), "h8"),
	"current breakpoint source":
		(add_setting("black", 'underline'), "dark red"),
	"current breakpoint focused source":
		(add_setting("white", 'underline'), "dark red"),
	"source": ("light green", "black"),
	"focused source": ("black", "h8"),
	"highlighted source": ("black", "light blue"),
	"current source": ("light red", "black"),
	"current focused source": ("black", "h88"),
	"current highlighted source": ("white", "light red"),
	"line number": ("yellow", "black"),
	"keyword": ("light red", "black"),
	"literal": ("light cyan", "black"),
	"string": ("H159", "black"),
	"doublestring": ("h159", "black"),
	"singlestring": ("h159", "black"),
	"docstring": ("h159", "black"),
	"name": ("h68", "black"),
	"punctuation": ("yellow", "black"),
	"comment": ("light gray", "black"),
})
