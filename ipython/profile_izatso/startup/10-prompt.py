"""Module to provide a prompt I like for ipython"""


import os
import sys
import time


from IPython.utils import coloransi
from IPython.core.prompts import LazyEvaluate as promptify


@promptify
def prompt():
    color = coloransi.TermColors()
    virtual_env = os.environ.get('VIRTUAL_ENV', '')
    virtual_environment = ''
    if virtual_env:
        virtual_environment = '.%s' % os.path.basename(virtual_env)
    return '%s0 %s[%s%s python%s%s %s@%s:%s%s]%s%s\n>>> ' % (
        color.White,
        color.LightRed,
        color.LightCyan,
        time.strftime("%A %Y-%m-%d.%H:%M:%S"),
        sys.version.split()[0],
        virtual_environment,
        os.environ.get('USER', 'nobody'),
        os.uname()[1],
        os.getcwd(),
        color.LightRed,
        color.Normal,
        color.Green,
    )

my_prompt = prompt()
