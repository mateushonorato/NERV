SKIPUNZIP=1

if $TARGET_FS_CHANGED; then
    LOG "- Copying patched fstab to /vendor/etc"
    cp -f "$SRC_DIR/target/$TARGET_CODENAME/patches/filesystem/vendor/etc/fstab.qcom" "$WORK_DIR/vendor/etc"
else
    LOG "- TARGET_OS_FILE_SYSTEM is set to its default value. Ignoring"
fi
