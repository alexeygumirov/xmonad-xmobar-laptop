# Xmonad startup

[ -x /usr/bin/trayer ] && (trayer --edge top --distance 0 --distancefrom right --align right --widthtype request --padding 2 --SetDockType true --SetPartialStrut true --expand true --monitor primary --transparent true --alpha 0 --tint 0x0031353D --height 22 2> /dev/null &)
sleep 2
$HOME/.scripts/python/output-device-switch.py -init &
$HOME/.scripts/python/input-device-switch.py -init &
