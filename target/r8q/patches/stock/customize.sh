LOG_STEP_IN "- Fixing Google Assistant"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentOKGoogleEx4HEXAGON"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentXGoogleEx4HEXAGON"
ADD_TO_WORK_DIR "a73xqxx" "product" "priv-app/HotwordEnrollmentOKGoogleEx3HEXAGON" 0 0 755 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "a73xqxx" "product" "priv-app/HotwordEnrollmentXGoogleEx3HEXAGON" 0 0 755 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Fixing auto brightness [Light HAL from r9qxxx]"
ADD_TO_WORK_DIR "r9qxxx" "vendor" "bin/hw/vendor.samsung.hardware.light-service"
ADD_TO_WORK_DIR "r9qxxx" "vendor" "lib64/vendor.samsung.hardware.light-V1-ndk_platform.so"
LOG_STEP_OUT

LOG_STEP_IN "- Add stock ev_lux_map_config.xml"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/ev_lux_map_config.xml" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding stock system features"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.sec.feature.cover.clearcameraviewcover.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.sec.feature.cover.flip.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.sec.feature.pocketsensitivitymode_level1.xml"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.cover.clearsideviewcover.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/com.sec.feature.pocketmode_level33.xml" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding stock GameDriver"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/GameDriver-SM8250/GameDriver-SM8250.apk" 0 0 644 "u:object_r:system_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding stock WFD blobs"
DELETE_FROM_WORK_DIR "system" "system/lib64/libhdcp_client_aidl.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libhdcp2.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libremotedisplay_wfd.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libremotedisplayservice.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsecuibc.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libstagefright_hdcp.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/wfd_log.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.hdcp.wifidisplay-V2-ndk.so"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/bin/insthk" 0 2000 755 "u:object_r:insthk_exec:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/bin/remotedisplay" 0 2000 755 "u:object_r:remotedisplay_exec:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib/libhdcp2.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib/libremotedisplay_wfd.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib/libremotedisplayservice.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib/libsecuibc.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "system" "system/lib/libstagefright_hdcp.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "a52qnsxx" "vendor" "bin/hw/wpa_supplicant" 0 2000 755 "u:object_r:hal_wifi_supplicant_default_exec:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Fix face unlock"
DELETE_FROM_WORK_DIR "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@2.0-service"
DELETE_FROM_WORK_DIR "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@2.0-service.rc"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "bin/hw/vendor.samsung.hardware.biometrics.face@3.0-service"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "etc/init/vendor.samsung.hardware.biometrics.face@3.0-service.rc"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib/vendor.samsung.hardware.biometrics.face@2.0.so"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib/vendor.samsung.hardware.biometrics.face@3.0.so"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib64/vendor.samsung.hardware.biometrics.face@2.0.so"
ADD_TO_WORK_DIR "a73xqxx" "vendor" "lib64/vendor.samsung.hardware.biometrics.face@3.0.so"
LOG_STEP_OUT

LOG_STEP_IN "- Adding a73xqxx libhwui"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib/libhwui.so"
ADD_TO_WORK_DIR "a73xqxx" "system" "system/lib64/libhwui.so"
LOG_STEP_OUT

LOG_STEP_IN "- Fixing Vibrator"
DELETE_FROM_WORK_DIR "vendor" "bin/hw/vendor.samsung.hardware.vibrator@2.2-service"
DELETE_FROM_WORK_DIR "vendor" "etc/init/vendor.samsung.hardware.vibrator@2.2-service.rc"
DELETE_FROM_WORK_DIR "vendor" "lib64/vendor.samsung.hardware.vibrator@2.0.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/vendor.samsung.hardware.vibrator@2.1.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/vendor.samsung.hardware.vibrator@2.2.so"
ADD_TO_WORK_DIR "r9qxxx" "vendor" "bin/hw/vendor.samsung.hardware.vibrator-service"
ADD_TO_WORK_DIR "r9qxxx" "vendor" "etc/init/vendor.samsung.hardware.vibrator-default.rc"
ADD_TO_WORK_DIR "r9qxxx" "vendor" "etc/vintf/manifest/vendor.samsung.hardware.vibrator-default.xml"
ADD_TO_WORK_DIR "r9qxxx" "vendor" "lib64/vendor.samsung.hardware.vibrator-V3-ndk_platform.so"
LOG_STEP_OUT

LOG_STEP_IN "- Fixing NFC for G781B"
if ! grep -q "G781B" "$WORK_DIR/vendor/etc/init/init.nfc.samsung.rc"; then
    {
        echo ""
        echo "on property:ro.boot.em.model=SM-G781B"
        echo "    setprop ro.boot.product.hardware.sku \"s3fwrn5\""
        echo "    setprop ro.vendor.nfc.feature.chipname \"SLSI\""
        echo ""
        echo "on property:ro.boot.em.model=SM-G7810"
        echo "    setprop ro.boot.product.hardware.sku \"s3fwrn5\""
        echo "    setprop ro.vendor.nfc.feature.chipname \"SLSI\""
        echo ""
        echo "on property:ro.boot.em.model=SM-G781N"
        echo "    setprop ro.boot.product.hardware.sku \"s3fwrn5\""
        echo "    setprop ro.vendor.nfc.feature.chipname \"SLSI\""
    } >> "$WORK_DIR/vendor/etc/init/init.nfc.samsung.rc"
fi
LOG_STEP_OUT
