#!/bin/bash

SYSTEM_JDK_PATH="/Library/Java/JavaVirtualMachines/sdkman-java-current"
SDKMAN_DIR="$(brew --prefix sdkman-cli)/libexec"
SDKMAN_JAVA_PATH="$SDKMAN_DIR/candidates/java/current"

# Check if the expected directory exists
if [ ! -d "$SDKMAN_JAVA_PATH" ]; then
    echo "Error: SDKMAN Java directory '$SDKMAN_JAVA_PATH' does not exist. Exiting."
    exit 1
fi

echo "About to overwrite $SYSTEM_JDK_PATH and link to current global JDK via SDKMAN"
sudo rm -rf "$SYSTEM_JDK_PATH/Contents"
sudo mkdir -p "$SYSTEM_JDK_PATH/Contents"
sudo ln -s "$SDKMAN_JAVA_PATH" "$SYSTEM_JDK_PATH/Contents/Home"

# Generate the Info.plist file
cat <<EOF | envsubst > Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>sdkman.java.jdk</string>
    <key>CFBundleName</key>
    <string>SDKMAN Current JDK</string>
    <key>JavaVM</key>
    <dict>
        <key>JVMPlatformVersion</key>
        <string>9999</string>
        <key>JVMVendor</key>
        <string>SDKMAN</string>
        <key>JVMVersion</key>
        <string>9999</string>
    </dict>
</dict>
</plist>
EOF

# Move the Info.plist to the system directory
sudo mv Info.plist "$SYSTEM_JDK_PATH/Contents/Info.plist"

echo "Successfully linked system libexec/java_home with SDKMAN installed JDK."
