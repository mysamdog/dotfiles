#!/bin/bash
export TERMINAL=termite
export DE=openbox
xrdb -merge ~/.Xresources
# Dbus fix
#if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
#    eval "$(dbus-launch --sh-syntax --exit-with-session)"
#fi

/usr/bin/xdg-user-dirs-update

herbstluftwm
# Openrc start openbox session
#exec ck-launch-session dbus-launch --sh-syntax --exit-with-session openbox-session
exec compton -b


