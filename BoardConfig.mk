#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nokia/PL2_mainline

# 1. Identify device
USES_DEVICE_NOKIA_PL2_MAINLINE := true

# 2. Variables read by common board config
TARGET_INITIAL_BRINGUP ?= true

# ------------------------------------------------------------------------------
# Soong & Platform Blueprint Fixups for Android 17 / Baklava
# ------------------------------------------------------------------------------
# Ensure Soong temporary working directory exists
$(shell mkdir -p out/soong/.temp)


# Fix Soong Blueprint analysis break in external/libjxl and external/dng_sdk:
# external/libjxl declares 'vendor_available: true' but its static dependencies
# 'libskia_skcms' (external/skia) and 'libhwy' (external/libhwy) lack vendor variants.
# Since /vendor does not use JPEG XL, remove vendor_available to satisfy the Soong graph.
$(shell [ -d external/libjxl ] && find external/libjxl -name "Android.bp" -exec sed -i -E '/vendor_available:[[:space:]]*true/d' {} + 2>/dev/null)
$(shell [ -d external/dng_sdk ] && find external/dng_sdk -name "Android.bp" -exec sed -i -E '/vendor_available:[[:space:]]*true/d' {} + 2>/dev/null)

# Ensure ALSA library dependencies for hardware/mainline/common audio HAL exist
$(shell [ ! -d external/alsa-lib ] && git clone --depth=1 -b lineage-24.0 https://github.com/LineageOS/android_external_alsa-lib.git external/alsa-lib 2>/dev/null)
$(shell [ ! -d external/alsa-ucm-conf ] && git clone --depth=1 -b lineage-24.0 https://github.com/LineageOS/android_external_alsa-ucm-conf.git external/alsa-ucm-conf 2>/dev/null)

# Ensure mainline framework dependencies exist
$(shell [ ! -d vendor/mainline ] && git clone --depth=1 -b lineage-24.0 https://github.com/me-cafebabe-aosp-mainline/android_vendor_mainline.git vendor/mainline 2>/dev/null)
$(shell [ ! -d external/linux-firmware-mainline ] && git clone --depth=1 -b lineage-24.0 https://github.com/LineageOS/android_external_linux-firmware-mainline.git external/linux-firmware-mainline 2>/dev/null)
$(shell [ ! -d external/minigbm-upstream ] && git clone --depth=1 -b lineage-24.0 https://github.com/LineageOS/android_external_minigbm-upstream.git external/minigbm-upstream 2>/dev/null)

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

# Set minigbm platform for Qualcomm MSM (docs/qcom/GRAPHICS.md & docs/qcom/NEW_DEVICE.md)
$(call soong_config_set,minigbm_upstream,platform,msm)
$(call soong_config_set,minigbm,platform,msm)
SOONG_CONFIG_minigbm_upstream_platform := msm
SOONG_CONFIG_minigbm_platform := msm

# VINTF Device Manifest
DEVICE_MANIFEST_FILE := $(sort $(DEVICE_MANIFEST_FILE) $(wildcard vendor/nokia/PL2_mainline/proprietary/etc/vintf/manifest.xml $(DEVICE_PATH)/manifest.xml))

# Display
TARGET_SCREEN_DENSITY := 420

# Bootloader & Kernel starting mechanism (Header v0 for Little Kernel aboot)
TARGET_NO_BOOTLOADER := true
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_BOOT_HEADER_VERSION := 0
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_TAGS_OFFSET := 0x00000100
BOARD_SECOND_OFFSET := 0x00f00000
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := true

# Kernel Build
TARGET_KERNEL_SOURCE := kernel/nokia/sdm630-mainline
TARGET_KERNEL_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
TARGET_KERNEL_CONFIG := sdm660_defconfig
TARGET_KERNEL_DTB := dtbs
TARGET_DTB_LIST_WILDCARD := *sdm630-nokia-pl2*.dtb

# Android Mainline Configuration Fragments
TARGET_KERNEL_CONFIG_EXT := \
    kernel/mainline/configs/fragments/android-base-pre/common.config \
    kernel/mainline/configs/fragments/android-base-pre/arm64.config \
    kernel/configs/b/android-6.12/android-base.config \
    kernel/mainline/configs/fragments/android-base-conditional/CONFIG_ARM64-y.config \
    kernel/mainline/configs/fragments/common.config \
    kernel/mainline/configs/fragments/y/fbcon.config \
    $(DEVICE_PATH)/configs/kconfigs/pl2_fixups.config

# Cmdline & Boot parameters
# Nokia boot device block path on sdm630: soc/c0c4000.sdhci (downstream) and soc/c0c4000.mmc (mainline)
BOARD_KERNEL_CMDLINE += \
    androidboot.boot_devices=any,soc@0/c0c4000.mmc,soc/c0c4000.sdhci,c0c4000.mmc \
    androidboot.hardware=nokia-pl2 \
    androidboot.selinux=permissive \
    androidboot.verifiedbootstate=orange \
    androidboot.usbcontroller=a800000.usb \
    earlycon \
    console=ttyMSM0,115200n8 \
    clk_ignore_unused \
    pd_ignore_unused \
    cpuidle.off=1 \
    firmware_class.path=/vendor/firmware/

# Mainline common boot parameters for header v0 (bootconfig disabled)
BOARD_KERNEL_CMDLINE += $(MAINLINE_COMMON_ANDROIDBOOT_PARAMS)
BOARD_KERNEL_CMDLINE += $(MAINLINE_COMMON_KERNEL_PARAMS)

# Partitions (Retrofit Dynamic Partitions)
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 3221225472
BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 1073741824

BOARD_PRODUCTIMAGE_MINIMAL_PARTITION_RESERVED_SIZE := true
-include vendor/lineage/config/BoardConfigReservedSize.mk

BOARD_USES_METADATA_PARTITION := true
BOARD_USES_RECOVERY_AS_BOOT := true
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864

BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

BOARD_SUPER_PARTITION_BLOCK_DEVICES := system vendor
BOARD_SUPER_PARTITION_GROUPS := nokia_dynamic_partitions
BOARD_SUPER_PARTITION_METADATA_DEVICE := system
BOARD_SUPER_PARTITION_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE) + $(BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE))
BOARD_NOKIA_DYNAMIC_PARTITIONS_PARTITION_LIST := odm product system system_ext vendor
BOARD_NOKIA_DYNAMIC_PARTITIONS_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SIZE) - 4194304) # 4MiB overhead

TARGET_COPY_OUT_ODM := odm
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor
TARGET_NO_RECOVERY := true
TARGET_USERIMAGES_USE_EXT4 := true

# A/B OTA Partitions
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    odm \
    product \
    system \
    system_ext \
    vendor

# Verity
BOARD_AVB_ENABLE := false

# Root folders & symlinks (Retrofit Dynamic Partitions & LinkerConfig staging)
BOARD_ROOT_EXTRA_FOLDERS += linkerconfig
BOARD_ROOT_EXTRA_SYMLINKS += \
    /mnt/vendor/persist:/persist \
    /vendor/bt_firmware:/bt_firmware \
    /vendor/dsp:/dsp \
    /vendor/firmware_mnt:/firmware

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/configs/fstab.nokia-pl2
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# Inherit proprietary vendor board configs
-include vendor/nokia/PL2_mainline/BoardConfigVendor.mk
