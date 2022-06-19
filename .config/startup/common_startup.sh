# Common startup functions and variables

export QT_SCREEN_SCALE_FACTORS=1
export QT_SCALE_FACTOR=1
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK_THEME="Matcha-azul"
export XDG_CURRENT_DESKTOP="XFCE"

setxkbmap us,ru -option -option 'grp:rshift_toggle,caps:ctrl_modifier'
xinput disable "SynPS/2 Synaptics TouchPad"
xsetroot -cursor_name left_ptr # setup cursor before xmonad and xmobar are launched. Otherwise cursor theme is not working on xmobar and trayer.
[ -f $HOME/.Xresources ] && xrdb $HOME/.Xresources

$HOME/.scripts/displaymode &
[ -x /usr/bin/dunst ] && (dunst >/dev/null 2>&1 &)
[ -x /usr/bin/nm-applet ] && (nm-applet 2> /dev/null &)
[ -x /usr/bin/volumeicon ] && (volumeicon 2> /dev/null &)
[ -x /usr/bin/xfce4-clipman ] && (xfce4-clipman 2> /dev/null &)
$HOME/.scripts/myidleswitch -off
$HOME/.scripts/rshift-start -launch &
($HOME/.scripts/wgstatus &)
[ -x /usr/bin/imwheel ] && imwheel
$HOME/.scripts/mycheckupdates &
(udiskie -ACNs &)

($HOME/.config/startup/startup-loop.sh -start &)
