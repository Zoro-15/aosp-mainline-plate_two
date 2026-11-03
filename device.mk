#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nokia/PL2_mainline

# Initial bringup switch (Retained for Stage 1-6 bringup: keeps SELinux permissive & console root shell)
TARGET_INITIAL_BRINGUP ?= true

# Enforce generic fallbacks for media, camera, and audio during initial bringup
# (prevents pulling unbuilt/unfixed hardware HALs into /vendor before Stage 6)
TARGET_CAMERA_PROVIDER_HAL :=
TARGET_MEDIA_C2_HAL :=
TARGET_AUDIO_HAL :=

# Inherit common mainline configurations
$(call inherit-product, device/mainline/common/mainline_common.mk)

# Inherit proprietary vendor configurations
$(call inherit-product-if-exists, vendor/nokia/PL2_mainline/pl2_mainline-vendor.mk)

# Page size configuration
PRODUCT_PAGE_SIZE_AGNOSTIC := false
PRODUCT_MAX_PAGE_SIZE_SUPPORTED := 65536

# Dalvik / Art heap
$(call inherit-product, frameworks/native/build/phone-xhdpi-4096-dalvik-heap.mk)

# Display resolution & assets
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 1920
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Device Overlays
DEVICE_PACKAGE_OVERLAYS += $(DEVICE_PATH)/overlays

# Packages & Memfd (pristine/community kernel support)
PRODUCT_PACKAGES += \
    init_first_stage \
    fastbootd \
    use_memfd.rc \
    vendor_bt_firmware_mountpoint \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint

# Soong Namespaces & Configuration
$(call soong_config_set,minigbm_upstream,platform,msm)
$(call soong_config_set,minigbm,platform,msm)
SOONG_CONFIG_minigbm_upstream_platform := msm
SOONG_CONFIG_minigbm_platform := msm

PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    device/mainline/common \
    hardware/mainline/common \
    kernel/mainline/configs \
    vendor/mainline \
    external/alsa-lib \
    external/alsa-ucm-conf \
    external/linux-firmware-mainline \
    external/mesa3d \
    external/minigbm-upstream \
    external/libdrm

# Init scripts & fstab (Header v0 recovery-as-boot layout)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/init.arm64:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/init \
    $(DEVICE_PATH)/configs/init.arm64:$(TARGET_COPY_OUT_RAMDISK)/system/bin/init \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.nokia-pl2 \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.qcom \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.default \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_RAMDISK)/fstab.nokia-pl2 \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_RAMDISK)/fstab.qcom \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_RAMDISK)/first_stage_ramdisk/fstab.nokia-pl2 \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_RAMDISK)/first_stage_ramdisk/fstab.qcom \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.nokia-pl2 \
    $(DEVICE_PATH)/configs/fstab.nokia-pl2:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.qcom \
    $(DEVICE_PATH)/configs/init.nokia-pl2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nokia-pl2.rc \
    $(DEVICE_PATH)/configs/init.nokia-pl2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.qcom.rc \
    $(DEVICE_PATH)/configs/init.recovery.nokia-pl2.rc:$(TARGET_COPY_OUT_RAMDISK)/init.recovery.nokia-pl2.rc \
    $(DEVICE_PATH)/configs/init.recovery.nokia-pl2.rc:$(TARGET_COPY_OUT_RAMDISK)/init.recovery.qcom.rc \
    $(DEVICE_PATH)/configs/init.recovery.nokia-pl2.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.nokia-pl2.rc \
    $(DEVICE_PATH)/configs/init.recovery.nokia-pl2.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc \
    $(DEVICE_PATH)/configs/ueventd.PL2_mainline.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.nokia-pl2.rc \
    $(DEVICE_PATH)/configs/ueventd.PL2_mainline.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.qcom.rc

# Shipping API & Relaxed VINTF for initial bringup
PRODUCT_SHIPPING_API_LEVEL := 27
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Enforce VINTF manifest specification via DEVICE_MANIFEST_FILE
PRODUCT_COPY_FILES := $(filter-out %/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest.xml %/manifest.xml:vendor/etc/vintf/manifest.xml,$(PRODUCT_COPY_FILES))

# Filter duplicate firmware files provided by external/linux-firmware-mainline
PRODUCT_COPY_FILES := $(filter-out %/a530_pm4.fw:% %/a530_pfp.fw:%,$(PRODUCT_COPY_FILES))

# Filter duplicate ueventd.rc (common ueventd.rc is provided by ueventd.mainline.rc Soong module)
PRODUCT_COPY_FILES := $(filter-out %:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc %:vendor/etc/ueventd.rc,$(PRODUCT_COPY_FILES))
