#!/bin/python3

import subprocess
import sys
from itertools import cycle

# Remove the first argument( the filename)
if len((sys.argv)) > 1:
    mode = str(sys.argv[1][1:])
else:
    print('Usage:')
    print('output-device-switch.py', '-<option>:')
    print('  -detect: Detect active sink of PCI')
    print('  -toggle: Toggle active sink of PCI')
    print('  -status: print out current status')
    print('  -init: Set default speaker and mute it')
    sys.exit()

sys_default_sink = 'alsa_output.pci-0000_05_00.6.analog-stereo'


def set_default_sink(default_sink: str = sys_default_sink) -> None:
    """
    Function sets default sink
    """
    subprocess.call("pactl set-default-sink " + default_sink, shell=True, stdout=subprocess.DEVNULL)


def mute_sink() -> None:
    """
    Function sets default sink
    """
    subprocess.call("amixer set Master mute", shell=True, stdout=subprocess.DEVNULL)


# Getting list of pulse audio sinks (short format)
def get_sinks(default_sink: str = sys_default_sink) -> list:
    """Function which returns list of active sinks in the pulseaudio."""
    sinks_get_local = []
    all_sinks = []
    for sink in str(subprocess.check_output(["pactl", "list", "sinks", "short"]).decode('utf-8')).splitlines():
        all_sinks.append(sink.split('\t')[1])
    for sink in list(dict.fromkeys(all_sinks)):
        if 'alsa_output' in sink:
            if default_sink in sink:
                sinks_get_local.append(sink)
            if 'Jabra' in sink:
                sinks_get_local.append(sink)
            if 'Logitech_USB' in sink:
                sinks_get_local.append(sink)
        elif 'bluez_output' in sink:
            sinks_get_local.append(sink)

    return sinks_get_local


def get_default_sink_volume() -> str:
    """Function which returns default pulseaudio sink volume."""
    sink_volume_string = ""
    sink_volume = 0
    try:
        for sink in str(subprocess.check_output(["pactl", "get-sink-volume", str(get_default_sink_id())]).decode('utf-8')).splitlines():
            if "Volume" in sink:
                sink_volume = int(sink.split('/')[1].strip(' %'))
        steps = 16
        volume_step = round(sink_volume * steps / 100)
        if volume_step < 10:
            sink_volume_string = '<icon=volume-level0' + str(volume_step) + '.xpm/>'
        else:
            sink_volume_string = '<icon=volume-level' + str(volume_step) + '.xpm/>'
    except Exception:
        sink_volume_string = "err"

    return sink_volume_string


def get_default_sink_id() -> str:

    default_output = ''
    cmd = ['pactl', 'info']
    for field in str(subprocess.check_output(cmd).decode('utf-8')).splitlines():
        if 'Default Sink:' in field:
            default_output = field.split()[-1]
    cmd = ['pactl', 'list', 'sinks', 'short']
    for field in str(subprocess.check_output(cmd).decode('utf-8')).splitlines():
        if default_output in field:
            default_sink_id = field.split()[0]

    return default_sink_id


def detect_sink(status_file: str = '/tmp/sound_output_status', default_sink: str = sys_default_sink) -> str:
    """Function which writes data about current active sink into the /tmp/sound_output_status file."""

    mute_status: bool = False
    cmd = ['amixer', 'get', 'Master']
    if 'off' in str(subprocess.check_output(cmd).decode('utf-8')).splitlines()[-1]:
        mute_status = True

    default_output = ''
    cmd = ['pactl', 'info']
    for field in str(subprocess.check_output(cmd).decode('utf-8')).splitlines():
        if 'Default Sink:' in field:
            default_output = field.split()[-1]

    status_line: str = ''
    if default_sink in default_output:
        if mute_status:
            status_line = '遼'
        else:
            status_line = get_default_sink_volume() + '蓼'
        # with open(status_file,'w') as status:
        #     status.write(status_line)
        #     status.write('default-speakers')
    if 'bluez_output' in default_output:
        if mute_status:
            status_line = ' '
        else:
            status_line = get_default_sink_volume() + ' '
        # with open(status_file,'w') as status:
        #     status.write(status_line)
        #     status.write('bluetooth')
    if 'Jabra' in default_output:
        if mute_status:
            status_line = '|J'
        else:
            status_line = get_default_sink_volume() + 'J'
        # with open(status_file,'w') as status:
        #     status.write(status_line)
        #     status.write('jabra')
    if 'Logitech_USB' in default_output:
        if mute_status:
            status_line = '|L'
        else:
            status_line = get_default_sink_volume() + 'L'
        # with open(status_file,'w') as status:
        #     status.write(status_line)
        #     status.write('jabra')

    return default_output, status_line


def toggle_sink(sinks_local: list) -> None:
    """Toggle active pulseaudio sink."""
    sinks_cycle = cycle(sinks_local)
    active_sink, status = detect_sink()
    while True:
        if active_sink == next(sinks_cycle):
            subprocess.call("pactl set-default-sink " + str(next(sinks_cycle)), shell=True)
            detect_sink()
            break


def get_status(status_file: str = '/tmp/sound_output_status') -> str:

    try:
        with open(status_file, 'r') as status:
            return status.readline()
    except Exception:
        return ""


def main(main_mode: str) -> None:
    """Main function."""
    if main_mode == 'detect':
        sinks_map = get_sinks()
        detect_sink()
    elif main_mode == 'toggle':
        sinks_map = get_sinks()
        toggle_sink(sinks_map)
    elif main_mode == 'status':
        output, status = detect_sink()
        print(status)
    elif main_mode == 'init':
        set_default_sink()
        mute_sink()


if __name__ == '__main__':
    main(mode)
