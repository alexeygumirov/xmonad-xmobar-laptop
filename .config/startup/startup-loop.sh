#!/bin/sh
# small script to recover crashed bluetooth applet or picom composer
# It does not happen often, but I made script which just does all automatically

loopblue() {
    killall blueman-tray
    killall blueman-applet
    (blueman-applet >/dev/null 2>&1 &)
    local LOG_FILE_NAME=/tmp/blueman_applet_log
    echo -n "" > "${LOG_FILE_NAME}"
    while true
    do
        if [ -z "$(pgrep -f blueman-tray)" ]
        then
            (blueman-applet >/dev/null 2>&1 &)
            echo "Crashed. Restarted. - $(date)" >> "${LOG_FILE_NAME}"
        fi
        sleep 1m
    done
}

loopcomposer(){
    killall picom
    (picom -f --experimental-backend 2> /dev/null &)
    local COMP_LOG_FILE_NAME=/tmp/composer_log
    echo -n "" > "${COMP_LOG_FILE_NAME}"
    while true
    do
        if [ -z "$(pgrep -f 'picom -f --experimental-backend')" ]
        then
            (picom -f --experimental-backend 2>/dev/null &)
            echo "Crashed. Restarted. - $(date)" >> "${COMP_LOG_FILE_NAME}"
        fi
        sleep 1m
    done
}

case "$1" in
    "-start")
        ISAUTORUNNING=$(pgrep -f "$0 -loop")
        if [ ! -z "${ISAUTORUNNING}" ]; then
            for i in "${ISAUTORUNNING}"
            do
               kill $i
            done
        fi
        $0 -loop &
        ;;
    "-loop")
        loopblue &
        loopcomposer &
        ;;
esac
