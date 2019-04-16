#!/bin/bash

require mrfioc2,2.2.0-rc5
#require iocStats,ae5d083

epicsEnvSet("SYS", "MTCA")
epicsEnvSet("D1", "EVR0")
epicsEnvSet("ESSEvtClockRate", "88.0525")
mrmEvrSetupPCI("$(D1)", "09:00.0")
dbLoadRecords("evr-mtca-300u-ess.db","EVR=$(D1), SYS=$(SYS), D=$(D1), FEVT=$(ESSEvtClockRate)")

# needed with software timestamp source w/o RT thread scheduling
var evrMrmTimeNSOverflowThreshold 100000
dbLoadRecords("./counter.db")

iocInit()

# Set delay compensation to 70 ns, needed to avoid timestamp issue
dbpf $(SYS)-$(D1):DC-Tgt-SP 70

# Set the LED event 0 to event 14
dbpf $(SYS)-$(D1):Evt-Blink0-SP 14
dbl > "$(SYS)-$(D1)_PVs.list"
