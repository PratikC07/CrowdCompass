from flask import Flask, render_template, jsonify
import asyncio
import threading
from bleak import BleakScanner
import time

app = Flask(__name__, template_folder="templates")  # Ensure Flask looks for templates

devices = {}  # Dictionary to store devices with RSSI history
RSSI_HISTORY_LIMIT = 5  # Store last 5 RSSI values per device

def start_scan_loop():
    """Runs BLE scanning in a separate thread."""
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    loop.run_until_complete(scan_bluetooth())

async def scan_bluetooth():
    """Continuously scans for BLE devices."""
    global devices
    print("🚀 Bluetooth scanning started...")

    def callback(device, advertisement_data):
        """Process discovered devices."""
        address = device.address
        rssi = advertisement_data.rssi

        if address not in devices:
            devices[address] = {
                "name": device.name or "Unknown",
                "address": address,
                "rssi_history": [rssi],  # Store RSSI values
                "last_seen": time.time(),
            }
        else:
            devices[address]["rssi_history"].append(rssi)
            if len(devices[address]["rssi_history"]) > RSSI_HISTORY_LIMIT:
                devices[address]["rssi_history"].pop(0)  # Keep last N readings

            devices[address]["last_seen"] = time.time()

        # Calculate smoothed RSSI
        avg_rssi = sum(devices[address]["rssi_history"]) / len(devices[address]["rssi_history"])
        devices[address]["smoothed_rssi"] = round(avg_rssi, 2)
        devices[address]["estimated_distance"] = f"{calculate_distance(avg_rssi)} meters"

    scanner = BleakScanner(callback)

    while True:
        await scanner.start()
        await asyncio.sleep(5)  # Scan every 5 seconds
        await scanner.stop()

        # Remove inactive devices (Not seen in last 10 seconds)
        current_time = time.time()
        inactive_devices = [addr for addr, data in devices.items() if current_time - data["last_seen"] > 10]
        for addr in inactive_devices:
            del devices[addr]

def calculate_distance(rssi, tx_power=-59):
    """Estimate distance based on RSSI."""
    if rssi == 0:
        return "Unknown"
    return round(10 ** ((tx_power - rssi) / (10 * 2)), 2)

@app.route('/')
def home():
    return render_template('index.html')  # Serve the HTML page

@app.route('/scan')
def get_scanned_devices():

    print("Devices---",devices.values())
    """Returns a stable list of devices."""
    return jsonify(list(devices.values()))  # Convert dict to list for JSON response

if __name__ == '__main__':
    scanner_thread = threading.Thread(target=start_scan_loop, daemon=True)
    scanner_thread.start()
    app.run(debug=True, host='0.0.0.0', port=5001)