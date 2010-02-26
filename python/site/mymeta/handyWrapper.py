from pymeta.runtime import ParseError
class HandyWrapper(object):
    """
    Convenient grammar wrapper for parsing strings.
    """
    def __init__(self, grammar):
        """
        @param grammar: The grammar class to be wrapped.
        """
        self.grammar = grammar


    def __getattr__(self, rule_name):
        """
        Return a function that will instantiate a grammar and invoke the named
        rule.
        @param: Rule rule_name.
        """
        def doIt(string_to_be_parsed):
            """
            @param string_to_be_parsed: The string to be parsed by the wrapped grammar.
            """
            obj = self.grammar(string_to_be_parsed)
            result = obj.apply(rule_name)
            try:
                extra = obj.input.head()
            except IndexError:
                try:
                    return ''.join(result)
                except TypeError:
                    return result
            else:
                raise ParseError("trailing garbage in input: %s" % (extra,))
        return doIt

