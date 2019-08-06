"""Handle nice names"""

import re
import base64

from pysyte.oss import platforms
# from pysyte.oss.platforms import put_clipboard_data


def nice(data):
    return base64.b64encode(bytes(data, 'utf-8'))


def name(data):
    platforms.put_clipboard_data(base64.b64decode(data).decode('utf-8'))
    return ''

def chmod(data, *args):
    return name(data)
