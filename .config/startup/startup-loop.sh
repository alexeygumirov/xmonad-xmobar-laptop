#!/bin/sh
# small script to recover crashed bluetooth applet or picom composer
# It does not happen often, but I made script which just does all automatically

loopblue() {
    # restarts blueman tray and applet if they crash
    killall blueman-tray
    killall blueman-applet
    (blueman-applet >/dev/null 2>&1 &)
    local LOG_FILE_NAME=/tmp/blueman_applet_log
    printf "" > "${LOG_FILE_NAME}"
    while true
    do
        if [ -z "$(pgrep -f blueman-tray)" ]
        then
            (blueman-applet >/dev/null 2>&1 &)
            printf "Crashed. Restarted. - $(date)\n" >> "${LOG_FILE_NAME}"
        fi
        sleep 1m
    done
}

loopcomposer(){
    # Restarts picom if it crashes
    killall picom
    (picom -f --experimental-backend 2> /dev/null &)
    local COMP_LOG_FILE_NAME=/tmp/composer_log
    printf "" > "${COMP_LOG_FILE_NAME}"
    while true
    do
        if [ -z "$(pgrep -f 'picom -f --experimental-backend')" ]
        then
            (picom -f --experimental-backend 2>/dev/null &)
            printf "Crashed. Restarted. - $(date)\n" >> "${COMP_LOG_FILE_NAME}"
        fi
        sleep 1m
    done
}

loopvolumeicon(){
    # Restarts volume icon if it crashes
    killall volumeicon
    (volumeicon 2> /dev/null &)
    local VOLICON_LOG_FILE_NAME=/tmp/volumeicon_log
    printf "" > "${VOLICON_LOG_FILE_NAME}"
    while true
    do
        if [ -z "$(pgrep -f 'volumeicon')" ]
        then
            (volumeicon 2> /dev/null &)
            printf "Crashed. Restarted. - $(date)\n" >> "${VOLICON_LOG_FILE_NAME}"
        fi
        sleep 5m
    done
}

loopdate(){
    export LC_TIME=en_US.UTF-8
    while true
    do
        printf "$(date "+%H:%M")" > /tmp/xmobar-date
        sleep 20s
    done
}

loopimwheel(){
    # this function detects when imwheel consumes too much CPU, then kills and launches imwheel again
    while true
    do
        imwheel_pid=$(pgrep -fa imwheel | cut -d' ' -f1)
        imwheel_cpu=$(top -b -n 1 -o %CPU -p $imwheel_pid | awk '{a=$9} END {printf("%0.f\n",a)}')
        [ $imwheel_cpu -gt 10 ] && killall imwheel && (imwheel &)
        sleep 30s
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
        loopvolumeicon &
        loopdate &
        loopimwheel &
        ;;
esac
