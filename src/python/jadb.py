
from dotsite import term


import pudbs


def back_trace():
    term_size = term.screen_width(), term.screen_height()
    pudbs.back_trace(term_size, pudbs.frame_above())

if __name__ == '__main__':
    back_trace()
