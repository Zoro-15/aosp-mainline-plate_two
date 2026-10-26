# Agents must read this before touching the tree

This file sets rules, hardware quirks, and reference paths for AI agents working on the Nokia 6.1 (`PL2_mainline`) Android 17 / LineageOS 24.0 mainline bringup.

## Hard Rules

1. **No Guessing**: Read values from DT, sysfs, fstab, or downstream vendor configs. Never invent hardware addresses, register values, or clock rates.
2. **One Stage at a Time**: Follow the 8-stage roadmap in `docs/BRINGUP_OVERVIEW.md`. Do not attempt peripheral bringup (Stage 6) before achieving shell access (Stage 4).
3. **Safe Boot Only**: Never instruct or flash images directly (`fastboot flash boot`). Always test via temporary boot: `fastboot boot boot.img`.
4. **Bringup Mode**: Keep `TARGET_INITIAL_BRINGUP := true` active in `BoardConfig.mk` and `device.mk` until Stage 8.
5. **Shell Syntax**: On Windows hosts, use PowerShell command chaining (`;`, never `&&`).
6. **Mainline Framework**: Inherit from `device/mainline/common/mainline_common.mk` and `device/mainline/common/BoardConfigMainlineCommon.mk`. Do not add custom downstream hacks into common trees.

## Hardware Quirks & Constants (Nokia 6.1 / PL2)

| Property | Value | Notes |
|:---|:---|:---|
| **SoC** | Qualcomm Snapdragon 630 (`sdm630`) | ARM64 Cortex-A53 |
| **Bootloader Validation** | `qcom,msm-id = <0x13e 0x00>`, `qcom,board-id = <0x08 0x00>` | Required by Nokia ABOOT to boot raw images |
| **Boot Device Path** | `soc/c0c4000.sdhci` | Set in `androidboot.boot_devices` |
| **Early Display Console** | `simple-framebuffer@9D400000` (1080x1920) | Pre-configured in `sdm630-nokia-pl2.dts` |
| **Crash Logging** | Ramoops pstore at `0xACB00000` | Configured in DT and `pl2_fixups.config` |
| **Metadata Partition** | `/dev/block/by-name/logdump` | Repurposed as `/metadata` for Android 17 `aconfigd` |
| **USB Controller** | `a800000.dwc3` | Set in cmdline and `init.nokia-pl2.rc` |
| **Page Size** | 64KB supported (`TARGET_MAX_PAGE_SIZE_SUPPORTED := 65536`) | Android 17 requirement |

## Reference Repositories & Paths

| Path | Repository | Purpose |
|:---|:---|:---|
| `device/nokia/PL2_mainline` | `Zoro-15/aosp-mainline-plate_two` | This device tree (`lineage-24.0`) |
| `kernel/nokia/sdm630-mainline` | `Zoro-15/android_kernel_nokia_sdm630-mainline` | Mainline kernel (`qcom-sdm660-7.2.y`) |
| `device/mainline/common` | `me-cafebabe-aosp-mainline/android_device_mainline_common` | Mainline common device configurations |
| `hardware/mainline/common` | `me-cafebabe-aosp-mainline/android_hardware_mainline_common` | Mainline open-source HALs |
| `kernel/mainline/configs` | `me-cafebabe-aosp-mainline/android_kernel_mainline_configs` | AOSP mainline Kconfig fragments & `use_memfd.rc` |
