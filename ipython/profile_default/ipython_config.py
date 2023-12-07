# Configuration file for ipython.

c = get_config()

# -----------------------------------------------------------------------------
# InteractiveShellApp configuration
# -----------------------------------------------------------------------------

# A Mixin for applications that start InteractiveShell instances.
#
# Execute the given command string.
# c.InteractiveShellApp.code_to_run = ''


# lines of code to run at IPython startup.
# c.InteractiveShellApp.exec_lines = []

# A list of dotted module names of IPython extensions to load.
c.InteractiveShellApp.extensions = [
    "rich",
]

# Run the module as a script.
# c.InteractiveShellApp.module_to_run = None

# ------------------------------------------------------------------------------
# TerminalIPythonApp configuration
# ------------------------------------------------------------------------------

# Whether to display a banner upon starting IPython.
c.TerminalIPythonApp.display_banner = False

# ------------------------------------------------------------------------------
# TerminalInteractiveShell configuration
# ------------------------------------------------------------------------------

# TerminalInteractiveShell will inherit config from: InteractiveShell

# Set the color scheme (NoColor, Linux, or LightBG).
c.TerminalInteractiveShell.colors = "Linux"
from IPython.core import ultratb

ultratb.VerboseTB._tb_highlight = "bg:#400000"


# Make IPython automatically call any callable object even if you didn't type
# explicit parentheses. For example, 'str 43' becomes 'str(43)' automatically.
# The value can be '0' to disable the feature, '1' for 'smart' autocall, where
# it is not applied if there are no more arguments on the line, and '2' for
# 'full' autocall, where all callable objects are automatically called (even if
# no arguments are present).
c.TerminalInteractiveShell.autocall = 1

# Number of lines of your screen, used to control printing of very long strings.
# Strings longer than this number of lines will be sent through a pager instead
# of directly printed.  The default value for this is 0, which means IPython
# will auto-detect your screen size every time it needs to print certain
# potentially long strings (this doesn't change the behavior of the 'print'
# keyword, it's only triggered internally). If for some reason this isn't
# working well (it needs curses support), specify it yourself. Otherwise don't
# change the default.
# c.TerminalInteractiveShell.screen_length = 0

# Set the editor used by IPython (default to $EDITOR/vi/notepad).
c.TerminalInteractiveShell.editor = "/usr/local/bin/vim"

# Shortcut style to use at the prompt
c.TerminalInteractiveShell.editing_mode = "vi"

# The part of the banner to be printed before the profile
# c.TerminalInteractiveShell.banner1 = 'Python 2.7.1 (r271:86832, Aug  2 2012, 13:51:44) \nType "copyright", "credits" or "license" for more information.\n\nIPython 1.0.0 -- An enhanced Interactive Python.\n?         -> Introduction and overview of IPython\'s features.\n%quickref -> Quick reference.\nhelp      -> Python\'s own help system.\nobject?   -> Details about \'object\', use \'object??\' for extra details.\n'

# c.TerminalInteractiveShell.debug = False

# Set to confirm when you try to exit IPython with an EOF (Control-D in Unix,
# Control-Z/Enter in Windows). By typing 'exit' or 'quit', you can force a
# direct exit without any confirmation.
c.TerminalInteractiveShell.confirm_exit = False

