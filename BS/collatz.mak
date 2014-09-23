#==================================================================================================
#
#  (c) Copyright 2013
#  National Instruments Corporation.
#  All rights reserved.
#
#==================================================================================================

#==================================================================================================
#
#  Always include this line at the top of your subcomponent makefile
#
include $(MAKEINCLUDE_DIR)/topOfMake.mak
#
#==================================================================================================

SOURCE := \
   Collatz/williams-collatz.cpp  \

#===============================================================================
#
#  Always include this at the bottom of your makefile
#
include $(MAKEINCLUDE_DIR)/bottomOfMake.mak
#
#===============================================================================

#
#  Dependencies imported from other components (must be below bottomOfMake.mak).
#