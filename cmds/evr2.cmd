require mrfioc2,2.2.0-rc5
#require iocStats,ae5d083

epicsEnvSet("IOC", "MTCA")
epicsEnvSet("DEV", "EVR2")
epicsEnvSet("ESSEvtClockRate", "88.0525")
mrmEvrSetupPCI("$(DEV)", "09:00.0")
dbLoadRecords("evr-mtca-300u-ess.db","EVR=$(DEV), SYS=$(IOC), D=$(DEV), FEVT=$(ESSEvtClockRate)")

# needed with software timestamp source w/o RT thread scheduling
var evrMrmTimeNSOverflowThreshold 100000
#dbLoadRecords("../db/cnt.db")

iocInit()

# Dump the PV-s
dbpr $(IOC)-$(DEV):FwVer-I > "$(IOC)-$(DEV)_PVs.list"
dbl >> "$(IOC)-$(DEV)_PVs.list"

# Set delay compensation to 70 ns, needed to avoid timestamp issue
dbpf $(IOC)-$(DEV):DC-Tgt-SP 70

# Set the LED event 0 to event 14
dbpf $(IOC)-$(DEV):Evt-Blink0-SP 14
dbl > "$(IOC)-$(DEV)_PVs.list"

### Generate pulses with outputs
### Configure one delay generator
dbpf $(IOC)-$(DEV):DlyGen0-Evt-Trig0-SP $(EVENTCODE=14)
dbpf $(IOC)-$(DEV):DlyGen0-Width-SP $(WIDTH=1000)
### MTCA EVR Front Panel OUT0 trigger from DlyGen0 (delay generator 0)
dbpf $(IOC)-$(DEV):OutFP0-Src-SP 0
