# color map
# color can be defined as a word or HEX code #RGB
weather_colors = {
    "weather_day": "#FFFF00",
    "weather_night": "#1E90FF",
    "unknown": "#D9D9D9",
    "realTemp": "green",
    "feelsLikeTemp": "green",
    "windDirection": "#D9D9D9",
    "windSpeed": "#FF1493",
    "humidity": "cyan",
    "error": "yellow",
}

wind_colors = {
    1: "#009FFF",
    5: "#67CEF7",
    11: "#7BCDBF",
    19: "#04E100",
    28: "#66FE3A",
    38: "#CAFF33",
    49: "#E2FE97",
    61: "#FEFE0A",
    74: "#F9DD56",
    88: "#FFC100",
    102: "#FF9962",
    117: "#FF6300",
    1000: "#CF3104"
}

# mapping standard wind rose into arrows
wind_directions = {
    "S": "",
    "N": "",
    "E": "",
    "W": "",
    "NNW": "",
    "NW": "",
    "WNW": "",
    "WSW": "",
    "SW": "",
    "SSW": "",
    "SSE": "",
    "SE": "",
    "ESE": "",
    "NNE": "",
    "NE": "",
    "ENE": ""
}

# mapping of weather codes into day icons
# I use icons from the NerdFont
weather_icons_night = {
    # Sunny
    "113": " ",
    # Partly Cloudy
    "116": " ",
    # Cloudy
    "119": "摒 ",
    # Very Cloudy
    "122": " ",
    # Fog
    "143": " ",
    "248": " ",
    "260": " ",
    # Light Showers
    "176": " ",
    "263": " ",
    # Light Sleet Showers
    "179": " ",
    "362": " ",
    "365": " ",
    "374": " ",
    # Light Sleet
    "182": " ",
    "185": " ",
    "281": " ",
    "284": " ",
    "311": " ",
    "314": " ",
    "317": " ",
    "350": " ",
    "377": " ",
    # Thundery Showers
    "200": " ",
    # Light Snow
    "227": " ",
    "320": " ",
    # Heavy Snow
    "230": " ",
    # Light rain
    "266": " ",
    "293": " ",
    "296": " ",
    # Heavy Showers
    "299": " ",
    "305": " ",
    "356": " ",
    # Heavy Rain
    "302": " ",
    "308": " ",
    "359": " ",
    # Light Snow Showers
    "323": "ﭽ ",
    "326": "ﭽ ",
    "368": "ﭽ ",
    # Heavy Snow Showers
    "335": "ﭽ ",
    "395": "ﭽ ",
    "371": "ﭽ ",
    # Heavy Snow
    "329": "流 ",
    "332": "流 ",
    "338": "流 ",
    # Light showers
    "353": " ",
    # Thundery Showers
    "386": " ",
    "389": " ",
    # Thundery Snow Showers
    "392": " "
}

weather_icons_day = {
    # Sunny
    "113": " ",
    # Partly Cloudy
    "116": "杖 ",
    # Cloudy
    "119": "摒 ",
    # Very Cloudy
    "122": " ",
    # Fog
    "143": " ",
    "248": " ",
    "260": " ",
    # Light Showers
    "176": " ",
    "263": " ",
    # Light Sleet Showers
    "179": " ",
    "362": " ",
    "365": " ",
    "374": " ",
    # Light Sleet
    "182": " ",
    "185": " ",
    "281": " ",
    "284": " ",
    "311": " ",
    "314": " ",
    "317": " ",
    "350": " ",
    "377": " ",
    # Thundery Showers
    "200": " ",
    # Light Snow
    "227": " ",
    "320": " ",
    # Heavy Snow
    "230": " ",
    # Light rain
    "266": " ",
    "293": " ",
    "296": " ",
    # Heavy Showers
    "299": " ",
    "305": " ",
    "356": " ",
    # Heavy Rain
    "302": " ",
    "308": " ",
    "359": " ",
    # Light Show Showers
    "323": "ﭽ ",
    "326": "ﭽ ",
    "368": "ﭽ ",
    # Heavy Snow Showers
    "335": "ﭽ ",
    "395": "ﭽ ",
    "371": "ﭽ ",
    # Heavy Snow
    "329": "流 ",
    "332": "流 ",
    "338": "流 ",
    # Light showers
    "353": " ",
    # Thundery Showers
    "386": " ",
    "389": " ",
    # Thundery Snow Showers
    "392": " ",
}
