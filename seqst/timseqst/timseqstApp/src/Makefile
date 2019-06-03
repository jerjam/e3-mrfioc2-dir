TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET

# xxxRecord.h will be created from xxxRecord.dbd
DBDINC += xxxRecord

# Install xxxSupport.dbd into <top>/dbd
DBD += xxxSupport.dbd

# Build an IOC support library
LIBRARY_IOC += timseqstSupport

# Compile and add code to the support library
timseqstSupport_SRCS += xxxRecord.c
timseqstSupport_SRCS += devXxxSoft.c

# Link locally-provided code into the support library,
# rather than directly into the IOC application, that
# causes problems on Windows DLL builds
timseqstSupport_SRCS += dbSubExample.c
timseqstSupport_SRCS += devtimseqstVersion.c
timseqstSupport_SRCS += timseqstHello.c
timseqstSupport_SRCS += initTrace.c

timseqstSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
GENVERSION = timseqstVersion.h
# Macro name
GENVERSIONMACRO = timseqstVERSION

# Build the IOC application
PROD_IOC = timseqst

# timseqst.dbd will be created and installed
DBD += timseqst.dbd

# timseqst.dbd will include these files:
timseqst_DBD += base.dbd
timseqst_DBD += xxxSupport.dbd
timseqst_DBD += dbSubExample.dbd
timseqst_DBD += devtimseqstVersion.dbd
timseqst_DBD += timseqstHello.dbd
timseqst_DBD += initTrace.dbd

# timseqst_registerRecordDeviceDriver.cpp derives from timseqst.dbd
timseqst_SRCS += timseqst_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
timseqst_SRCS_DEFAULT += timseqstMain.cpp
timseqst_SRCS_vxWorks += -nil-

# Link in the code from our support library
timseqst_LIBS += timseqstSupport

# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file
ifneq ($(SNCSEQ),)
    # Build sncExample into timseqstSupport
    sncExample_SNCFLAGS += +r
    timseqst_DBD += sncExample.dbd
    # A .stt sequence program is *not* pre-processed:
    timseqstSupport_SRCS += sncExample.stt
    timseqstSupport_LIBS += seq pv
    timseqst_LIBS += seq pv

    # Build sncTim as a standalone program
    PROD_HOST += sncTim
    sncTim_SNCFLAGS += +m
    # A .st sequence program *is* pre-processed:
    # sncTim_SRCS += sncTim.st
    sncTim_SRCS += sncTim.st
    sncTim_LIBS += seq pv
    sncTim_LIBS += $(EPICS_BASE_HOST_LIBS)
endif

# Link QSRV (pvAccess Server) if available
ifdef EPICS_QSRV_MAJOR_VERSION
    timseqst_LIBS += qsrv
    timseqst_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    timseqst_DBD += PVAServerRegister.dbd
    timseqst_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
timseqst_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devtimseqstVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
