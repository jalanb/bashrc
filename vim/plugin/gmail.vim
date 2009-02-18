" Make sure the Vim was compiled with +python before loading the script...
if !has("python")
        finish
endif

:command! -nargs=? GMSend :call GMailSend("<args>")

function! GMailSend(args)
python << EOF
import vim
to = vim.eval('a:args')
GSend(to)
EOF
endfunction

python << EOF
########### BEGIN USER CONFIG ##########
account = 'algotrhythm'
password = 'bcx4bzrt'
########### END USER CONFIG ###########


def GSend(to):
    """
    Send the current buffer as a Gmail message to a given user.
    """
    import libgmail

    subject = vim.current.buffer[0]
    print 'subject is', subject
    body = '\n'.join(vim.current.buffer[1:])

    ga = libgmail.GmailAccount(account, password)
    try:
        ga.login()
    except libgmail.GmailLoginFailure:
        print "Login failed. (Wrong username/password?)"

    gmsg = libgmail.GmailComposedMessage(to, subject, body)

    if ga.sendMessage(gmsg):
        print "Message sent `%s` successfully." % subject
    else:
        print "Could not send message."

EOF

