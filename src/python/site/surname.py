"""Handle pretty names"""

import base64

def pretty(s):
    return base64.b64encode(bytes(s, 'utf-8'))

def plain(s):
    return base64.b64decode(s).decode('utf-8')
