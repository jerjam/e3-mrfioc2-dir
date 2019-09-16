
epicsEnvSet("IOC", "TEST")
epicsEnvSet("DEV", "CNT")

dbLoadRecords("../db/cnt.db", "SYS=$(IOC), D=$(DEV)")

iocInit()

dbl > "$(IOC)-$(DEV)_PVs.list"


