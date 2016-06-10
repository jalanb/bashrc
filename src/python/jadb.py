
import os

import dotsite as site


import pudbs

def back_trace():
    site.term_size = site.term.screen_width(), site.term.screen_height()
    pudbs.back_trace(site.term_size. pudbs.frame_above())

if __name__ == '__main__':
    back_trace()
