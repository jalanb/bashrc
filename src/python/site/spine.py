# -*- coding: utf-8 -*-

"""Show the spine of a class"""


from words import pluralize


class Spine:
    """A spine has "enough backbone to stand up for itself"

    In other words - it can provide its class name
    It is primarily intended as a mixin for sub-classes"""

    def full_class_name(self):
        """The fully qualified class name for the Spine (or sub-class)

        >>> Spine().full_class_name()  == 'spine.Spine'
        True
        """
        class_repr = str(self.__class__)
        prefix = "<class '"
        suffix = "'>"
        trimmed = class_repr.replace(prefix, '').replace(suffix, '')
        return trimmed

    def class_name(self):
        """The class name for the Spine (or sub-class)

        >>> Spine().class_name()  == 'Spine'
        True
        """
        return self.__class__.__name__

    def list_name(self):
        """The list name for the Spine (or sub-class)

        What should a collection of these things be called ?

        >>> Spine().list_name() == 'Spines'
        True
        """
        return pluralize(self.class_name())

    def __repr__(self):
        """Represent the Spine

        >>> Spine()
        <Spine>
        """
        name = self.class_name()
        try:
            string = self.__str__()
            return u'<%s %r>' % (name, string)
        except AttributeError:
            return u'<%s>' % name

