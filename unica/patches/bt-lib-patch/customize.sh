if [ ! -f "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" ]; then
    LOG_STEP_IN "- Extracting libbluetooth_jni.so from com.android.btservices.apex"

    [ -d "$TMP_DIR" ] && EVAL "rm -rf \"$TMP_DIR\""
    mkdir -p "$TMP_DIR"

    EVAL "unzip -j \"$WORK_DIR/system/system/apex/com.android.btservices.apex\" \"apex_payload.img\" -d \"$TMP_DIR\""

    if ! sudo -n -v &> /dev/null; then
        LOG "\033[0;33m! Asking user for sudo password\033[0m"
        if ! sudo -v 2> /dev/null; then
            ABORT "Root permissions are required to unpack APEX image"
        fi
    fi

    mkdir -p "$TMP_DIR/tmp_out"
    EVAL "sudo mount -o ro \"$TMP_DIR/apex_payload.img\" \"$TMP_DIR/tmp_out\""
    EVAL "sudo cat \"$TMP_DIR/tmp_out/lib64/libbluetooth_jni.so\" > \"$WORK_DIR/system/system/lib64/libbluetooth_jni.so\""

    EVAL "sudo umount \"$TMP_DIR/tmp_out\""
    rm -rf "$TMP_DIR"

    SET_METADATA "system" "system/lib64/libbluetooth_jni.so" 0 0 644 "u:object_r:system_lib_file:s0"

    LOG_STEP_OUT
fi

# https://github.com/3arthur6/BluetoothLibraryPatcher/blob/master/hexpatch.sh#L12
if [ "$SOURCE_API_LEVEL" -eq 33 ]; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "6804003528008052" "2a00001428008052"
elif [ "$SOURCE_API_LEVEL" -eq 34 ]; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "6804003528008052" "2b00001428008052"
elif [ "$SOURCE_API_LEVEL" -eq 35 ]; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "480500352800805228" "530100142800805228"
elif [ "$SOURCE_API_LEVEL" -eq 36 ]; then
    HEX_PATCH "$WORK_DIR/system/system/lib64/libbluetooth_jni.so" \
        "00122a0140395f01086b00020054" "00122a0140395f01086bde030014"
fi
