import subprocess
import tkinter as tk
from tkinter import ttk, messagebox

def scan_devices():
    # Clear current device list
    devices_listbox.delete(0, tk.END)
    scanned_devices = subprocess.check_output("echo scan on | bluetoothctl | grep Device", shell=True, text=True, timeout=15)
    devices = scanned_devices.split('\n')
    for device in devices:
        if "Device" in device:
            mac_address = device.split()[1]
            name = ' '.join(device.split()[2:])
            devices_listbox.insert(tk.END, f"{name} ({mac_address})")

def connect_to_device():
    selection = devices_listbox.curselection()
    if not selection:
        messagebox.showinfo("Selection Required", "Please select a device from the list to connect.")
        return
    selected_device = devices_listbox.get(selection[0])
    mac_address = selected_device.split('(')[-1].strip(')')
    try:
        subprocess.run(f"echo 'connect {mac_address}' | bluetoothctl", shell=True, check=True)
        messagebox.showinfo("Connected", f"Successfully connected to {selected_device}")
    except subprocess.CalledProcessError:
        messagebox.showerror("Connection Failed", f"Could not connect to {selected_device}")

# Setup the GUI
root = tk.Tk()
root.title("Bluetooth Connector")

# Listbox for displaying devices
devices_listbox = tk.Listbox(root, width=60, height=15)
devices_listbox.pack(pady=20)

# Buttons
scan_button = ttk.Button(root, text="Scan for Devices", command=scan_devices)
scan_button.pack(pady=5)

connect_button = ttk.Button(root, text="Connect to Selected Device", command=connect_to_device)
connect_button.pack(pady=5)

root.mainloop()
