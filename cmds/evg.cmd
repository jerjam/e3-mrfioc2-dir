require mrfioc2, 2.2.0-rc5

epicsEnvSet("IOC", "MTCA")
epicsEnvSet("DEV", "EVG")

epicsEnvSet("MainEvtCODE", "14")
epicsEnvSet("HeartBeatEvtCODE", "122")
epicsEnvSet("ESSEvtClockRate", "88.0525")

mrmEvgSetupPCI($(DEV), "08:00.0")
dbLoadRecords("evm-mtca-300-ess.db",  "SYS=$(IOC), D=$(DEV), EVG=$(DEV), FEVT=$(ESSEvtClockRate), FRF=$(ESSEvtClockRate), FDIV=1")

# needed with software timestamp source w/o RT thread scheduling
var evrMrmTimeNSOverflowThreshold 100000

iocInit()

dbpf "$(IOC)-$(DEV):1ppsInp-Sel" "Sys Clk"

# Set EVM as master
dbpf $(IOC)-$(DEV):Enable-Sel "Ena Master"

### Set up the sequencer ###
dbpf $(IOC)-$(DEV):SoftSeq0-RunMode-Sel "Normal"
dbpf $(IOC)-$(DEV):SoftSeq0-TrigSrc-Sel "Mxc0"
dbpf $(IOC)-$(DEV):SoftSeq0-TsResolution-Sel "uSec"
dbpf $(IOC)-$(DEV):SoftSeq0-Load-Cmd 1
dbpf $(IOC)-$(DEV):SoftSeq0-Enable-Cmd 1

# Master Event Rate 14 Hz
dbpf $(IOC)-$(DEV):Mxc0-Prescaler-SP 6289464
#dbpf $(IOC)-$(DEV):TrigEvt0-EvtCode-SP $(MainEvtCODE)
#dbpf $(IOC)-$(DEV):TrigEvt0-TrigSrc-Sel "Mxc0"
system("/bin/bash ../iocsh/seq_14Hz.bash $(IOC) $(DEV)")

# Heart Beat 1 Hz
dbpf $(IOC)-$(DEV):Mxc7-Prescaler-SP 88052500
dbpf $(IOC)-$(DEV):TrigEvt7-EvtCode-SP $(HeartBeatEvtCODE)
dbpf $(IOC)-$(DEV):TrigEvt7-TrigSrc-Sel "Mxc7"

# Is there something similar to sleep(5)????
# dbpf $(IOC)-$(DEV):SyncTimestamp-Cmd 1

# Dump the PV-s
dbl > "$(IOC)-$(DEV)_PVs.list"
