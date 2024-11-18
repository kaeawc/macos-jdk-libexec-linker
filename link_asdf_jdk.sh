#!/bin/bash

# Check if asdf is installed
if ! command -v asdf &> /dev/null; then
    echo "Error: asdf is not installed. Please install asdf to proceed."
    exit 1
fi

# Check if a JDK is installed via asdf
SELECTED_JDK=$(asdf list java | grep '^ \*' | tr '*' ' ' | awk '{print $1}')
if [ -z "$SELECTED_JDK" ]; then
    echo "Error: No JDK is installed via asdf. Please install a JDK using 'asdf install java <version>' to proceed."
    exit 1
fi

# Extract JDK vendor and version
JDK_VENDOR=$(echo "$SELECTED_JDK" | tr '-' ' ' | awk '{print $1}')
JDK_VERSION=$(echo "$SELECTED_JDK" | tr '-' ' ' | awk '{print $2}')

# Define the system JDK path
SYSTEM_JDK_PATH="/Library/Java/JavaVirtualMachines/asdf-java-$JDK_VERSION"

# Overwrite and link the asdf JDK to the system path
echo "About to overwrite $SYSTEM_JDK_PATH and link to the selected JDK via asdf"
sudo rm -rf "$SYSTEM_JDK_PATH/Contents"
sudo mkdir -p "$SYSTEM_JDK_PATH/Contents"
sudo ln -s "$HOME/.asdf/installs/java/$SELECTED_JDK" "$SYSTEM_JDK_PATH/Contents/Home"

# Generate the Info.plist file
cat <<EOF | envsubst > Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>asdf.java.jdk</string>
    <key>CFBundleName</key>
    <string>ASDF ${SELECTED_JDK}</string>
    <key>JavaVM</key>
    <dict>
        <key>JVMPlatformVersion</key>
        <string>${JDK_VERSION}</string>
        <key>JVMVendor</key>
        <string>${JDK_VENDOR}</string>
        <key>JVMVersion</key>
        <string>${JDK_VERSION}</string>
    </dict>
</dict>
</plist>
EOF

# Move the Info.plist file to the system path
sudo mv Info.plist "$SYSTEM_JDK_PATH/Contents/Info.plist"

echo "Successfully updated $SYSTEM_JDK_PATH with the selected JDK."