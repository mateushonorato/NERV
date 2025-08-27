if [ "$TARGET_SINGLE_SYSTEM_IMAGE" == "self" ]; then
    return 0
fi

SOURCE_FIRMWARE_PATH="$FW_DIR/$(echo -n "$SOURCE_FIRMWARE" | sed 's./._.g' | rev | cut -d "_" -f2- | rev)"

if [[ -d "$SRC_DIR/target/$TARGET_CODENAME/overlay" ]]; then
    SOURCE="$(GET_PROP "$SOURCE_FIRMWARE_PATH/system/system/build.prop" "ro.product.system.name")"
    RRO_APK="framework-res__${SOURCE}__auto_generated_rro_product.apk"

    DECODE_APK "product" "overlay/$RRO_APK"

    LOG "- Applying stock overlay configs"
    rm -rf "$APKTOOL_DIR/product/overlay/$RRO_APK/res"
    cp -a --preserve=all \
        "$SRC_DIR/target/$TARGET_CODENAME/overlay" \
        "$APKTOOL_DIR/product/overlay/$RRO_APK/res"
fi
