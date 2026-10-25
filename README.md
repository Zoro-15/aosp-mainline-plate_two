# Nokia 6.1 (PL2) Mainline Device Tree

This device tree is designed to boot upstream mainline Linux on the Nokia 6.1 (`PL2` / `Plate2` / `PL2_sprout`) with Android 17 (LineageOS 24.0) using the [me-cafebabe-aosp-mainline](https://github.com/me-cafebabe-aosp-mainline) common framework.

## Device Specifications

| Feature | Specification |
|:---|:---|
| **SoC** | Qualcomm Snapdragon 630 (`sdm630`) |
| **CPU** | 8x ARM Cortex-A53 up to 2.2 GHz |
| **GPU** | Qualcomm Adreno 508 (Open-source Mesa Freedreno) |
| **Memory** | 3GB / 4GB LPDDR4 |
| **Storage** | 32GB / 64GB eMMC 5.1 |
| **Display** | 1080 x 1920 IPS LCD (420 dpi) |
| **Partition Scheme** | A/B (System-as-root, non-dynamic) |

## Partition Layout

* **boot**: 64 MB (`/dev/block/by-name/boot_{a,b}`)
* **system**: ~3.0 GB (`/dev/block/by-name/system_{a,b}`)
* **vendor**: 1.0 GB (`/dev/block/by-name/vendor_{a,b}`)
* **metadata**: Repurposed `logdump` partition (`/dev/block/by-name/logdump`)
* **userdata**: Remaining disk (`/dev/block/by-name/userdata`)

## Bringup Stages

This tree starts at **Stage 1 (Skeleton)** with `TARGET_INITIAL_BRINGUP := true`.

1. **Stage 1:** Skeleton compiles cleanly under AOSP / LineageOS build system.
2. **Stage 2:** Mainline kernel boots (serial log or early display via simplefb/drm).
3. **Stage 3:** First-stage init mounts `/system`, `/vendor`, and `/metadata`.
4. **Stage 4:** USB ADB shell or serial root shell access achieved.
5. **Stage 5:** Display boot animation via software rendering / Freedreno.
6. **Stage 6:** Peripherals enabled (touchscreen, Wi-Fi, audio).
7. **Stage 7:** SELinux transitioned from permissive to enforcing.
8. **Stage 8:** `TARGET_INITIAL_BRINGUP` removed; production ready.
