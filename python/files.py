def backup_with_suffix(filename,suffix):
	text = file(filename).read()
	file('%s%s' % (filename,suffix),'w').write(text)

def looks_like_this(filename, limits = None, numbers=True, space=' ', tab='	', sol=None, eol=None, count_from=1):
	if not limits:
		start = 0
	else:
		start = limits[0]
	lines = file(filename).readlines()
	if not limits:
		end = len(lines)
	else:
		end = limits[1]
	for i, line in enumerate( file(filename).readlines() ):
		line_number = i + count_from
		if line_number >= start:
			if space: line = line.replace(' ',space)
			if tab: line = line.replace('	',tab)
			if sol: line = '%s%s' % (sol,line)
			if numbers: line = '%2d: %s' % (line_number,line)
			if eol:
				print line.replace('\n',eol)
			else:
				print line,
		if line_number >= end:
			break
