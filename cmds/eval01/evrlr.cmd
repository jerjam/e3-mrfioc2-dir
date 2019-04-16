#!/bin/bash

require mrfioc2,2.2.0-rc5

epicsEnvSet("SYS", "MTCA")
epicsEnvSet("D", "EVRL")
epicsEnvSet("ESSEvtClockRate", "88.0525")
mrmEvrSetupPCI("$(D)", "0a:00.0")
dbLoadRecords("evr-mtca-300u-ess.db","EVR=$(D), SYS=$(SYS), D=$(D), FEVT=$(ESSEvtClockRate)")

### needed with software timestamp source w/o RT thread scheduling
var evrMrmTimeNSOverflowThreshold 100000

iocInit()

### Set delay compensation to 70 ns, needed to avoid timestamp issue
dbpf $(SYS)-$(D):DC-Tgt-SP 70

### EVR standalone mode
### Get current time from system clock, this will be used for the timestamps ###
dbpf $(SYS)-$(D):TimeSrc-Sel "Sys.Clock"

### Set up the prescaler that will trigger the sequencer at 14 Hz ###
### The value of the prescaler is the integer which gives the expected frequency (14 Hz in this example) when the event frequency (88.0525 MHz for ESS) is divided by the integer: 88.0525 MHz / 6289464 = 14 Hz
dbpf $(SYS)-$(D):PS0-Div-SP 6289464

### Set up the sequencer ###
### Set the runmode to normal, so that the sequencer re-arms after it finishes running
dbpf $(SYS)-$(D):SoftSeq0-RunMode-Sel "Normal"
### Set the trigger of the sequencer as prescaler 0
dbpf $(SYS)-$(D):SoftSeq0-TrigSrc-2-Sel "Prescaler 0"

### Set the engineering units (microseconds) for the delay of the events in the sequence (sequence timestamps) used in configure_sequencer_14Hz.sh; more information below
dbpf $(SYS)-$(D):SoftSeq0-TsResolution-Sel "uSec"

### Attach the soft sequence to a specific hardware sequence
dbpf $(SYS)-$(D):SoftSeq0-Load-Cmd 1

### Enable the sequencer
dbpf $(SYS)-$(D):SoftSeq0-Enable-Cmd 1

### Set the LED event 0 to event 14
dbpf $(SYS)-$(D):Evt-Blink0-SP 14
dbl > "$(SYS)-$(D)_PVs.list"

### Run the script that configures the events and timestamps of the sequence, more information below ###
system("/bin/sh ./evr_seq_ev14_14Hz.sh $(SYS) $(D)")

### Forward events with EVR - it has to be disabled for the loopback link
#pcidiagset 9 0 0
#pciwrite 32 0x40e0 0x90000000

### Generate pulses with outputs
### Configure one delay generator
dbpf $(SYS)-$(D):DlyGen0-Evt-Trig0-SP $(EVENTCODE=14)
dbpf $(SYS)-$(D):DlyGen0-Width-SP $(WIDTH=1000)
### MTCA EVR Front Panel OUT0 trigger from DlyGen0 (delay generator 0)
dbpf $(SYS)-$(D):OutFP0-Src-SP 0

### MTCA EVR Backplane0, RX17 (0)
dbpf $(SYS)-$(D):OutBack0-Src-SP 0
dbpf $(SYS)-$(D):OutBack1-Src-SP 0
dbpf $(SYS)-$(D):OutBack2-Src-SP 0
dbpf $(SYS)-$(D):OutBack3-Src-SP 0
dbpf $(SYS)-$(D):OutBack4-Src-SP 0
dbpf $(SYS)-$(D):OutBack5-Src-SP 0
dbpf $(SYS)-$(D):OutBack6-Src-SP 0
dbpf $(SYS)-$(D):OutBack7-Src-SP 0

### Set TCLKA to low, enable it and power it up
dbpf $(SYS)-$(D):OutTCLKA-Src-SP 63
dbpf $(SYS)-$(D):OutTCLKA-Ena-Sel 1
dbpf $(SYS)-$(D):OutTCLKA-Pwr-Sel 1
### TCLKA is 40-bit pattern, set the starting 20 bits to 1 (and the rest to 0 - default)
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.BF 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.BE 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.BD 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.BC 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.BB 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.BA 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B9 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B8 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B7 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B6 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B5 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B4 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B3 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B2 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B1 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low00_15-SP.B0 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low16_31-SP.BF 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low16_31-SP.BE 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low16_31-SP.BD 1
dbpf $(SYS)-$(D):OutTCLKA-Pat-Low16_31-SP.BC 1

### Set TCLKB to low, enable it and power it up
dbpf $(SYS)-$(D):OutTCLKB-Src-SP 63
dbpf $(SYS)-$(D):OutTCLKB-Ena-Sel 1
dbpf $(SYS)-$(D):OutTCLKB-Pwr-Sel 1
### TCLKB is 40-bit pattern, set the starting 20 bits to 1 (and the rest to 0 - default)
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.BF 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.BE 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.BD 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.BC 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.BB 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.BA 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B9 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B8 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B7 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B6 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B5 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B4 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B3 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B2 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B1 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low00_15-SP.B0 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low16_31-SP.BF 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low16_31-SP.BE 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low16_31-SP.BD 1
dbpf $(SYS)-$(D):OutTCLKB-Pat-Low16_31-SP.BC 1
