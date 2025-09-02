if [ "$TARGET_SINGLE_SYSTEM_IMAGE" == "self" ]; then
    return 0
fi

DECODE_APK "system" "system/priv-app/Telecom/Telecom.apk"
cp -a --preserve=all "$SRC_DIR/unica/mods/callsounds/Telecom.apk/"* "$APKTOOL_DIR/system/priv-app/Telecom/Telecom.apk"
