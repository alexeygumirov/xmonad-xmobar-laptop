#!/usr/bin/python3

import psutil

# print(round(psutil.cpu_percent(interval=10)))
print(psutil.sensors_temperatures().get("thinkpad"))
