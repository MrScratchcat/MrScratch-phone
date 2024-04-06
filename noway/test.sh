#!/bin/bash

# Continuously check for the Sway process
while true; do
    if pgrep -x "sway" >/dev/null; then
        # If Sway is found, execute Waybar
        waybar
        # Exit the loop
        break
    else
        # If Sway is not found, wait for 5 seconds before checking again
        sleep 5
    fi
done
