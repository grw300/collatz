 #######################################################################
#
#  Copyright (c) 2013
#  National Instruments Corporation.
#  All rights reserved.
#
#######################################################################
#===============================================================================

POSSIBLE_OSENVS         := win32U
POSSIBLE_PROCESSORS     := i386
POSSIBLE_COMPILERS      := msvc90
POSSIBLE_RELEASE_TYPES  := release

POSSIBLE_SUBCOMPONENTS  := \
	collatz\

POSSIBLE_TARGETS        := \
	collatz/%/%/%/% \

#===============================================================================
#   Disable doxygen generation.  It isn't necessary, and it doesn't work well on the 
#	development machines, so let's remove it.  
#===============================================================================
DISABLE_DOXYGEN := 1
export DISABLE_DOXYGEN

DISABLE_PACKAGE_CODEGEN := 1
export DISABLE_PACKAGE_CODEGEN

#	Get everything started...
include $(MAKEINCLUDE_DIR)/begin.mak
