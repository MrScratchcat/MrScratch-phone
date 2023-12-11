#!/bin/bash

# Update and Upgrade the Pi
echo "Updating and upgrading your Raspberry Pi. This might take a while..."
sudo apt-get update && sudo apt-get upgrade -y

# Install xinput_calibrator
echo "Installing xinput_calibrator..."
sudo apt-get install -y xinput-calibrator

# Run Calibration
echo "Starting calibration..."
DISPLAY=:0.0 xinput_calibrator

echo "Calibration complete. Please add the displayed calibration data to your /usr/share/X11/xorg.conf.d/99-calibration.conf file."
