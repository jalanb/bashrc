"""Methods to provide names for colours

And numbers for those names"""


def bw():
    """The simplest of all - no colour and full colour"""
    return 'black white'.split()


def rgb():
    """The basic cone sensitivities of your eyes"""
    return 'red green blue'.split()


primaries = rgb


def cym():
    """The complements of the primaries"""
    return 'cyan yellow magenta'.split()


secondaries = complementaries = cym


def basic():
    """The basic colour names: Black, the primaries, their complements and white"""
    return bw() + rgb() + cym()


def _cga_colour_names():
    """The basic CGA colours are in a slightly different order"""
    return 'red green yellow blue magenta cyan'.split()


def dark_cga():
    return ['black'] + _cga_colour_names() + ['silver']


def light_cga():
    return ['gray'] + [str('light %s' % name) for name in _cga_colour_names()]  + ['white']


def cga():
    return dark_cga() + light_cga()
