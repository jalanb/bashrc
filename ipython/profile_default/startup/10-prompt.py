"""Module to provide a prompt I like for ipython"""


import os
import sys
import time


from IPython.terminal.prompts import Prompts
from pygments.token import Token
from pygments.style import Style


# Create a custom style that maps our tokens to specific colors
class BashPromptStyle(Style):
    styles = {
        Token.Prompt.Day: 'ansired',            # Red for day
        Token.Prompt.DateTime: 'ansibrightred', # Light red for date/time
        Token.Prompt.Python: 'ansigreen',      # Green for python version
        Token.Prompt.Venv: 'ansibrightgreen',  # Light green for venv
        Token.Prompt.UserHost: 'ansibrightblue', # Light blue for user@host:path
        Token.Prompt.Arrow: 'ansigreen',       # Green for >>>
    }


class MyPrompt(Prompts):
    def in_prompt_tokens(self, cli=None):
        virtual_env = os.environ.get("VIRTUAL_ENV", "")
        virtual_environment = ""
        if virtual_env:
            virtual_environment = ".%s" % os.path.basename(virtual_env)
        
        return [
            (Token.Text, "0 "),
            (Token.Prompt.Day, time.strftime("%A")),
            (Token.Prompt.DateTime, time.strftime(" %Y-%m-%d.%H:%M:%S")),
            (Token.Prompt.Python, " python%s" % sys.version.split()[0]),
            (Token.Prompt.Venv, virtual_environment),
            (Token.Prompt.UserHost, " %s@%s:%s" % (
                os.environ.get("USER", "nobody"),
                os.uname()[1],
                os.getcwd(),
            )),
            (Token.Prompt.Arrow, "\n>>> "),
        ]


# Set the custom prompt and style
get_ipython().prompts = MyPrompt(get_ipython())

# Try to set the custom style
try:
    get_ipython().highlighting_style = BashPromptStyle
except:
    pass  # Fallback to default style if this doesn't work
