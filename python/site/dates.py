import time
import datetime

def now():
	ts = time.time()
	frac = ts - int(ts)
	year, month, day, hour, minute, second, weekday, yearday, daylight_saving_time = time.gmtime()
	return datetime.datetime(year, month, day, hour, minute, second)
