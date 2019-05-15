# e3-mrfioc2-plugin
The plugin will configure the e3-mrfioc2 in order to serv the ESS necessary services independent to mrfioc2 Epics community.

# Installation
This repo is designed in order to be directly merged into the e3-mrfioc2 root directory.

# Parse parameters into iocsh.bash
* iocsh.bash -c 'epicsEnvSet("IOC", "MTCA")'
* system("echo $IOC")
