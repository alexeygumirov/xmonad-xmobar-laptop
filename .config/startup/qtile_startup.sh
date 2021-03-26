# Qtile startup

[ -x /usr/bin/picom ] && (picom -f --experimental-backends 2> /dev/null &)
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

