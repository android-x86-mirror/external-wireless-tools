#
# Copyright (C) 2019 The Android-x86 Open Source Project
#
# Licensed under the GNU General Public License Version 2 or later.
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/gpl.html
#

LOCAL_PATH := $(call my-dir)

# GENERAL
WT_CFLAGS	:= -Wall -W -O3 -Wno-unused-but-set-variable -Wno-array-bounds \
                   -Wno-self-assign -Wshadow -Wpointer-arith -Wcast-qual -Winline

include $(CLEAR_VARS)
LOCAL_MODULE := iwlib
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_SRC_FILES := iwlib.c
LOCAL_CFLAGS := $(WT_CFLAGS)
WT_WIRELESS_H := $(local-generated-sources-dir)/wireless.h
LOCAL_GENERATED_SOURCES := $(WT_WIRELESS_H)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(local-generated-sources-dir)
$(WT_WIRELESS_H): $(LOCAL_PATH)/iwlib.h | $(ACP)
	$(ACP) $(^D)/wireless.`sed -ne "/WE_VERSION/{s:\([^0-9]*\)::;p;q;}" $^`.h $@
include $(BUILD_SHARED_LIBRARY)

define build-wt-tool
include $$(CLEAR_VARS)

LOCAL_MODULE := $(1)
LOCAL_SRC_FILES := $(1).c
LOCAL_CFLAGS := $$(WT_CFLAGS)
LOCAL_SHARED_LIBRARIES := iwlib
LOCAL_MODULE_PATH := $$(TARGET_OUT_OPTIONAL_EXECUTABLES)
include $$(BUILD_EXECUTABLE)
endef

WT_TOOLS := \
    ifrename \
    iwconfig \
    iwevent \
    iwgetid \
    iwlist \
    iwpriv \
    iwspy \
    macaddr \

$(foreach w,$(WT_TOOLS),$(eval $(call build-wt-tool,$(w))))
