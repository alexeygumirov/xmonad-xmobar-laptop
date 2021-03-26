# Common startup functions and variables

export QT_SCREEN_SCALE_FACTORS=1
export QT_SCALE_FACTOR=1
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK_THEME="Matcha-azul"

setxkbmap us,ru,de -option -option 'grp:rshift_toggle,caps:ctrl_modifier'
xinput disable "SynPS/2 Synaptics TouchPad"
xsetroot -cursor_name left_ptr # setup cursor before xmonad and xmobar are launched. Otherwise cursor theme is not working on xmobar and trayer.
[ -f ~/.Xresources ] && xrdb ~/.Xresources

# maintenance of the ssh-agent
ssh-add -l &>/dev/null
if [ "$?" = "2" ]; then
  test -r ~/.ssh-agent && eval "$(<~/.ssh-agent)" >/dev/null
  ssh-add -l &>/dev/null
  if [ "$?" = "2" ]; then
    (umask 066; ssh-agent > ~/.ssh-agent)
    eval "$(<~/.ssh-agent)" >/dev/null
    ssh-add
  fi
fi

/home/alexgum/.scripts/displaymode &
[ -x /usr/bin/nitrogen ] && (nitrogen --restore &)
[ -x /usr/lib/xfce4/notifyd/xfce4-notifyd ] && ([ -z "$(pgrep notifyd)" ] && /usr/lib/xfce4/notifyd/xfce4-notifyd >/dev/null 2>&1 &)
[ -x /usr/bin/nm-applet ] && (nm-applet 2> /dev/null &)
[ -x /usr/bin/volumeicon ] && (volumeicon 2> /dev/null &)
[ -x /usr/bin/xfce4-clipman ] && (xfce4-clipman 2> /dev/null &)
/home/alexgum/.scripts/myidleswitch -off
[ -x /usr/bin/rclone ] && (/home/alexgum/.scripts/rclone-cron &)
/home/alexgum/.scripts/rshift-start -launch
(/home/alexgum/.scripts/wgstatus &)
[ -x /usr/bin/imwheel ] && imwheel
/home/alexgum/.scripts/mycheckupdates &
(udiskie -ANs &)

(/home/alexgum/.config/startup/startup-loop.sh -start &)
