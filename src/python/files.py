"""Methods to handle text files"""


def backup_with_suffix(filename, suffix):
    text = file(filename).read()
    file('%s%s' % (filename, suffix), 'w').write(text)


# pylint: disable-msg=too-many-arguments
def looks_like_this(filename, limits=None, numbers=True, space=' ', tab='\t',
                    sol=None, eol=None, count_from=1):
    lines = file(filename).readlines()
    lines = _look_like_that(lines, limits, count_from, numbers, space, tab, sol)
    for line in lines:
        if eol:
            print line.replace('\n', eol)
        else:
            print line,


def _limits_to_lines(limits, max_end):
    start, end = limits and limits or (1, max_end)
    return start - 1, end - 1


def _look_like_that(lines, limits, count_from, numbers, space, tab, sol):
    start, end = _limits_to_lines(limits, len(lines))
    if start < 0:
        return []
    result = []
    for i, line in enumerate(lines[start:], start=start):
        line_number = i + count_from
        if space:
            line = line.replace(' ', space)
        if tab:
            line = line.replace('\t', tab)
        if sol:
            line = '%s%s' % (sol, line)
        if numbers:
            line = '%2d: %s' % (line_number, line)
        result.append(line)
        if line_number > end:
            break
    return result
