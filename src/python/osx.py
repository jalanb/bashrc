"""Mac-specific code"""

import subprocess


def get_clipboard_data():
    """Get data from clipboard (OSX)"""
    process = subprocess.Popen(['pbpaste'], stdout=subprocess.PIPE)
    retcode = process.wait()
    data = process.stdout.read()
    return data
