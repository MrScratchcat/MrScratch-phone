#!/bin/bash

# Function to extract calibration values
extract_calibration() {
    while IFS= read -r line; do
        if [[ $line == Option* ]]; then
            key=$(echo $line | cut -d '"' -f 2)
            value=$(echo $line | cut -d '"' -f 4)
            echo "\tOption \"$key\" \"$value\"" >> "$CONFIG_FILE"
        fi
    done <<< "$1"
}

# Install xinput_calibrator if not already installed
if ! command -v xinput_calibrator >/dev/null 2>&1; then
    echo "xinput_calibrator not found. Installing..."
    sudo apt-get install -y xinput-calibrator
fi

# Allow user to specify a device
echo "Available input devices:"
xinput --list --short | grep touch
echo "Please enter the device name (or partial name) to calibrate, or press enter to calibrate the last device found:"
read DEVICE_NAME

# Run the calibration tool
if [ -z "$DEVICE_NAME" ]; then
    CALIBRATION_OUTPUT=$(DISPLAY=:0.0 xinput_calibrator)
else
    CALIBRATION_OUTPUT=$(DISPLAY=:0.0 xinput_calibrator --device "$DEVICE_NAME")
fi

# Check if calibration was successful
if echo "$CALIBRATION_OUTPUT" | grep -q 'Calibrating EVDEV driver'; then
    # Prepare the configuration file
    CONFIG_FILE="/usr/share/X11/xorg.conf.d/99-calibration.conf"
    sudo cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
    echo "Section \"InputClass\"" | sudo tee "$CONFIG_FILE"
    echo -e "\tIdentifier\t\"calibration\"" | sudo tee -a "$CONFIG_FILE"
    extract_calibration "$CALIBRATION_OUTPUT"
    echo "EndSection" | sudo tee -a "$CONFIG_FILE"

    echo "Calibration data added to $CONFIG_FILE. A backup of the original file has been created at ${CONFIG_FILE}.backup."
    echo "Please reboot your Raspberry Pi to apply the changes."
else
    echo "Calibration failed. Please ensure the correct device is selected and try again."
fi
