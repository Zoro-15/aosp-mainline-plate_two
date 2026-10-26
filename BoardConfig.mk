#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nokia/PL2_mainline

# 1. Identify device
USES_DEVICE_NOKIA_PL2_MAINLINE := true

# 2. Variables read by common board config
TARGET_INITIAL_BRINGUP := true

# 3. Inherit Common Board configs from mainline framework
-include device/mainline/common/BoardConfigMainlineCommon.mk

# 4. Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_SUPPORTS_64_BIT_APPS := true
TARGET_MAX_PAGE_SIZE_SUPPORTED := 65536

# Assertions
TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt
TARGET_OTA_ASSERT_DEVICE := PL2,PL2_sprout,Plate2,PL2_mainline

# Platform
TARGET_BOARD_PLATFORM := sdm630
TARGET_BOOTLOADER_BOARD_NAME := sdm630

# Display
TARGET_SCREEN_DENSITY := 420

# Bootloader & Kernel starting mechanism
TARGET_NO_BOOTLOADER := true
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_BOOT_HEADER_VERSION := 2
BOARD_USES_RECOVERY_AS_BOOT := true

# Kernel Build
TARGET_KERNEL_SOURCE := kernel/nokia/sdm630-mainline
TARGET_KERNEL_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
TARGET_KERNEL_CONFIG := sdm660_defconfig
TARGET_KERNEL_DTB := sdm630-nokia-pl2.dtb

# Android Mainline Configuration Fragments
TARGET_KERNEL_CONFIG_EXT := \
    kernel/mainline/configs/fragments/android-base-pre/common.config \
    kernel/mainline/configs/fragments/android-base-pre/arm64.config \
    kernel/configs/b/android-6.6/android-base.config \
    kernel/mainline/configs/fragments/android-base-conditional/CONFIG_ARM64-y.config \
    kernel/mainline/configs/fragments/common.config \
    kernel/mainline/configs/fragments/y/fbcon.config \
    $(DEVICE_PATH)/configs/kconfigs/pl2_fixups.config

# Cmdline & Boot parameters
# Nokia boot device block path on sdm630: soc/c0c4000.sdhci (downstream) and soc/c0c4000.mmc (mainline)
BOARD_KERNEL_CMDLINE += \
    androidboot.boot_devices=soc/c0c4000.sdhci,soc/c0c4000.mmc \
    androidboot.hardware=nokia-pl2 \
    androidboot.selinux=permissive \
    androidboot.verifiedbootstate=orange \
    androidboot.usbcontroller=a800000.dwc3 \
    earlycon \
    console=tty0 \
    console=ttyMSM0,115200n8 \
    clk_ignore_unused \
    pd_ignore_unused \
    firmware_class.path=/vendor/firmware/

# Partitions (A/B layout, sizes from device GPT)
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    system \
    vendor

BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor
BOARD_USES_METADATA_PARTITION := true

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/configs/fstab.nokia-pl2
