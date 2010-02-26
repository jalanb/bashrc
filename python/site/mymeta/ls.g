name	::= <letter>+:x => ''.join(x)
number	::= <digit>+:x => ''.join(x)
block_letter	::= ( 'B' | 'K' | 'M' | 'G' )
real	::= <number>:x '.' <number>:y => float('%s.%s' % (x,y))
block_size	::= ( <real>:n <block_letter>:l ) => int(n * 1024 ** 'BKMG'.index(l))
size	::= ( <block_size> | <number> )
dir_letter 	::=  ( 'd' | '-' )
read_letter	::=  ( 'r' | '-' )
write_letter	::= ( 'w' | '-' )
exec_letter	::=  ( 'x' | 's' | '-' )
mode_group	::= <read_letter> <write_letter> <exec_letter> 
mode	::= <dir_letter> <mode_group> <mode_group> <mode_group>
date	::= <digit><digit> <spaces> <name>
time	::= <digit><digit> ':' <digit><digit>
filetype	::= ( '*' | '@' )
filename	::= ( <anything> )+:f => ''.join(f)
ls_out	::= <spaces> <mode> <spaces> <number> <spaces> <name> <spaces> <name> <spaces> <size>:z <spaces> <date> <spaces> <time> <spaces> <filename>:f => Filename(f,z)
