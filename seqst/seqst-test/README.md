# Compile
 source epics_env/setEpicsEnv.bash
 make
 make distclean
 make clean

# How to use the standalone sequencer

 myexample$ cat configure/RELEASE.local
 SNCSEQ = /home/jerzy/epics_env/epics-modules/seq/
 EPICS_BASE = /home/jerzy/epics_env/epics-base

* Compile

 myexample/bin/linux-x86_64$ ./sncProgram "user=jhlee"
