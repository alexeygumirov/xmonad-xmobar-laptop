#!/usr/bin/python3

import psutil

gibi = 1024 ** 3
mem_stats = psutil.virtual_memory()
mem_used = mem_stats.total - mem_stats.available

print(f"{mem_used/gibi:.2f}Gi|{mem_used*100/mem_stats.total:.0f}")
