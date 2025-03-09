# CrowdCompass


## Bluetooth Scanner & Radar Visualizer

This project consists of two main components:
1. **Website (Backend - Flask & Python)**: Scans BLE devices and estimates their distance.
2. **App (Frontend - Flutter)**: Displays scanned devices in a radar-style UI.

## 📂 Project Structure
```
📁 Project Root
│── 📁 Website  # Backend (Flask & Bleak)
│   ├── app.py  # Flask server for BLE scanning
│   ├── templates/
│   │   ├── index.html  # Web UI to display scanned devices
│── 📁 App  # Frontend (Flutter)
│   ├── lib/
│   │   ├── main.dart  # Flutter app entry point
│   ├── pubspec.yaml  # Flutter dependencies
```

---

## 🚀 Getting Started

### 🔧 Prerequisites
Ensure you have the following installed:
- **Python 3.8+**
- **pip** (Python package manager)
- **Flutter 3.0+**
- **Android Studio / Xcode** (for running the Flutter app)

---

## 🔥 Running the Backend (Flask + BLE Scanner)

### 📌 Step 1: Install Dependencies
```sh
cd Website
pip install -r requirements.txt  # If you have a requirements.txt
pip install flask bleak
```

### 📌 Step 2: Start the Flask Server
```sh
python app.py
```
- The server will start at **http://0.0.0.0:5001**.
- This will **scan for BLE devices** and **provide an API** at `/scan`.

### 📌 Step 3: Test API (Optional)
You can test if the backend is working by visiting:
```sh
http://localhost:5001/scan
```
If BLE devices are nearby, you'll receive JSON data like:
```json
[
  {"name": "Device1", "address": "AB:CD:EF:12:34:56", "estimated_distance": "10.5 meters"},
  {"name": "Device2", "address": "12:34:56:78:90:AB", "estimated_distance": "12.8 meters"}
]
```

---

## 📱 Running the Flutter App (Radar UI)

### 📌 Step 1: Install Flutter Dependencies
```sh
cd App
flutter pub get
```

### 📌 Step 2: Update API URL
In `lib/api_service.dart`, make sure to update the API URL:
```dart
const String apiUrl = "http://YOUR_IP:5001/scan";
```
Replace `YOUR_IP` with your **local network IP** where Flask is running.

### 📌 Step 3: Run the Flutter App
```sh
flutter run
```
- The app will **fetch data** from the backend and display it in a **radar-style UI**.

---

## ❗ Important Notes
- Ensure **app.py is running before launching the Flutter app**.
- If you are testing on a **physical device**, ensure it is **connected to the same network** as the Flask server.
- For **iOS**, additional Bluetooth permissions might be needed in `Info.plist`.

---

## 🎯 Features
✅ Real-time BLE scanning using **Python & Bleak**  
✅ Distance estimation using **RSSI values**  
✅ Radar-style visualization in **Flutter**  
✅ Smooth animations & UI  

---

## 📌 Troubleshooting

### 🔹 Issue: Flutter App Not Receiving Data
✔ Check if Flask server is running (`python app.py`).  
✔ Ensure API URL is correct (`http://YOUR_IP:5001/scan`).  
✔ Try accessing `http://YOUR_IP:5001/scan` from a browser.  
✔ Restart both backend and Flutter app.  
✔ Ensure BLE is enabled on your machine.

### 🔹 Issue: No BLE Devices Found
✔ Move closer to the BLE device.  
✔ Ensure Bluetooth is enabled.  
✔ Try restarting the scanning process.

---

## 🔗 Useful Links
- Flask: [https://flask.palletsprojects.com/](https://flask.palletsprojects.com/)
- Bleak: [https://github.com/hbldh/bleak](https://github.com/hbldh/bleak)
- Flutter: [https://flutter.dev/](https://flutter.dev/)

---

### 🚀 Happy Coding! 🔥

