#!/bin/bash

SYSTEM_JDK_PATH="/Library/Java/JavaVirtualMachines/homebrew-jdk-current"
HOMEBREW_JDK_DIR="$(brew --prefix openjdk)/libexec"
HOMEBREW_JDK_CONTENTS_PATH="$HOMEBREW_JDK_DIR/openjdk.jdk/Contents"

# Check if the expected directory exists
if [ ! -d "$HOMEBREW_JDK_CONTENTS_PATH" ]; then
    echo "Error: Homebrew JDK directory '$HOMEBREW_JDK_CONTENTS_PATH' does not exist. Exiting."
    exit 1
fi

echo "About to overwrite $SYSTEM_JDK_PATH and link to current global JDK via Homebrew"
sudo rm -rf "$SYSTEM_JDK_PATH"
sudo mkdir -p "$SYSTEM_JDK_PATH"
sudo ln -s "$HOMEBREW_JDK_CONTENTS_PATH" "$SYSTEM_JDK_PATH/Contents"
# sudo ln -s "$HOMEBREW_JDK_CONTENTS_PATH/Info.plist" "$SYSTEM_JDK_PATH/Contents/Info.plist"
# sudo ln -s "$HOMEBREW_JDK_CONTENTS_PATH/MacOS" "$SYSTEM_JDK_PATH/Contents/MacOS"
# sudo ln -s "$HOMEBREW_JDK_CONTENTS_PATH/Home" "$SYSTEM_JDK_PATH/Contents/Home"

echo "Successfully linked system libexec/java_home with Homebrew installed JDK."
