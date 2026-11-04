#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),PL2_mainline)

# Ensure TARGET_ROOT_OUT exists for build_image.py (recovery-as-boot)
$(shell mkdir -p $(PRODUCT_OUT)/root && find $(PRODUCT_OUT)/root -name ".keep" -delete 2>/dev/null)

$(PRODUCT_OUT)/root:
	@mkdir -p $@

$(PRODUCT_OUT)/obj/PACKAGING/system_intermediates/system.img: | $(PRODUCT_OUT)/root
$(PRODUCT_OUT)/system.img: | $(PRODUCT_OUT)/root

endif

