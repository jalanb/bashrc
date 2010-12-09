import libfm

def api_key():
	return '2a8bc6369cdaaf9101ec74b29432b95a'

def api_secret():
	return 'e0965872b7f5a0988d41fd1f44471506'

def username():
	return 'jalanb'

def password():
	return 'bcx4bzrt'

def init():
	lib_fm = libfm.LibFM(api_key(),api_secret())
	lib_fm.create_mobile_session(username(),password())
	return lib_fm

class LastFmPlayedTrack:
	def __init__(self,data):
		self.artist = data['artist']['#text']
		self.album = data['album']['#text']
		self.track = data['name']
		self.date = data['date']['#text']

	def __str__(self):
		return '%s/%s at %s' % (self.artist, self.track, self.date)

	def __repr__(self):
		return '<LastFmPlayedTrack %r>' % unicode(self)

def my_recent_tracks(session):
	first = session.read('user.getRecentTracks',user='jalanb',limit=1)
	number_of_tracks = first['recenttracks']['@attr']['totalPages']
	result = []
	i = 1
	while len(result) < number_of_tracks and i < 2:
		tracks = session.read('user.getRecentTracks',user='jalanb',page=i,limit=200)[u'recenttracks']['track']
		result.extend( [LastFmPlayedTrack(t) for t in tracks])
		i = i + 1
	return number_of_tracks, result
