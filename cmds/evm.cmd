require mrfioc2, 2.2.0-rc5

epicsEnvSet("IOC", "MTCA")
epicsEnvSet("DEV", "EVM")

epicsEnvSet("MainEvtCODE", "14")
epicsEnvSet("HeartBeatEvtCODE", "122")
epicsEnvSet("ESSEvtClockRate", "88.0525")

mrmEvgSetupPCI($(DEV), "07:00.0")
dbLoadRecords("evm-mtca-300-ess.db", "SYS=$(IOC), D=$(DEV), EVG=$(DEV), FEVT=$(ESSEvtClockRate), FRF=$(ESSEvtClockRate), RFDIV=1")

# needed with software timestamp source w/o RT thread scheduling
var evrMrmTimeNSOverflowThreshold 100000

iocInit()

# Dump the PV-s
dbpr $(IOC)-$(DEV):FwVer-I > "$(IOC)-$(DEV)_PVs.list"
dbl >> "$(IOC)-$(DEV)_PVs.list"
#===============================

### EVNT field 14 to get processed on software (EPICS) event 125
dbpf $(IOC)-$(DEV)D:Time-I.EVNT 125
dbpf $(IOC)-$(DEV)D:Time-I.INP "@OBJ=EVRL, Code=125"
