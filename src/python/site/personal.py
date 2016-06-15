"""Module to hold info about my personal mail"""


import os
import re


def personal_name():
    """What I call me"""
    return '%s %s' % (forename().title(), surname().title())


def family_name():
    """What my parents called me"""
    return surname().title()


def surname():
    """What I call my kids"""
    return 'brogan'


def forename():
    """The name I use before my surname"""
    return 'alan'


def family_emails():
    """Email addresses for my family"""
    return [
        'oisin%s@gmail.com' % surname(),
        'Kristin.%s@staff.ittralee.ie' % family_name(),
        'fiachra.%s@gmail.com' % surname(),
    ]


def personal_domain():
    """The domain name I use"""
    return 'al-got-rhythm.net'


def personal_email(username):
    """An email address for someone who is really me"""
    return _with_domain(username, '@', personal_domain)


def in_personal_domain(address):
    """Whether that address is in my domain"""
    try:
        import tldextract
        ext = tldextract.extract(address)
        if ext:
            return ext.registered_domain == personal_domain()
    except ImportError:
        pass
    _, domain = address.rsplit('@', 1)
    return domain == personal_domain()


def employee_username():
    """What my employer's machines use as my name"""
    return '%s%s' % (forename(), surname()[0])


def employee_address():
    """The address my employer sends email to for me """
    return employer_email(employee_username())


def employer_email(username):
    """An email address for someone at my company"""
    return _with_employer_domain(username, '@')


def employer_server(server):
    """A server at my company"""
    return _with_employer_domain(server, '.')


def path_to_employer_repositories():
    """Where my company keeps their repositories"""
    return 'file:///usr/local/svn'


def regular_reports():
    """A list of senders and subjects for regular report emails"""
    return [
        ('Mary Dwyer', re.compile('3G RCS Weekly Report.*')),
    ]


def spam_recipient():
    """They send spam email to this address"""
    return employer_email('iwalter')


def _with_employer_domain(prefix, joiner):
    """Join the prefix to the domain of my main work"""
    return _with_domain(prefix, joiner, _employer_domain)


def _with_domain(prefix, joiner, domain):
    """Join the prefix to the domain of my main work"""
    return joiner.join([prefix, domain()])


def _employer_domain():
    """The domain name my company uses"""
    return '%s.com' % employer_name()


def employer_name():
    """The name of my company"""
    return 's3group'


def mail_site_name():
    """The name of the mail site on localhost"""
    return 'mail'


def join_mail_site(prefix):
    """Join the name of the mail site on localhost to the prefix"""
    return os.path.join(prefix, mail_site_name())


def path_in_localhost(filename):
    """Where we store files for viewing on localhost

    >>> print path_in_localhost('fred.html')
    /.../Sites/mail/fred.html
    """
    mail_site = os.environ.get('MAIL_SITE_DIRECTORY')
    if not mail_site:
        sites = os.path.join(os.path.expanduser('~'), 'Sites')
        mail_site = join_mail_site(sites)
    return os.path.join(mail_site, filename)


def url_in_localhost(filename):
    """Where we view filename on localhost

    >>> print url_in_localhost('fred.html')
    http://localhost/.../mail/fred.html
    """
    home_name = os.path.basename(os.path.expanduser('~'))
    sites_name = 'http://localhost/~%s' % home_name
    mail_site = join_mail_site(sites_name)
    return os.path.join(mail_site, filename)
