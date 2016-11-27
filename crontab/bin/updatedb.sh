#! /bin/bash

export PRUNEPATHS=\
    "/Library/Ruby/Gems/1.8/gems/xapian-full-1.1.3.4/xapian-bindings-1.1.3/ruby/docs/rdocs/files/data/home/olly/tmp" \
    "/Users/jab/.rvm/tmp" \
    "/Users/jab/Library/Caches/Java/cache/6.0/tmp" \
    "/Users/jab/Library/Caches/Java/tmp" \
    "/Users/jab/Library/Caches/PyCharm20/tmp" \
    "/Users/jab/Sites/jlf/mail/jlf.ie/jlf/tmp" \
    "/Users/jab/Sites/jlf/mail/tmp" \
    "/Users/jab/Sites/jlf/tmp" \
    "/Users/jab/jab/tmp" \
    "/Users/jab/tmp" \
    "/Volumes/MobileBackups" \
    "/mnt " \
    "/private/tmp" \
    "/private/var/amavis/tmp" \
    "/private/var/at/tmp" \
    "/private/var/spool/cups/tmp" \
    "/private/var/tmp" \
    "/tmp" \
    "/usr/share/devicemgr/backend/tmp" \

date > /Volumes/HD/Users/jab/log/updatedb.log
echo "/usr/bin/sudo /bin/bash /usr/local/Cellar/findutils/4.4.2/bin/updatedb" >> /Volumes/HD/Users/jab/log/updatedb.log
/usr/bin/sudo \
    /bin/bash \
        /usr/local/Cellar/findutils/4.4.2/bin/updatedb \
        --prunepaths=$PRUNEPATHS \
        >> /Volumes/HD/Users/jab/log/updatedb.log 2>&1
