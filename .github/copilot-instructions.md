# NERV/UN1CA Copilot Instructions

NERV is a Samsung Galaxy custom firmware build system forked from UN1CA, targeting One UI 7. It automates firmware download, extraction, patching, and flashable zip generation for specific Samsung devices.

## Core Architecture

### Single System Image (SSI) Types
- **qssi** (Qualcomm SSI): Most Snapdragon devices (`TARGET_SINGLE_SYSTEM_IMAGE="qssi"`)
- **essi** (Exynos SSI): Exynos devices like a51, a53x (`TARGET_SINGLE_SYSTEM_IMAGE="essi"`)

SSI type determines source firmware, debloat rules, and patch applicability. Always check device's `target/{codename}/config.sh` for SSI type.

### Build Environment Setup
```bash
# Always source buildenv.sh first with target device
source buildenv.sh a73xq  # Creates SRC_DIR, OUT_DIR, WORK_DIR, etc.
```

### Key Directory Structure
- `target/{codename}/` - Device-specific configs (config.sh, sff.sh)
- `unica/mods/` - Modular features (module.prop + customize.sh)
- `unica/patches/` - System-wide patches organized by category  
- `unica/configs/` - SSI-specific source configs (qssi.sh, essi.sh)
- `scripts/` - Build pipeline scripts with `unica` alias
- `external/` - Build tools (apktool, android-tools, etc.)

## Essential Workflows

### Complete Build Process
```bash
# 1. Setup environment
source buildenv.sh {device_codename}

# 2. Build dependencies once
unica build_dependencies

# 3. Download firmware 
unica download_fw

# 4. Extract firmware
unica extract_fw

# 5. Build ROM with patches/mods applied
unica make_rom
```

### Development Commands
- `unica cleanup` - Clean work directories
- `unica print_modules_info` - List available mods
- `unica apktool` - Decode/build APKs manually

## Configuration System

### Device Config Pattern (`target/{codename}/config.sh`)
```bash
TARGET_FIRMWARE="SM-A736B/TUR/352828291234563"  # Firmware string
TARGET_SINGLE_SYSTEM_IMAGE="qssi"  # or "essi"
TARGET_API_LEVEL=35                # Android API
TARGET_HAS_MASS_CAMERA_APP=true    # Feature flags
```

### Source/Target Mapping
- Source configs (`unica/configs/{qssi,essi}.sh`) define flagship donor firmware
- Device configs override with device-specific values
- Build system maps SOURCE_* → TARGET_* during patching

## Module System

### Module Structure (`unica/mods/{name}/`)
```bash
module.prop          # Metadata (id, name, author, description)
customize.sh         # Install logic using helper functions
{qssi,essi}/        # SSI-specific files (optional)
```

### Module Helper Functions
- `ADD_TO_WORK_DIR` - Copy files with permissions
- `SET_FLOATING_FEATURE_CONFIG` - Modify Samsung feature flags
- `DECODE_APK`/`BUILD_APK` - APK manipulation

## Patching System

### Smali Patches
Located in `unica/mods/{name}/{ssi}/smali/` with `.patch` files:
- Applied to decompiled APKs during build
- Use standard git patch format
- Target specific APK paths like `system_ext/priv-app/SystemUI/SystemUI.apk/`

### Config File Patterns
- Feature flags: `SEC_FLOATING_FEATURE_*` in device `sff.sh`
- Product features: `TARGET_*` device-specific overrides
- Build props: Modified through various patch categories

## Critical Build Dependencies

Samsung firmware modding requires specific tools built in sequence:
1. **android-tools** - Platform tools (adb, fastboot, etc.)
2. **apktool** - APK decompilation/recompilation  
3. **erofs-utils** - Samsung EROFS filesystem handling
4. **signapk** - APK signing with platform keys

All external tools built via `external/make.sh` with version pinning.

## Device-Specific Considerations

- Check `TARGET_HAS_SYSTEM_EXT` for partition layout
- Verify `TARGET_OS_FILE_SYSTEM` (erofs/ext4) for image building
- Review `TARGET_SUPER_*_SIZE` for partition constraints
- Validate Samsung Product Features match device capabilities

## Device-Specific Patches

### Patch Categories by Device Type

Each device in `target/{codename}/patches/` contains specific fixes:

#### Camera Patches (`camera/`)
- **Purpose**: Fix camera functionality when porting from source firmware
- **Common patterns**:
  ```bash
  # Remove incompatible newer camera libs
  DELETE_FROM_WORK_DIR "system" "system/lib64/libAiSolution_wrapper_v1.camera.samsung.so"
  
  # Add stock camera libs from target firmware  
  ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
  
  # Fix AI Photo Editor paths
  sed -i 's/single_bokeh_feature.json/unica_bokeh_feature.json/g' "$WORK_DIR/system/..."
  ```
- **Device variations**:
  - **r8q**: Extensive camera blob replacement, AI Photo Editor fixes
  - **a73xq**: MIDAS model detection fixes, camera-feature.xml editing
  - **m52xq/a52sxq**: Similar blob patterns but different lib versions

#### WPSS Patches (`wpss/`)
- **Purpose**: WiFi processor subsystem firmware fixes for Snapdragon devices
- **Pattern**: Add device-specific WPSS firmware blobs and SELinux rules
- **Example**:
  ```bash
  # Allow init to mount firmware files
  ADD_SELINUX_ENTRY "vendor" "etc/selinux/vendor_sepolicy.cil" \
    "(allow init_30_0 vendor_firmware_file (file (mounton)))"
  ```

#### Kernel Patches (`kernel/`)
- **Purpose**: Boot image modifications for older devices (a51, r8q)
- **Contains**: Custom boot.img with compatible kernel/ramdisk

#### Vendor Patches (`vendor/`)
- **Purpose**: Vendor partition fixes for hardware compatibility
- **Common fixes**:
  ```bash
  # Fix MIDAS model detection (GPU performance)
  sed -i "s/ro.product.device/ro.product.vendor.device/g" \
    "$WORK_DIR/vendor/etc/midas/midas_config.json"
  
  # Remove DualDAR mount points (encryption conflicts)
  sed -i "/keydata/d" "$WORK_DIR/vendor/etc/fstab.qcom"
  
  # NFC hardware compatibility
  echo "on property:ro.boot.em.model=SM-G781B" >> init.nfc.samsung.rc
  ```

#### Filesystem Patches (`filesystem/`)
- **Purpose**: Change filesystem types (ext4 ↔ erofs) when `TARGET_FS_CHANGED=true`
- **Example (r9q)**: Rename fstab files for vendor_boot compatibility

#### Performance Tweaks (`tweaks/`)
- **Purpose**: CPU scheduler optimizations for Snapdragon devices
- **Pattern**:
  ```bash
  # Modify CPU affinity for better performance
  sed -i "LINE cecho 0-1 > /dev/cpuset/background/cpus" \
    "$WORK_DIR/vendor/bin/init.kernel.post_boot-yupik.sh"
  ```

#### Stock Blobs (`stock_blobs/`)
- **Purpose**: Replace problematic ported blobs with device-original versions
- **Critical for**: Hardware-specific drivers, firmware compatibility

### Device-Specific Debloat Patterns

Each device's `debloat.sh` removes incompatible system components:

```bash
# Qualcomm-specific removals for qssi devices
SYSTEM_EXT_DEBLOAT+="
app/QCC                    # Qualcomm car connectivity
priv-app/com.qualcomm.location  # Location services
"

# Remove newer camera SDK when unsupported
SYSTEM_DEBLOAT+="
system/priv-app/PhotoRemasterService  # AI photo features
system/framework/scamera_sep.jar      # Samsung camera SDK
"

# Device-specific GameDriver removal
SYSTEM_DEBLOAT+="
system/priv-app/GameDriver-SM8550  # Wrong SoC driver
"
```

### Overlay Structure (`overlay/`)
Contains device-specific resource overlays for proper hardware mapping.

## Common Debugging

- Build logs in `out/` with timestamped files
- APK decode issues: Check apktool compatibility  
- Module conflicts: Review module.prop dependencies
- Patch failures: Verify source firmware matches expected structure
- **Camera issues**: Check if camera patches applied correctly, compare blob versions
- **WiFi problems**: Verify WPSS patches and SELinux rules for Snapdragon devices
- **Boot failures**: Examine kernel patches and filesystem compatibility
- **Performance issues**: Review MIDAS config and CPU tweaks

When working with device configs, always validate against actual device properties and firmware structure before building.