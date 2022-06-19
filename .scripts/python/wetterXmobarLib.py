import datetime
import wetterXmobarData as wXD


# Function to convert %I:%M AM/PM format of time into 24 hours
def convert24(str1: str) -> str:  # input format must be %I:%M AM/PM (no sec)
    """Function converting AM/PM time format into the 24 hours format."""
    # Checking if last two elements of time
    # is AM and first two elements are 12
    if str1[-2:] == "AM" and str1[:2] == "12":
        return "00" + str1[2:-3]
    # remove the AM
    elif str1[-2:] == "AM":
        return str1[:-3]
    # Checking if last two elements of time
    # is PM and first two elements are 12
    elif str1[-2:] == "PM" and str1[:2] == "12":
        return str1[:-2]
    else:
        # add 12 to hours and remove PM
        return str(int(str1[:2]) + 12) + str1[2:5]


# Function to determine if it is day or night
# using current time and information about sunrise and sunset
def day_or_night(weather_map: dict) -> str:
    """Function detect day or night using sunset and sunrise data."""

    current_time_int = int(datetime.datetime.now().strftime("%H%M"))

    sunrise_int = int(weather_map['sunrise'][:2] + weather_map['sunrise'][3:5])

    sunset_int = int(weather_map['sunset'][:2] + weather_map['sunset'][3:5])

    if current_time_int < sunrise_int:
        return 'night'
    elif current_time_int < sunset_int:
        return 'day'
    else:
        return 'night'

# Function returns wind color depending on Wind speed (km/h)


def give_wind_color(wind_colors_map: dict, wind_speed: int) -> str:
    """Apply color to the wind speed based on the given color map."""

    for key in wind_colors_map.keys():
        if wind_speed <= key:
            return wind_colors_map.get(key, "#FF1493")


# Function returns wind gust value for a given time
# Returs in the km/h (to be used with a give_wind_color function)
def give_wind_gust(full_weather_map: dict) -> str:
    """Extract speed of wind gust from the forecast."""

    hourly_index = int(datetime.datetime.now().strftime("%H%M")) // 300

    try:
        return full_weather_map['weather'][0]['hourly'][hourly_index]['WindGustKmph']
    except:
        return "0"


# Function to return night or day icon for a given weather code
# As input function takes map which must contain values for:
# 'sunrise', 'sunset' and 'weatherCode'
def return_icon(weather_map: dict) -> str:
    """Function to select icon for a given weather code."""

    days_time = day_or_night(weather_map)

    if days_time == 'night':
        return wXD.weather_icons_night.get(weather_map['weatherCode'], ' ')
    elif days_time == 'day':
        return wXD.weather_icons_day.get(weather_map['weatherCode'], ' ')
    else:
        return wXD.weather_icons_day.get(weather_map['weatherCode'], ' ')


# function to wrap into the standard xmobar front color notation
def wrap_xmobar_color(color: str = 'white', data: str = '') -> str:
    """Wrapper of string into Xmobar color tags: <fc='color'>string</fc>."""
    return '<fc=' + color + '>' + data + '</fc>'


# function to assemble weather reporting string for xmobar
def make_xmobar_weather_string(weather_map: dict,
                               color_map: dict = wXD.weather_colors,
                               wind_color_map: dict = wXD.wind_colors) -> str:
    """Function to make final weather report string for Xmobar."""

    days_time = day_or_night(weather_map)
    report_string = ''

    try:
        if days_time == 'day':
            report_string += wrap_xmobar_color(
                color_map['weather_day'],
                return_icon(weather_map)) + ' '

        elif days_time == 'night':
            report_string += wrap_xmobar_color(
                color_map['weather_night'],
                return_icon(weather_map)) + ' '

        else:
            report_string += wrap_xmobar_color(
                color_map['unknown'],
                return_icon(weather_map)) + ' '

        report_string += wrap_xmobar_color(
            color_map['realTemp'],
            weather_map['temp_C']) + '('

        report_string += wrap_xmobar_color(
            color_map['feelsLikeTemp'],
            weather_map['FeelsLikeC']) + ')°C '

        report_string += wrap_xmobar_color(
            color_map['windDirection'],
            wXD.wind_directions.get(weather_map["winddir16Point"], '')) + ':'

        if int(weather_map['windspeedMs']) < int(weather_map['windgustMs']):
            report_string += wrap_xmobar_color(
                give_wind_color(wind_color_map, int(weather_map['windspeedKmph'])),
                weather_map['windspeedMs']) + '-'

            report_string += wrap_xmobar_color(
                give_wind_color(
                    wind_color_map,
                    int(weather_map['windgustKmph'])
                ),
                weather_map['windgustMs']) + 'm/s '

        else:
            report_string += wrap_xmobar_color(
                give_wind_color(wind_color_map, int(weather_map['windspeedKmph'])),
                weather_map['windspeedMs']) + 'm/s '

        report_string += wrap_xmobar_color(
            color_map['humidity'],
            '' + weather_map['humidity'] + '')

        return report_string

    except:
        return wrap_xmobar_color(color_map['error'], 'N/A, Report Func Error')
