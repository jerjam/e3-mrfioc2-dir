# require mrfioc2,2.2.0-rc5
# require iocStats,ae5d083

epicsEnvSet("IOC", "ICS-LAB:DIA")
epicsEnvSet("DEV", "CNT-0")
dbLoadRecords("../db/cnt.db", "SYS=$(IOC), D=$(DEV)")
iocInit()

dbl > "$(IOC)-$(DEV)_PVs.list"

$(DEBUG=#) system("echo aaaaaaaaaaaaaaaaa")
