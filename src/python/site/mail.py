# pylint: disable=too-many-lines
"""This program should handle mail

It is not a full mail reader,
    just a way to quickly "mark as read" most emails
"""

# TODO: "Too many lines in buffer"
# pylint: disable-msg=C0302

import re
import sys
import time
import email
import email.utils
import email.header
import socket
import imaplib
import inspect
import commands


try:
    import pudb
except ImportError:
    pass
import getch
import private

import colours


def get_new_payload(part, content_type, old_payload):
    if part.get_content_type() != content_type:
        return old_payload, False
    attachments = False
    if old_payload:
        filename = part.get_filename(False)
        if filename:
            attachments = True
        payload = old_payload
    else:
        payload = part.get_payload(decode=True)
    return payload, attachments


def peek_at(connection, message_id, text_name, prefix):
    response, data = connection.fetch(
        message_id, '(BODY.PEEK[%s])' % text_name)
    assert response == 'OK', response
    (_som, text), _eom = data
    return email.message_from_string(prefix + text)


def peek_header(connection, message_id):
    """Read the header of the given message id"""
    return peek_at(connection, message_id, 'HEADER', '')


def mail_html():
    """Filename into which we store any html for viewing on localhost"""
    return 'mail.html'


def peek_body(connection, message_id, header):
    """Read the body of the given message id"""
    message = peek_at(connection, message_id, 'TEXT', str(header))
    text = None
    html = None
    attachments = False
    simple_parts = [part
                    for part in message.walk()
                    if not part.is_multipart()]
    for part in simple_parts:
        html, extra_html = get_new_payload(part, 'text/html', html)
        text, extra_text = get_new_payload(part, 'text/plain', text)
        attachments = attachments or extra_html or extra_text
    if html:
        file(private.path_in_localhost(mail_html()), 'w').write(html)
    if text:
        return text, bool(html), attachments
    elif html:
        return 'No plain text in message', True, attachments
    else:
        return 'No plain text nor html in message', True, attachments
    print header
    pudb.set_trace()
    raise ValueError('No plain text in message')


def strip_subject(message):
    re_prefix = re.compile(r'^(R[Ee]|F[Ww]):\s*')
    try:
        return re_prefix.sub('', message['subject'])
    except (TypeError, KeyError):
        return ''


def destination_address_names():
    return 'to cc bcc'.split()


def known_address_names():
    return destination_address_names() + ['from']


def sent_to_address(message, sought):
    for address_name in destination_address_names():
        addresses = get_addresses(message, address_name)
        if has_email_address(addresses, sought):
            return True
    return False


def sent_to_addresses(message, receivers):
    return any(
        [sent_to_address(message, receiver) for receiver in receivers])


def sent_to_receivers_at_personal_domain(message, receivers):
    addresses = [private.personal_email(receiver) for receiver in receivers]
    return sent_to_addresses(message, addresses)


def only_sent_to_address(message, sought):
    addresses = get_addresses(message, 'to')
    return len(addresses) == 1 and has_email_address(addresses, sought)


def decode_safely(string, charset='ascii'):
    """Return string decoded according to charset, but do so safely."""
    try:
        return string.decode(charset or 'ascii', 'replace')
    except LookupError:  # bogus charset
        return string.decode('ascii', 'replace')


def decode_rfc2047_header(message):
    """Get values from a message according as their charset

    From stackoverflow at http://stackoverflow.com/a/4158170/500942
    """
    return ' '.join(
        decode_safely(string, charset)
        for string, charset in email.header.decode_header(message))


def get_addresses(message, address_name):
    if address_name not in known_address_names():
        raise KeyError('No such addresses: %r' % address_name)
    try:
        address_string = message[address_name]
    except KeyError:
        address_string = message[address_name.title()]
    if not address_string:
        return []
    address_list = address_string.split(',')
    return [email.utils.parseaddr(s) for s in address_list]


def sent_from(message):
    return get_addresses(message, 'from')


def first_sender(message):
    return sent_from(message)[0]


def first_sender_name(message):
    name, _address = first_sender(message)
    return decode_rfc2047_header(name)


def first_sender_address(message):
    _name, address = first_sender(message)
    return address


def first_sender_domain(message):
    try:
        return first_sender_address(message).rsplit('@', 1)[1]
    except IndexError:
        return ''


def sent_by(message, name):
    addresses = sent_from(message)
    return has_email(addresses, name)


def sent_by_name(message, name):
    addresses = sent_from(message)
    return has_email_name(addresses, name)


def sent_by_names(message, names):
    return any([sent_by_name(message, name) for name in names])


def sent_by_address(message, address):
    addresses = sent_from(message)
    return has_email_address(addresses, address)


def sent_by_addresses(message, addresses):
    return any([sent_by_address(message, address) for address in addresses])


def has_email(addresses, regexp):
    for name, address in addresses:
        if regexp == name or regexp == address:
            return True
        try:
            if regexp.match(name) or regexp.match(address):
                return True
        except AttributeError:
            pass
    return False


def has_email_name(addresses, sought):
    return has_email_part(addresses, sought, 0)


def has_email_address(addresses, sought):
    return has_email_part(addresses, sought, 1)


def has_email_part(addresses, sought, part_index):
    use_match = hasattr(sought, 'match')
    for parts in addresses:
        part = parts[part_index]
        if use_match:
            if sought.match(part):
                return True
        else:
            if part == sought:
                return True
    return False


def heading_prefix():
    return '======'


def coloured_text(key, value):
    key_colours = {
        'date': 'yellow',
        'subject': 'green',
        'commit': 'light green',
        'from': 'magenta',
        'to': 'red',
        'cc': 'light red',
        'bcc': 'light red',
        heading_prefix(): 'light cyan',
    }
    colour = key_colours.get(key.lower(), 'gray')
    if key == heading_prefix():
        text = colours.colour_text(heading_prefix(), colour)
        return '%s %s %s' % (text, value, text)
    else:
        text = '%s:' % key
        text = colours.colour_text(text, colour)
        return '%s %s' % (text, value)


def show_heading(value):
    print coloured_text(heading_prefix(), value)


def show_subject(message):
    subject = strip_subject(message)
    print coloured_text('Subject', subject)


def show_from_name(message):
    print coloured_text('From', first_sender_name(message))


def show_from_address(message):
    print coloured_text('From', first_sender_address(message))


def show_to(message):
    for address_name in destination_address_names():
        addresses = get_addresses(message, address_name)
        if not addresses:
            continue
        email_addresses = [email_address for _name, email_address in addresses]
        print coloured_text(address_name.title(), ', '.join(email_addresses))


def show_date(message):
    print coloured_text('Date', message['date'])


def confirm_reading():
    print colours.colour_text('Have you read this?', 'red')
    if get_yes():
        return 'read'


def confirm_boring():
    print colours.colour_text('Have you read this?', 'red')
    reply = get_reply(' yb')
    if not reply:
        return None
    if reply in ' y':
        return 'read'
    if reply == 'b':
        return 'boring'


def confirm_forwarding():
    print colours.colour_text('Forward it?', 'red')
    return get_yes()


def ask_about_reading(responses):
    print colours.colour_text('Have you read this?', 'red')
    key = get_a_key()
    if key in ' yY':
        return 'read'
    if key in responses:
        return key


def commit_author(message):
    return first_sender_address(message)


def split_commit_text(text):
    lines = text.splitlines()
    repository_line, lines = lines[0], lines[1:]
    comment, lines = lines[0], lines[1:]
    issue, lines = lines[0], lines[1:]
    return repository_line, comment, issue, lines


def matched_groups(match):
    if not match:
        return tuple()
    if not match.groups():
        if match.group():
            return match.group(),
    return match.groups()


def match_subject(message, regexp):
    subject = strip_subject(message)
    match = regexp.match(subject)
    return matched_groups(match)


def search_subject(message, regexp):
    subject = strip_subject(message)
    match = regexp.search(subject)
    return matched_groups(match)


def has_subject(message, sought):
    if hasattr(sought, 'match'):
        return bool(match_subject(message, sought))
    return sought == strip_subject(message)


def has_subject_with(message, sought):
    if hasattr(sought, 'match'):
        return bool(search_subject(message, sought))
    return sought in strip_subject(message)


def has_subject_starting(message, sought):
    subject = strip_subject(message)
    return subject.startswith(sought)


def read_issue_subject(message):
    try:
        issue_regexp = r'\[(issue|bug)[^0-9]*(?P<issue>[0-9]+)\]\s*()'
        issue_subject = re.compile(issue_regexp)
        # pylint: disable=unbalanced-tuple-unpacking
        _, issue, title = match_subject(message, issue_subject)
        return issue, title
    except ValueError:
        return None, None


timed_out = [False]


def read_issue(issue_id):
    if timed_out[0]:
        return ''
    command = private.get_issue_data_command(issue_id)
    status, output = commands.getstatusoutput(command)
    if not status:
        return output
    if 'Operation timed out' in output:
        timed_out[0] = True
        return ''
    raise ValueError(r'%r\n%r' % (command, output))


def parse_issue(output):
    result = {}
    for line in output.splitlines():
        if ':' in line:
            key, value = [s.strip() for s in line.split(':', 1)]
            result[key.lower()] = value
    return result


def testing():
    return False


def get_yes():
    return get_answer(' y')


def get_answer(keys):
    return get_reply(keys) is not None


def get_reply(keys):
    key = get_a_key()
    all_keys = '%s%s' % (keys, keys.strip().upper())
    if key in all_keys:
        return key.lower()
    return None


def get_a_key():
    key = ' ' if testing() else getch.getch().lower()
    if ord(key) == 3:
        raise KeyboardInterrupt
    if key in 'qQ':
        sys.exit(1)
    return key


def assigned_to_someone_else(text):
    assign_regexp = re.compile('[aA]ssign(ed|ing) to (?P<assignee>[^ ]+)')
    match = assign_regexp.search(text)
    return match and 'Alan' != match.groupdict()['assignee'] or False


shown_issues = set()


def boring_issues_filename():
    return 'boring_issues.txt'


def boring_issues_file(mode='r'):
    return file(boring_issues_filename(), mode)


def add_boring_issue(issue_id):
    if is_boring_issue(issue_id):
        return
    output = None
    try:
        output = boring_issues_file('a')
        print >> output, issue_id
    finally:
        if output:
            output.close()


def is_boring_issue(issue):
    for line in boring_issues_file():
        if line.strip() == issue.strip():
            return True
    return False


def handle_itissue(header, text):
    show_subject(header)
    show_date(header)
    show_all(text)
    return confirm_reading()


def handle_issue(header, text, issue_id):
    if not issue_id:
        pudb.set_trace()
    if is_boring_issue(issue_id):
        return 'Handled: boring issue %s' % issue_id
    output = read_issue(issue_id)
    if output:
        issue = parse_issue(output)
        if private.personal_name() in issue['assigned to']:
            show_heading('Assigned to me')
            print output
            show_date(header)
            show_some(text)
            return confirm_reading()
        if issue['status'] == 'Closed':
            return 'Handled: closed issue %s' % issue_id
    if assigned_to_someone_else(text):
        return 'Handled: Issue assigned to someone else %s' % issue_id
    if issue_id not in shown_issues:
        if output:
            print output
        else:
            show_heading('Issue email')
        shown_issues.add(issue_id)
    show_subject(header)
    show_from_name(header)
    show_date(header)
    show_some(text)
    reply = confirm_boring()
    if reply == 'boring':
        add_boring_issue(issue_id)
    return reply


def about_mail_delivery():

    def check(header):
        delivery_names = [
            re.compile('^Mail Delivery S(ubs)?ystem')
        ]
        delivery_addresses = [
            re.compile('postmaster@.*'),
            re.compile('MAILER-DAEMON@.*'),
        ]
        if sent_by_names(header, delivery_names):
            return True
        return sent_by_addresses(header, delivery_addresses)

    def handle(header, text):
        boring_mail_delivery_subjects = [
            'Undeliverable:.*',
            'Warning: could not send message for past.*',
            'Undelivered Mail Returned to Sender',
            'failure notice',
            'Delivery Status Notification.*',
            'Mail delivery failed:.*',
        ]
        for subject in boring_mail_delivery_subjects:
            subject_regexp = re.compile(subject)
            if has_subject(header, subject_regexp):
                template = 'Handled: boring mail delivery subject %r'
                return template % strip_subject(header)
        boring_mail_delivery_bodies = [
            'potentially executable attachment "original.eml"'
        ]
        for body in boring_mail_delivery_bodies:
            if body in text:
                return 'Handled: boring mail delivery body'
        show_heading('Mail delivery')
        show_subject(header)
        show_some(text)
        return confirm_reading()

    return check, handle


def sent_to_meeting_rooms():

    def check(header):
        meetingrooms = re.compile(private.employer_email('meetingroom[0-9]'))
        return sent_to_address(header, meetingrooms)

    def handle(header, text):
        if has_subject_starting(header, 'Cancelled: '):
            return 'Handled: Meeting Cancelled %r' % strip_subject(header)
        show_heading('To meeting room')
        show_subject(header)
        show_some(text)
        return confirm_reading()

    return check, handle


def regular_reports():

    def check(header):
        for sender, subject in private.regular_reports():
            if sent_by(header, sender) and has_subject(header, subject):
                return True
        return False

    def handle(header):
        return 'Handled: regular report %r' % strip_subject(header)

    return check, handle


def senders_of_spam():
    return [
        'theboxteam@box.com',
        'noreply@bbb.org',
    ]


def spam_messages():

    def check(header):
        if sent_by_addresses(header, senders_of_spam()):
            return True
        spams = [' [fF]ree ', ' career ', ' degree ', ]
        if any([has_subject_with(header, re.compile(_)) for _ in spams]):
            if sent_to_address(header, private.employer_email('webmaster')):
                return True
            if only_sent_to_address(header, private.spam_recipient()):
                return True
        return False

    def handle(header):
        return 'Handled: Spam %r' % strip_subject(header)

    return check, handle


def has_out_of_office():
    def check(header, text):
        ooo_regexp = re.compile(r'''
            (OOO\s+.*)|
            (OUT OF OFFICE AUTOMATED RESPONSE)|
            (
                (
                    I
                    (\s+(am|will\s+be))
                    |
                    ('(m|ll\s+be))
                )
                \s+
                (away\s+as\sam\s)?
                (
                    (out\s+of\s+(the\s+)?office)
                    |
                    (on\s+
                          (PTO|vacation|leave|travel|holidays)
                    )
                    | (in\s+
                          (annual break)
                    )
                    |
                    (at\s+
                        (an\s+offsite\s+meeting)
                    )
                    |
                    (off\s+from.*to)
                )
            )
        ''', re.VERBOSE)
        subject = strip_subject(header)
        lines = text.splitlines()[:10]
        lines.insert(0, subject)
        for line in lines:
            if ooo_regexp.search(line):
                return True
        return False

    def handle(header):
        show_from_name(header)
        return 'Handled: OOO %r' % strip_subject(header)

    return check, handle


def unread_message_ids_in(connection, folder_name):
    return _search_message_ids_in(connection, folder_name, '(UnSeen)')


def _search_message_ids_in(connection, folder_name, sought):
    connection.select(folder_name)
    response, data = connection.search(None, sought)
    assert response == 'OK', response
    messages_string = data[0]
    return messages_string.split()


def read_message_ids_in(connection):
    response, data = connection.search(None, '(Seen)')
    assert response == 'OK', response
    messages_string = data[0]
    return set(messages_string.split())


def connect(account):
    credentials, message_functions, read_folder, unread_folder = account()
    server, username, password = credentials()
    try:
        connection = imaplib.IMAP4_SSL(server)
    except socket.gaierror, e:
        print >> sys.stderr, e
        print 'connection unavailable to', server
        sys.exit(2)
    connection.login(username, password)
    return connection, message_functions, read_folder, unread_folder


def get_method_arguments(method, values):
    method_arguments = inspect.getargspec(method).args
    if 'text' in method_arguments:
        text = values['text']
        if text is None:
            values['text'], values['html'], values['attachments'] = peek_body(
                values['connection'], values['message_id'], values['header'])
    return [values[a] for a in method_arguments]


def show_unknown_message(message, text, html):
    print
    show_heading('Unknown message')
    print
    show_message_keys(message)
    show_html(html)
    show_some(text)


def show_message_keys(message):
    boring_keys = [
        'Received', 'Received-SPF', 'Authentication-Results',
        'DKIM-Signature', 'MIME-Version', 'Content-Type',
        'X-Originating-IP', 'X-MD-NoSA', 'X-Scanned-By',
        'Thread-Index', 'Thread-Topic', 'References',
        'X-Priority', 'X-Virus-Scanned', 'X-elqPod',
        'X-Mail-Handler', 'X-Mailer',
        'X-MimeOLE', 'X-Campaign', 'X-campaignid',
        'x-accounttype', 'x-mcda', 'X-SenderScore',
        'Content-Transfer-Encoding', 'X-OriginalArrivalTime',
        'Accept-Language', 'Content-Language'
    ]
    boring_start_keys = [
        'X-MS', 'X-Spam', 'X-CTASD', 'x-ctasd',
    ]
    for key in message.keys():
        if key in boring_keys:
            continue
        if any([key.startswith(s) for s in boring_start_keys]):
            continue
        print coloured_text(key, message[key])
    print


def is_signature(line):
    if line == '-- ':
        return True
    line = line.strip()
    if not line:
        return False
    one_liners = [
        'Regards,',
        '-----Original Message-----',
        '----- Original Message -----',
        '----- Forwarded Message -----',
    ]
    if line in one_liners:
        return True
    if line == '_' * len(line):
        return True
    name_regexp = re.compile('^(/)?(?P<name>[A-Z][a-z]+)( [A-Z][a-z]*)?$')
    match = name_regexp.match(line)
    if not match:
        return False
    names = ['Regards', 'Alan', 'Martin', 'Steven']
    return match.group('name') in names


def show_html(html):
    if html:
        message = '    See also %s' % private.url_in_localhost(mail_html())
        print colours.colour_text(message, 'cyan')
        print


def show_some(text):
    lines = text.splitlines()
    shown_lines = 0
    max_shown_lines = 24
    for line in lines:
        if is_signature(line) or shown_lines > max_shown_lines:
            print colours.colour_text('-- (strip signature)', 'gray')
            break
        if line.strip():
            print line
            shown_lines += 1
    print


def show_all(text):
    for line in text.splitlines():
        if is_signature(line):
            break
        print line
    print


def clear_screen():
    print '%s[2J' % chr(27)


def copy_to_folder(connection, ids, folder):
    ids_string = ','.join(ids)
    response, data = connection.copy(ids_string, folder)
    if response == 'NO':
        message = data[0]
        if 'TRYCREATE' in message:
            template = 'Cannot copy read messages, please create folder %r'
            raise ValueError(template % folder)


def archive_handled_messages(connection, read_folder, read_ids, unread_folder,
                             unread_ids):
    if not connection:
        return
    # pudb.set_trace()
    read_ids.update(read_message_ids_in(connection))
    if read_ids and read_folder:
        copy_to_folder(connection, read_ids, read_folder)
    if unread_ids and unread_folder:
        copy_to_folder(connection, unread_ids, unread_folder)
    ids_string = ','.join(read_ids | unread_ids)
    if ids_string:
        response, _data = connection.store(ids_string, r'+FLAGS', r'(\Deleted)')
        assert response == 'OK'
        response, _data = connection.expunge()
        assert response == 'OK'


def handle_messages(connection, message_functions, wanted_functions):
    # pylint: disable-msg=W0612,R0912
    read_ids, unread_ids = set(), set()
    for message_id in unread_message_ids_in(connection, 'INBOX'):
        header = peek_header(connection, message_id)
        text = None
        for message_function in message_functions:
            if wanted_functions:
                if message_function.func_name not in wanted_functions:
                    continue
            check, handle = message_function()
            values = get_method_arguments(check, locals())
            if check(*values):
                values = get_method_arguments(handle, locals())
                handled = handle(*values)
                # pudb.set_trace()
                if handled:
                    if 'read' == handled:
                        connection.store(message_id, r'+FLAGS', '\\Seen')
                    elif handled.startswith('Handled:'):
                        print handled
                    read_ids.add(message_id)
                else:
                    unread_ids.add(message_id)
                break
        else:
            if not wanted_functions:
                if not text:
                    text, html, _attachments = peek_body(
                        connection, message_id, header)
                show_unknown_message(header, text, html)
                if confirm_reading():
                    connection.store(message_id, '+FLAGS', r'\Seen')
                else:
                    unread_ids.add(message_id)

    return read_ids, unread_ids


def check_family():

    def check(header):
        return any([sent_by(header, family_email)
                    for family_email in private.family_emails()])

    def handle(header, text, html):
        show_heading(private.family_name())
        show_subject(header)
        show_from_name(header)
        show_html(html)
        show_some(text)
        return confirm_reading()

    return check, handle


def check_payment():

    def check(header):
        return sent_by(header, 'service@intl.paypal.com')

    def handle(header, html, text):
        show_heading('$$$$$$$$')
        show_subject(header)
        show_from_name(header)
        show_html(html)
        show_some(text)
        return confirm_reading()

    return check, handle


def interesting_lists():

    def check(header):
        return text_viewing_ok(header) or html_viewing_needed(header)

    def text_viewing_ok(message):
        text_senders = [
            'yegg@duckduckgo.com',
            'info@iccl.ie',
            'feedback@thisismyjam.com',
            'info@jobs.ie',
            'avaaz@avaaz.org',
            'gary@pathwaytohappiness.com',
            'getting-started-with-app-inventor@googlegroups.com',
            'notifications@github.com',
            'hearourvoices@iccl.ie',
            'pudb-request@tiker.net',
        ]
        if sent_by_addresses(message, text_senders):
            return True
        return sent_to_address(message, 'roundup-devel@lists.sourceforge.net')

    def html_viewing_needed(message):
        html_senders = [
            'admin@pycoders.com',
            'email@lifehacker.com',
            'newsletter@email.threadless.com',
            'info@bigthink.com',
        ]
        return sent_by_addresses(message, html_senders)

    def handle(header, text, html):
        show_heading('List')
        show_subject(header)
        show_from_address(header)
        show_to(header)
        show_date(header)
        show_html(html)
        if html_viewing_needed(header):
            print 'View the html'
        else:
            show_all(text)
        return confirm_reading()

    return check, handle


def products_check():

    def check(header):
        if sent_by(header, 'J Alan Brogan'):
            return has_subject(header, 'products')
        return False

    def handle(header, text):
        for line in text.splitlines():
            if line.strip() == '28':
                return 'read'
        show_subject(header)
        show_from_address(header)
        show_all(text)
        return confirm_reading()

    return check, handle


def i_have_logged_in():

    def check(header):
        return text_viewing_ok(header) or html_viewing_needed(header)

    def text_viewing_ok(header):
        text_senders = [
            'contact@humblebundle.com',
        ]
        return sent_by_addresses(header, text_senders)

    def html_viewing_needed(header):
        html_senders = [
            'help@workflowy.com',
        ]
        return sent_by_addresses(header, html_senders)

    def handle(header, text, html):
        show_heading('List')
        show_subject(header)
        show_from_address(header)
        show_to(header)
        show_date(header)
        show_html(html)
        if html_viewing_needed(header):
            print 'View the html'
        else:
            show_all(text)
        return confirm_reading()

    return check, handle


def strip_bottom_level(domain):
    return domain.rsplit('.', 1)[0]


def strip_top_level(domain):
    return domain.split('.', 1)[-1]


def good_personal_email(message):
    domain = first_sender_domain(message)
    domain_variations = [domain, strip_top_level(domain),
                         strip_bottom_level(domain)]
    if sent_to_receivers_at_personal_domain(message, domain_variations):
        return True
    domain_translations = {
        'gnu.org': ['nongnu.org'],
        'amazon.com': ['reddit'],
        'redditgifts.com': ['reddit'],
        'redditgifts.uservoice.com': ['reddit'],
        'kalyanacentre.com': ['kalyana'],
        'marksandspencer.ie': ['markandspencers'],
    }
    for translation in domain_translations.get(domain, []):
        if sent_to_address(message, private.personal_email(translation)):
            return True
    return False


def bad_domains():

    def check(header):
        show_heading('Bad Domain')
        return not good_personal_email(header)

    def handle(header, text, html):
        spammy_receivers = [
            'extremetech',
            'laurie.suppes',
            'eoconnell',
            'rick.mcrorie',
            'aaronbgtay',
        ]
        if sent_to_receivers_at_personal_domain(header, spammy_receivers):
            return 'read'
        show_from_address(header)
        show_to(header)
        response = ask_about_reading('m')
        if response != 'm':
            return response
        show_unknown_message(header, text, html)
        return confirm_reading()

    return check, handle


def from_bug_tracker(message):
    issue, _title = read_issue_subject(message)
    return bool(issue)


def bug_reports():

    def check(header):
        return good_personal_email(header)

    def handle(header, text):
        show_heading('Bug Report')
        show_subject(header)
        show_from_name(header)
        show_some(text)
        return confirm_reading()

    return check, handle


def from_boring_list(message):
    if not good_personal_email(message):
        return False
    list_of_boring_lists = [
        'theboxteam@box.com',
        'support@moodscope.com',
        re.compile('.*@postmaster.twitter.com'),
        'WhatsNewNow@eletters.whatsnewnow.com',
    ]
    return sent_by_addresses(message, list_of_boring_lists)


def from_seller_of_stuff(message):
    if not good_personal_email(message):
        return False
    sellers_of_stuff = [
        'cdraper@eil.com',
        'store-news@amazon.com',
    ]
    return sent_by_addresses(message, sellers_of_stuff)


def ignore_these(choose_ignorables):

    def check(header):
        return choose_ignorables(header)

    def handle():
        return 'read'

    return check, handle


def boring_lists():
    return ignore_these(from_boring_list)


def buy_stuff():
    return ignore_these(from_seller_of_stuff)


def employee_account():
    return (
        private.employee_account,
        [
            check_family,
            has_out_of_office,
            about_mail_delivery,
            sent_to_meeting_rooms,
            regular_reports,
            spam_messages,
            interesting_lists,
            products_check,
        ],
        time.strftime('%m - %B'),
        '00 - Unread')


def main_personal_account():
    return (
        private.main_personal_account,
        [
            check_family,
            check_payment,
        ],
        '', '')


def other_personal_account():
    return (
        private.other_personal_account,
        [
            check_family,
            bug_reports,
            interesting_lists,
            i_have_logged_in,
            boring_lists,
            buy_stuff,
            bad_domains,
        ],
        '', '')


def second_employee_account():
    return (
        private.second_employee_account,
        [
            interesting_lists,
            boring_lists,
        ],
        '', '')


def read_account(account_method, args):
    connection = None
    try:
        connection, message_functions, read_folder, unread_folder = connect(
            account_method)
        read_ids, unread_ids = handle_messages(
            connection, message_functions, args)
        archive_handled_messages(
            connection, read_folder, read_ids, unread_folder, unread_ids)
    finally:
        if connection:
            connection.close()
            connection.logout()
    return 0


def show_account_header(account_name):
    clear_screen()
    print '*' * 80
    print colours.colour_text('Account:', 'red'), account_name
    print


def main(args):
    # pudb.set_trace()
    account_methods = [employee_account, main_personal_account,
                       other_personal_account, second_employee_account]
    for account_method in account_methods:
        if args:
            if 'all' in args or account_method.func_name in args:
                show_account_header(account_method.func_name)
                read_account(account_method, [])
            if account_method.func_name in args:
                return 0
        if not args:
            show_account_header(account_method.func_name)
            print colours.colour_text('Read?', 'red')
            if not get_yes():
                continue
            read_account(account_method, args)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
