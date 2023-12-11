#!/bin/bash

# Install xinput_calibrator if not already installed
if ! command -v xinput_calibrator >/dev/null 2>&1; then
    echo "xinput_calibrator not found. Installing..."
    sudo apt-get install -y xinput-calibrator
fi

# Run the calibration tool and capture the output
CALIBRATION_DATA=$(DISPLAY=:0.0 xinput_calibrator | tee /dev/tty | grep 'Calibrating EVDEV driver for' -A 6)

# Extract calibration values
CALIBRATION_VALUES=$(echo "$CALIBRATION_DATA" | grep 'Option "Calibration"' | cut -d '"' -f 4)

# Check if calibration values were found
if [ -z "$CALIBRATION_VALUES" ]; then
    echo "Calibration failed or calibration values not found."
    exit 1
fi

# Prepare the configuration string
CONFIG_STR="Section \"InputClass\"\n\tIdentifier \"calibration\"\n\tMatchProduct \"$(echo "$CALIBRATION_DATA" | grep 'Calibrating EVDEV driver for' | cut -d '"' -f 4)\"\n\tOption \"Calibration\" \"$CALIBRATION_VALUES\"\n\tOption \"SwapAxes\" \"0\"\nEndSection"

# Backup the existing configuration file
CONFIG_FILE="/usr/share/X11/xorg.conf.d/99-calibration.conf"
sudo cp "$CONFIG_FILE" "$CONFIG_FILE.backup"

# Write new calibration data to the configuration file
echo -e "$CONFIG_STR" | sudo tee "$CONFIG_FILE"

echo "Calibration data added to $CONFIG_FILE. A backup of the original file has been created at ${CONFIG_FILE}.backup."

# Notify the user to reboot
echo "Please reboot your Raspberry Pi to apply the changes."

