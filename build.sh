#!/bin/sh
# Builds counter.app next to this script.
# Needs the Xcode Command Line Tools: xcode-select --install
set -e
cd "$(dirname "$0")"

APP="counter.app/Contents"
mkdir -p "$APP/MacOS"

swiftc -O counter.swift -o "$APP/MacOS/counter"

cat > "$APP/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>counter</string>
    <key>CFBundleIdentifier</key><string>local.counter</string>
    <key>CFBundleExecutable</key><string>counter</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>LSUIElement</key><true/>
</dict>
</plist>
EOF

echo "Built counter.app. Run it with: open counter.app"
