#!/bin/bash
cd
sudo apt update && sudo apt upgrade -y && sudo apt install -y sway* git gdm3 gnome-disk-utility waybar gnome-terminal xterm bluez-tools
wget https://raw.githubusercontent.com/MrScratchcat/custom-linux-commands/main/os-update && bash os-update

if [ "$(pgrep -x sway)" ]; then
    echo "Sway is running. Continuing..."
else
    echo "Sway is not running. Exiting..."
    exit 1
fi
mkdir -p ~/.config/sway

cat <<EOF | sudo tee "$HOME/.config/waybar/config" >/dev/null
{
    "modules-left": ["battery"],
    "modules-center": [
        "cpu",
        "custom/brightness"
    ],
    "modules-right": [
        "custom/bluetooth",
        "pulseaudio",
        "custom/wifi"
    ],
    "cpu": {
        "format": "{usage}% CPU",
        "interval": 1
    },
    "pulseaudio": {
        "format": "🔊 {volume}%",
        "format-muted": "🔇",
        "on-click": "pavucontrol"
    },
    "battery": {
        "bat": "BAT0",
        "adapter": "ADP1",
        "format": "{capacity}% 🔋",
        "format-discharging": "{capacity}% 🔋",
        "format-charging": "{capacity}% 🔋⚡",
        "format-full": "{capacity}% 🔋",
        "interval": 30
    },
    "custom/wifi": {
        "exec": "echo 🌐",
        "interval": 10,
        "on-click": "gnome-terminal -- xterm nmtui ",
        "format": "{}"
    },
    "custom/bluetooth": {
        "exec": "echo ",
        "interval": 10,
        "on-click": "~/.config/waybar/bluetooth_toggle.sh",
        "format": "{}"
    },
    "custom/brightness": {
        "exec": "sudo brightnessctl g | xargs -I{} echo ' {}%'",
        "interval": 1,
        "on-scroll-up": "sudo brightnessctl set +5%",
        "on-scroll-down": "sudo brightnessctl set 5%-",
        "format": "{}"
    }
}

EOF


cat <<EOF | sudo tee "/usr/local/bin/waybar.sh" >/dev/null

#!/bin/bash
waybar &

EOF


cat <<EOF | sudo tee "/etc/systemd/system/waybar.service" >/dev/null

[Unit]
Description=Start Waybar on startup
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash /usr/local/bin/waybar.sh
Restart=always
RestartSec=1s

[Install]
WantedBy=graphical.target

EOF

sudo chmod +x /usr/local/bin/waybar.sh
sudo chmod +x /etc/systemd/system/waybar.service
sudo systemctl daemon-reload
systemctl enable waybar.service
systemctl start waybar.service
sudo apt install curl ca-certificates -y && curl https://repo.waydro.id | sudo bash && sudo apt install waydroid -y && sudo waydroid init -s GAPPS -f
sudo systemctl enable waydroid-container.service
sudo systemctl enable bluetooth.service
