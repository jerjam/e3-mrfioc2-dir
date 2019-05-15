#!/usr/bin/python3

import sys

# file environment test
print(sys.version)

if sys.version_info[0] < 3:
    raise Exception("ERROR: Python 3 required")

# ---------------------------------------------
# epics environment test
import epics
print(epics.ca.find_libca())

print("This line will be printed.")
