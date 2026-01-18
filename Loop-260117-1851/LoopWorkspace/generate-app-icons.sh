#!/bin/bash

# Generate all app icon sizes from a single source image
# Usage: ./generate-app-icons.sh <source-image>

SOURCE="$1"
DEST_DIR="/Users/jeffguo/Desktop/GitHub/INSU/Loop-260117-1851/LoopWorkspace/OverrideAssetsLoop.xcassets/AppIcon.appiconset"

if [ -z "$SOURCE" ]; then
    echo "Usage: $0 <source-image.png>"
    exit 1
fi

if [ ! -f "$SOURCE" ]; then
    echo "Error: Source file not found: $SOURCE"
    exit 1
fi

echo "Generating app icons from: $SOURCE"
echo "Output directory: $DEST_DIR"

# Generate all required sizes
sips -z 40 40 "$SOURCE" --out "$DEST_DIR/icon_20pt@2x.png"
sips -z 60 60 "$SOURCE" --out "$DEST_DIR/icon_20pt@3x.png"
sips -z 58 58 "$SOURCE" --out "$DEST_DIR/icon_29pt@2x.png"
sips -z 87 87 "$SOURCE" --out "$DEST_DIR/icon_29pt@3x.png"
sips -z 80 80 "$SOURCE" --out "$DEST_DIR/icon_40pt@2x.png"
sips -z 120 120 "$SOURCE" --out "$DEST_DIR/icon_40pt@3x.png"
sips -z 120 120 "$SOURCE" --out "$DEST_DIR/icon_60pt@2x.png"
sips -z 180 180 "$SOURCE" --out "$DEST_DIR/icon_60pt@3x.png"
sips -z 20 20 "$SOURCE" --out "$DEST_DIR/icon_20pt.png"
sips -z 40 40 "$SOURCE" --out "$DEST_DIR/icon_20pt@2x-1.png"
sips -z 29 29 "$SOURCE" --out "$DEST_DIR/icon_29pt.png"
sips -z 58 58 "$SOURCE" --out "$DEST_DIR/icon_29pt@2x-1.png"
sips -z 40 40 "$SOURCE" --out "$DEST_DIR/icon_40pt.png"
sips -z 80 80 "$SOURCE" --out "$DEST_DIR/icon_40pt@2x-1.png"
sips -z 76 76 "$SOURCE" --out "$DEST_DIR/icon_76pt.png"
sips -z 152 152 "$SOURCE" --out "$DEST_DIR/icon_76pt@2x.png"
sips -z 167 167 "$SOURCE" --out "$DEST_DIR/icon_83.5@2x.png"
sips -z 1024 1024 "$SOURCE" --out "$DEST_DIR/Icon.png"

echo "Done! All icons generated."
