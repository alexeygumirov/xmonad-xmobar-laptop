# Xmonad startup

wetter_update(){
    echo "" > /tmp/wetter
    sleep 120
    /home/alexgum/.scripts/wetter-xmobar.py > /tmp/wetter
}

[ -x /usr/bin/trayer ] && (trayer --edge top --distance 0 --distancefrom right --align right --widthtype request --padding 2 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --transparent true --alpha 0 --tint 0x1D3030 --height 22 2> /dev/null &)
(wetter_update &)
/home/alexgum/.scripts/output-device-switch.py -detect &
