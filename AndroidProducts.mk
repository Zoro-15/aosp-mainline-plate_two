#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/aosp_PL2_mainline.mk \
    $(LOCAL_DIR)/lineage_PL2_mainline.mk

COMMON_LUNCH_CHOICES := \
    lineage_PL2_mainline-ap2a-userdebug \
    aosp_PL2_mainline-ap2a-userdebug \
    lineage_PL2_mainline-userdebug \
    aosp_PL2_mainline-userdebug
