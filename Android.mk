#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),PL2_mainline)

# Ensure TARGET_ROOT_OUT does not contain stale ramdisk directories or .keep placeholders
# that break e2fsdroid during system.img packaging.
$(shell rm -rf $(PRODUCT_OUT)/root/first_stage_ramdisk $(PRODUCT_OUT)/root/debug_ramdisk $(PRODUCT_OUT)/root/second_stage_resources 2>/dev/null)
$(shell find $(PRODUCT_OUT)/root -name ".keep" -delete 2>/dev/null)

endif
