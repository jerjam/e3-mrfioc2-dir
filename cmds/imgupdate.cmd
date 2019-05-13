require mrfioc2, 2.2.0-rc5
epicsEnvSet("DEV", "EVM")

# If EVM update
mrmEvgSetupPCI("$(DEV)", "07:00.0")
# If EVR update:
# mrmEvrSetupPCI("$(DEV)", "08:00.0")
iocInit()

# The EVM image is around 12MB
# Backup the image:
# flashread("$(DEV):FLASH", 0, 11443722, "$(BINR).bit")
# flashwrite("${DEV}:FLASH", 0, "$(BINW).bit")

# EVM img size: 11443722
# EVR img size: 3011417
# MTCA-EVR and PCIe FPGA: Kintex7 7K70T, bits=24,090,592 page=32 and in .bit size: 3011417
