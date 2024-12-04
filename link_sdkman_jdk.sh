#!/bin/bash

SYSTEM_JDK_PATH="/Library/Java/JavaVirtualMachines/sdkman-java-current"
SDKMAN_DIR="$(brew --prefix sdkman-cli)/libexec"
SDKMAN_JAVA_PATH="$SDKMAN_DIR/candidates/java/current"

# Check if the expected directory exists
if [ ! -d "$SDKMAN_JAVA_PATH" ]; then
    echo "Error: SDKMAN Java directory '$SDKMAN_JAVA_PATH' does not exist. Exiting."
    exit 1
fi

SDKMAN_JAVA_HOME_PATH="$SDKMAN_JAVA_PATH/$(ls "$SDKMAN_JAVA_PATH/" | grep ".jdk" | head -n 1)/Contents"
# Check if the expected directory exists
if [ ! -d "$SDKMAN_JAVA_HOME_PATH" ]; then
    echo "Error: SDKMAN Java Home directory '$SDKMAN_JAVA_HOME_PATH' does not exist. Exiting."
    exit 1
fi

echo "About to overwrite $SYSTEM_JDK_PATH and link to current global JDK via SDKMAN"
echo ""
echo "⚠️ WARNING ⚠️"
echo "This way of linking against the current JDK is fragile. If you change the current JDK in SDKMAN you should rerun this script to link the system against the new current JDK version."
echo "Please type 'yes' if you understand:"

read -r user_input
if [[ "$user_input" != "yes" ]]; then
    exit 0
fi

sudo rm -rf "$SYSTEM_JDK_PATH/Contents"
sudo mkdir -p "$SYSTEM_JDK_PATH/Contents"
sudo ln -s "$SDKMAN_JAVA_PATH" "$SYSTEM_JDK_PATH/Contents/Home"
sudo ln -s "$SDKMAN_JAVA_HOME_PATH/Info.plist" "$SYSTEM_JDK_PATH/Contents/Info.plist"
sudo ln -s "$SDKMAN_JAVA_HOME_PATH/MacOS" "$SYSTEM_JDK_PATH/Contents/MacOS"

# Generate the Info.plist file
cat <<EOF | envsubst > Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>English</string>
        <key>CFBundleExecutable</key>
        <string>libjli.dylib</string>
        <key>CFBundleGetInfoString</key>
        <string>SDKMAN JDK Latest Version</string>
        <key>CFBundleIdentifier</key>
        <string>sdkman.jdk</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>7.0</string>
        <key>CFBundleName</key>
        <string>SDKMAN JDK Latest Version</string>
        <key>CFBundlePackageType</key>
        <string>BNDL</string>
        <key>CFBundleShortVersionString</key>
        <string>Latest Version</string>
        <key>CFBundleSignature</key>
        <string>????</string>
        <key>CFBundleVersion</key>
        <string>9.70</string>
        <key>NSMicrophoneUsageDescription</key>
        <string>The application is requesting access to the microphone.</string>
        <key>JavaVM</key>
        <dict>
                <key>JVMCapabilities</key>
                <array>
                        <string>CommandLine</string>
                </array>
                <key>JVMMinimumFrameworkVersion</key>
                <string>13.2.9</string>
                <key>JVMMinimumSystemVersion</key>
                <string>11.00.00</string>
                <key>JVMPlatformVersion</key>
                <string>9999</string>
                <key>JVMVendor</key>
                <string>Oracle Corporation</string>
                <key>JVMVersion</key>
                <string>9999</string>
        </dict>
</dict>
</plist>
EOF

# Move the Info.plist to the system directory
sudo mv Info.plist "$SYSTEM_JDK_PATH/Contents/Info.plist"

echo "Successfully linked system libexec/java_home with SDKMAN installed JDK."
