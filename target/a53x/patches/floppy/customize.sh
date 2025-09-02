FLOPPY_TAR=$(curl -s https://api.github.com/repos/FlopKernel-Series/flop_s5e8825_kernel/releases/latest \
    | jq -r 'del(.body) | .assets[] | select(.name | test("OneUI.*Vanilla-exynos1280.*\\.tar$")) | .browser_download_url')

[[ -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

DOWNLOAD_FILE "$FLOPPY_TAR" "$TMP_DIR/$(basename $FLOPPY_TAR)"

LOG "- Extracting kernel binaries"
EVAL "tar xvf \"$TMP_DIR/$(basename $FLOPPY_TAR)\" -C \"$TMP_DIR\""
EVAL "lz4 -d \"$TMP_DIR/boot.img.lz4\" \"$TMP_DIR/boot.img\""
EVAL "lz4 -d \"$TMP_DIR/vendor_boot.img.lz4\" \"$TMP_DIR/vendor_boot.img\""

LOG "- Replacing kernel binaries"
[[ -f "$WORK_DIR/kernel/boot.img" ]] && rm -f "$WORK_DIR/kernel/boot.img"
[[ -f "$WORK_DIR/kernel/boot.img" ]] && rm -f "$WORK_DIR/kernel/vendor_boot.img"
EVAL "mv -f \"$TMP_DIR/boot.img\" \"$TMP_DIR/vendor_boot.img\" \"$WORK_DIR/kernel\"" || exit 1

rm -rf "$TMP_DIR"
