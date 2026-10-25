#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nokia/PL2_mainline

# Initial bringup switch
TARGET_INITIAL_BRINGUP ?= true

# Inherit common mainline configurations
$(call inherit-product, device/mainline/common/mainline_common.mk)
-include device/mainline/qcom-common/mainline_qcom-common.mk

# Dalvik / Art heap
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# Display resolution & assets
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 1920
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

# Soong Namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Init scripts & fstab
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.nokia-pl2 \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.nokia-pl2 \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_RAMDISK)/fstab.nokia-pl2 \
    $(DEVICE_PATH)/configs/init.nokia-pl2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nokia-pl2.rc \
    $(DEVICE_PATH)/configs/ueventd.PL2_mainline.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

# Shipping API & Relaxed VINTF for initial bringup
PRODUCT_SHIPPING_API_LEVEL := 27
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
