#! /bin/bash

# Make gvim the default editor for text files in gnome

DEFAULTS=/etc/gnome/defaults.list
[[ -f $DEFAULTS ]] || DEFAULTS=/usr/share/applications/defaults.list
if [[ -f $DEFAULTS ]]; then
	sudo /bin/sed -i -e s/gedit/gvim/ $DEFAULTS
/bin/cat > ~/.local/share/applications/defaults.list << EOF
[Default Applications]
text/plain=gvim.desktop
EOF
else
	echo "Could not find Gnome defaults file" >&2
fi

if [[ -f ~/.local/share/applications/mimeapps.list ]]; then
    cat ~/.local/share/applications/defaults.list >> ~/.local/share/applications/mimeapps.list
fi
