#!/bin/python3

import subprocess
import sys
from itertools import cycle

sys_default_source = 'alsa_input.pci-0000_05_00.6.analog-stereo'

# Remove the first argument( the filename)
if len((sys.argv)) > 1:
    mode = str(sys.argv[1][1:])
else:
    print('Usage:')
    print('input-device-switch.py', '-<option>:')
    print('  -detect: Detect active source of PCI')
    print('  -toggle: Toggle active source of PCI')
    print('  -status: Status of the current microphone')
    print('  -init: Sets default microphone and mutes it')
    sys.exit()


def set_default_source(default_source: str = sys_default_source) -> None:

    # default_source = 'alsa_output.pci-0000_05_00.6.analog-stereo.monitor'
    subprocess.call("pactl set-default-source " + default_source, shell=True, stdout=subprocess.DEVNULL)


def mute_source() -> None:

    # default_source = 'alsa_output.pci-0000_05_00.6.analog-stereo.monitor'
    subprocess.call("amixer set Capture nocap", shell=True, stdout=subprocess.DEVNULL)


# Getting list of pulse audio sources (short format)
def get_sources(default_source: str = sys_default_source) -> list:
    """Function which returns list of active sources in the pulseaudio."""
    sources_get_local = []
    all_sources = []
    for source in str(subprocess.check_output(["pactl", "list", "sources", "short"]).decode('utf-8')).splitlines():
        all_sources.append(source.split('\t')[1])
    for source in list(dict.fromkeys(all_sources)):
        if 'alsa_input' in source:
            if 'Jabra' in source:
                sources_get_local.append(source)
            if 'NexiGo' in source:
                sources_get_local.append(source)
            if 'Logitech_USB' in source:
                sources_get_local.append(source)
            if default_source in source:
                sources_get_local.append(source)
        elif 'bluez_input' in source:
            sources_get_local.append(source)
    return sources_get_local


def detect_source(status_file: str = '/tmp/sound_input_status', default_source: str = sys_default_source) -> str:
    """Function which writes data about current active source into the /tmp/sound_input_status file."""

    default_input = ''
    cmd = ['pactl', 'info']
    for field in str(subprocess.check_output(cmd).decode('utf-8')).splitlines():
        if 'Default Source:' in field:
            default_input = field.split()[-1]

    input_muted = False
    cmd = ['amixer', 'get', 'Capture']
    if '[off]' in str(subprocess.check_output(cmd).decode('utf-8')).splitlines()[-1]:
        input_muted = True

    status_line = ''
    if default_source in default_input:
        if input_muted:
            status_line = ' '
        else:
            status_line = ' '
        # with open(status_file,'w') as status:
        #     if input_muted:
        #         status.write(' \n')
        #     else:
        #         status.write(' \n')
        #     status.write('default-input')
    elif 'bluez_input' in default_input:
        if input_muted:
            status_line = '| '
        else:
            status_line = ' '
        # with open(status_file,'w') as status:
        #     if input_muted:
        #         status.write('  \n')
        #     else:
        #         status.write('  \n')
        #     status.write('bluetooth')
    elif 'Jabra' in default_input:
        if input_muted:
            status_line = '|J'
        else:
            status_line = 'J'
        # with open(status_file,'w') as status:
        #     if input_muted:
        #         status.write('  \n')
        #     else:
        #         status.write('  \n')
        #     status.write('jabra')
    elif 'NexiGo' in default_input:
        if input_muted:
            status_line = '|C'
        else:
            status_line = 'C'
    else:
        set_default_source()

    return default_input, status_line


def toggle_source(sources_local: list) -> None:
    """Toggle active pulseaudio source."""
    sources_cycle = cycle(sources_local)
    active_source, status_line = detect_source()
    while True:
        if active_source == next(sources_cycle):
            subprocess.call("pactl set-default-source " + str(next(sources_cycle)), shell=True)
            detect_source()
            break


def get_status(status_file: str = '/tmp/sound_input_status') -> str:

    try:
        with open(status_file, 'r') as status:
            return status.readline()
    except Exception:
        return ""


def main(main_mode: str) -> None:
    """Main function."""
    if main_mode == 'detect':
        sources_map = get_sources()
        detect_source()
    elif main_mode == 'toggle':
        sources_map = get_sources()
        toggle_source(sources_map)
    elif main_mode == 'status':
        input, status = detect_source()
        print(status)
    elif main_mode == 'init':
        set_default_source()
        mute_source()


if __name__ == '__main__':
    main(mode)
