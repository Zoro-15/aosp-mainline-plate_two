#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),PL2_mainline)

include $(CLEAR_VARS)
LOCAL_MODULE := init_recovery_static
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := configs/init.arm64
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/system/bin
LOCAL_MODULE_STEM := init
LOCAL_UNSTRIPPED_PATH := $(LOCAL_MODULE_PATH)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := init_root_static
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := configs/init.arm64
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/bin
LOCAL_MODULE_STEM := init
LOCAL_UNSTRIPPED_PATH := $(LOCAL_MODULE_PATH)
include $(BUILD_PREBUILT)

endif
