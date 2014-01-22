from spine import Spine
from words import pluralize


class Tally(Spine, list):
    """Tally is a kind of list.

    This tally is intended to be sub-classed,
        and provides conveniences to represent the class name nicely

    """
    def __str__(self):
        """Represent the list as a string

        A list of chars
        >>> str(Tally('abc'))
        'abc'

        A list of non-chars
        >>> str(Tally([1, 2, 3]))
        '[1, 2, 3]'
        """
        try:
            return self.as_str()
        except TypeError:
            return self.to_str()

    def __repr__(self):
        """Represent the list as a type

        A list of chars
        >>> Tally('abc')
        <Tally 'abc'>

        A list of non-chars
        >>> Tally([1, 2, 3])
        <Tally [1, 2, 3]>
        """
        try:
            return '<%s %r>' % (self.class_name(), self.as_str())
        except TypeError:
            return '<%s %s>' % (self.class_name(), self.to_str())

    def as_str(self, separator=None):
        """Use the separator to join the chars into a string

        >>> Tally('123').as_str('|')
        '1|2|3'
        """
        if separator is None:
            separator = ''
        return separator.join(self)

    def to_str(self, i=None, j=None, separator=None):
        """Turn the list into a string

        i and j are indices to take only part of the list

        >>> Tally([0, 1, 2, 3, 4, 5]).to_str()
        '[0, 1, 2, 3, 4, 5]'
        >>> Tally([0, 1, 2, 3, 4, 5]).to_str(2, 5, '|')
        '[2|3|4]'
        """
        if i is None and j is None:
            items = self
        elif i is None:
            items = self[:j]
        elif j is None:
            items = self[i:]
        else:
            items = self[i:j]
        if separator is None:
            separator = ', '
        return '[%s]' % separator.join([repr(s) for s in items])

    def list_name(self):
        """The plural of the class name

        Intended as the name to use for a list of these objects

        >>> print Tally().list_name()
        Tallies
        """
        try:
            list_of_items = self[0].list_name()
        except AttributeError:
            list_of_items = ''
        except IndexError:
            list_of_items = ''
        if self.class_name() == list_of_items:
            return self.class_name()
        return pluralize(self.class_name())

    def str_class_and_list(self):
        """A tuple with three strings for the value, class and list names

        >>> print Tally().str_class_and_list()
        ('', 'Tally', 'Tallies')
        """
        return str(self), self.class_name(), self.list_name()


def tlist(name, super_classes=None, name_space=None):
    """Create a sub-class of Tally with the given name

    Super classes and a namespace can also be supplied

    >>> tlist('world')('Hello').str_class_and_list()
    ('Hello', 'world', 'worlds')
    """
    if super_classes is None:
        super_classes = []
    if name_space is None:
        name_space = {}
    class MySecondMeta(type):
        def __init__(mcs, _name, _super_classes, _name_space):
            # pylint: disable-msg=W0231
            mcs.lets_tlist_again_like_we_did_last_summer = True
    escaped = name.replace(' ', '_')
    return MySecondMeta(escaped, (Tally, ), name_space)

