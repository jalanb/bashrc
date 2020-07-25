"""Handle nice names"""

import base64

from pysyte.oss import platforms


def nice(data):
    return base64.b64encode(bytes(data, 'utf-8'))


def name(data):
    return base64.b64decode(data).decode('utf-8')


def chmod(data, *_):
    platforms.put_clipboard_data(name(data))
    return ''
