#! /bin/bash

# Make gvim the default editor for text files in gnome

sudo /bin/sed -i -e s/gedit/gvim/ /etc/gnome/defaults.list
/bin/cat > ~/.local/share/applications/defaults.list << EOF
[Default Applications]
text/plain=gvim.desktop

EOF
if [[ -f ~/.local/share/applications/mimeapps.list ]]
then cat ~/.local/share/applications/defaults.list >> ~/.local/share/applications/mimeapps.list
fi
