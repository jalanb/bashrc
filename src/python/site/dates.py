import time
import datetime

def now():
    '''A datetime initialised when this is called

    The year will be somtime this century
    >>> 2000 < now().year < 2100
    True

    The month will be between 1 and 12
    >>> 0 < now().month <= 12
    True

    '''
    ts = time.time()
    frac = ts - int(ts)
    year, month, day, hour, minute, second, weekday, yearday, daylight_saving_time = time.gmtime()
    return datetime.datetime(year, month, day, hour, minute, second)
