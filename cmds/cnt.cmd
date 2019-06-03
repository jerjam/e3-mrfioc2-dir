# require mrfioc2,2.2.0-rc5
# require iocStats,ae5d083

# Select the Production or Debug mode
epicsEnvSet("PROD", "")
$(DEBUG=#)epicsEnvSet("PROD", "#")

epicsEnvSet("IOC", "TEST")
epicsEnvSet("DEV", "CNT")
dbLoadRecords("../db/cnt.db", "SYS=$(IOC), D=$(DEV)")
iocInit()

dbl > "$(IOC)-$(DEV)_PVs.list"

$(DEBUG=#)system("echo DEBUG")
$(PROD)system("echo PRODUCTION")
