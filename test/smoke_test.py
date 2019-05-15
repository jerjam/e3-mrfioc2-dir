#!/usr/bin/python3

import sys

print(sys.version)

if sys.version_info[0] < 3:
    raise Exception("ERROR: Python 3 required")

print("This line will be printed.")
