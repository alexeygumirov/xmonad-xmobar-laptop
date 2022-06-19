#!/bin/python3
# my script for getting weather stats with the Nerd Font icons
# Data is pulled from the wttr.in in the JSON format

# import sys
import requests
import json
import wetterXmobarLib as wXL
import time
import sys


if len((sys.argv)) > 1:
    mode = str(sys.argv[1][1:])
else:
    print('Usage:')
    print('wetter-xmobar.py', '-<option>:')
    print('  -init: initialize /tmp/wetter')
    print('  -status: print status')
    sys.exit()


def init_file(file_path: str = '/tmp/wetter') -> None:

    with open(file_path, 'w') as f:
        f.write(' ')


# main function to put everything together
def weatherReport(file_path: str = '/tmp/wetter') -> None:
    """Main function."""
    weather_URL = 'http://wttr.in/'
    city = 'New-York'
    weather_report = ""
    # Here I define arrays with the data I collect
    current_weather_temperature = ['temp_C',
                                   'FeelsLikeC']
    current_weather_conditions = ['windspeedKmph',
                                  'humidity',
                                  'weatherCode',
                                  'winddir16Point']
    current_weather_map = {}
    # in the case of errors (either connectivity or JSON parsing)
    # I just put "N/A" message in a yellow color
    try:
        response = requests.get(weather_URL + city + '?format=j1').json()

        for temperature in current_weather_temperature:
            if '-' in response['current_condition'][0][temperature]:
                current_weather_map[temperature] = response['current_condition'][0][temperature]
            else:
                current_weather_map[temperature] = '+' + response['current_condition'][0][temperature]

        for condition in current_weather_conditions:
            current_weather_map[condition] = response['current_condition'][0][condition]

        current_weather_map['sunrise'] = wXL.convert24(response['weather'][0]['astronomy'][0]['sunrise'])

        current_weather_map['sunset'] = wXL.convert24(response['weather'][0]['astronomy'][0]['sunset'])

        current_weather_map['windgustKmph'] = wXL.give_wind_gust(response)

        current_weather_map['windspeedMs'] = str(int(current_weather_map['windspeedKmph']) * 10 // 36)

        current_weather_map['windgustMs'] = str(int(current_weather_map['windgustKmph']) * 10 // 36)
        weather_report = wXL.make_xmobar_weather_string(current_weather_map)
        # weather_report = wX.make_xmobar_weather_string(current_weather_map,
        # weather_colors, wind_colors)

    except requests.RequestException:
        weather_report = 'wttr.in unreach'

    except json.decoder.JSONDecodeError:
        weather_report = 'wttr.in down'

    with open(file_path, 'w') as f:
        f.write(' :[' + weather_report + ']')
    time.sleep(5)
    init_file(file_path)


def main(mode_param: str) -> None:

    weather_file_path = '/tmp/wetter'
    if mode_param == 'init':
        init_file(weather_file_path)
    elif mode_param == 'status':
        weatherReport(weather_file_path)


if __name__ == '__main__':
    main(mode)
