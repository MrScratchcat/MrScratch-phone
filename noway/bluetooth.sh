#!/bin/bash

echo -e "Powering Bluetooth on...\n"
echo "power on" | bluetoothctl

echo -e "Scanning for devices (this will take 10 seconds)...\n"
echo "scan on" | bluetoothctl
sleep 10 # Adjust this duration if needed
echo "scan off" | bluetoothctl

echo -e "\nDevices available:"
DEVICE_LIST=$(echo "devices" | bluetoothctl)
echo "$DEVICE_LIST"

# Extract device names and MAC addresses, then present a choice to the user
echo "Please select a device to connect to by entering the corresponding number:"

IFS=$'\n' # Internal Field Separator set to newline for correct splitting
DEVICE_ARRAY=($(echo "$DEVICE_LIST" | grep 'Device' | awk '{print $2 " " substr($0, index($0,$3))}'))
for i in "${!DEVICE_ARRAY[@]}"; do
    echo "$((i+1))) ${DEVICE_ARRAY[$i]}"
done

read -p "Enter number: " CHOICE
CHOICE=$((CHOICE-1)) # Adjust choice to match array index

if [ $CHOICE -lt 0 ] || [ $CHOICE -ge ${#DEVICE_ARRAY[@]} ]; then
    echo "Invalid selection. Exiting."
    exit 1
fi

SELECTED_DEVICE=${DEVICE_ARRAY[$CHOICE]}
DEVICE_MAC=$(echo $SELECTED_DEVICE | awk '{print $1}')

echo -e "\nConnecting to $SELECTED_DEVICE...\n"
echo "connect $DEVICE_MAC" | bluetoothctl

# Optional: Verify connection status
echo "info $DEVICE_MAC" | bluetoothctl | grep "Connected" | grep "yes"

if [ $? -eq 0 ]; then
    echo "Successfully connected."
else
    echo "Failed to connect. Please try again."
fi
