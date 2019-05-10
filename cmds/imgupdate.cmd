
require mrfioc2, 2.2.0-rc5
epicsEnvSet("DEV", "EVM")

# If EVM update
mrmEvgSetupPCI("$(DEV)", "08:00.0")
# If EVR update:
# mrmEvrSetupPCI("$(DEV)", "08:00.0")
iocInit()

# The EVM image is around 12MB
# Backup the image:
# flashread("$(DEV):FLASH", 0, 0x1500000, "$(BINR).bit")
# flashwrite("${DEV}:FLASH", 0, "$(BINW).bit")

# EVM img 207.7 size: 11443722
# PCIe img xxx.x size: 0x300000
# MTCA-EVR: Kintex7 7K70T, bits=24,090,592 page=32

