#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit 64-bit core
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Inherit from device configuration
$(call inherit-product, device/nokia/PL2_mainline/device.mk)

# Inherit LineageOS common full phone config
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_PL2_mainline
PRODUCT_DEVICE := PL2_mainline
PRODUCT_BRAND := Nokia
PRODUCT_MODEL := Nokia 6.1
PRODUCT_MANUFACTURER := HMD Global
