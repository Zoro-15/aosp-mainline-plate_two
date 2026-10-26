# Android device tree for Nokia 6.1 (PL2) running mainline kernel

The Nokia 6.1 (2018, codename `PL2` / `Plate2` / `PL2_sprout`) is a Qualcomm Snapdragon 630 smartphone. This tree ports upstream Linux (6.x/7.x) and Android 17 (LineageOS 24.0) using the `me-cafebabe-aosp-mainline` common framework.

## Status

| Feature | Works | Notes |
|---------|-------|-------|
| Boot | yes | Stage 2 bringup using `qcom-sdm660-7.2.y` |
| Display | yes | Simple framebuffer console (`simple-framebuffer@9D400000`) |
| Touch | | Synaptics touch on I2C |
| Audio | | WCD9335 codec via Soundwire/SLIMbus |
| Wi-Fi / Bluetooth | | WCN3990 via smd-rpm |
| Camera | | Camera sensor interface |
| Modem | | Qualcomm MDM / Hexagon DSPs |
| Charging | | SMB1351 / PM660 charger |

## Before flashing the Android build

1. Unlock the bootloader via official or EDL test-point unlock.
2. For initial bringup testing, do not flash directly to partition storage. Boot temporarily via fastboot: `fastboot boot out/target/product/PL2_mainline/boot.img`.

## Additional repositories required to build

| Path | Source |
|------|--------|
| `kernel/nokia/sdm630-mainline` | `https://github.com/Zoro-15/android_kernel_nokia_sdm630-mainline` (branch: `qcom-sdm660-7.2.y`) |
| `device/mainline/common` | `https://github.com/me-cafebabe-aosp-mainline/android_device_mainline_common` (branch: `lineage-24.0`) |
| `hardware/mainline/common` | `https://github.com/me-cafebabe-aosp-mainline/android_hardware_mainline_common` (branch: `lineage-24.0`) |
| `kernel/mainline/configs` | `https://github.com/me-cafebabe-aosp-mainline/android_kernel_mainline_configs` (branch: `lineage-24.0`) |

## Android platform patches

| Commit name | Purpose | Source |
|-------------|---------|--------|
| `jniClatCoordinator: Do not crash on BPF SELinux context mismatch` | Prevent boot crash on Linux 7.2+ kernels | `https://review.lineageos.org/c/LineageOS/android_packages_modules_Connectivity/+/494663` |

## Kernel

Apply the patches in
`device/mainline/common/docs/KERNEL_PATCHES.md`.

Device specific:

| Commit name | Purpose | Source |
|-------------|---------|--------|
| `arm64: dts: qcom: sdm630-nokia-pl2: Add simple-framebuffer node` | Framebuffer console at `0x9D400000` | In-tree (`qcom-sdm660-7.2.y`) |
| `arm64: dts: qcom: sdm630-nokia-pl2: Add ramoops pstore reserve` | Pstore crash logging at `0xACB00000` | In-tree (`qcom-sdm660-7.2.y`) |
| `arm64: dts: qcom: sdm630-nokia-pl2: Set Qualcomm board and MSM IDs` | Nokia ABOOT validation (`qcom,board-id = <0x08 0x00>`) | In-tree (`qcom-sdm660-7.2.y`) |

## Build

```bash
breakfast PL2_mainline
m bootimage
```

## Install

Put the Nokia 6.1 into Fastboot mode (**Volume Down + Power**):

```bash
fastboot boot out/target/product/PL2_mainline/boot.img
```

## Known issues

- Initial bringup runs with `TARGET_INITIAL_BRINGUP := true` (permissive SELinux).
- Display currently relies on bootloader framebuffer handover (`fbcon`) until Mesa Freedreno DRM KMS pipeline is configured in Stage 5.
