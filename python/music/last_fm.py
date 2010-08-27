import urllib

def api_key():
	return '2a8bc6369cdaaf9101ec74b29432b95a'

def api_secret():
	return 'e0965872b7f5a0988d41fd1f44471506'

def get_recent_tracks(username):
	url = "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=%s&api_key=%s&limit=%s" % (username, api_key(), 1000)
	return urllib.urlopen(url)
	return response.get('status')

