# 180-Degree Ultrasonic Radar System

An embedded systems project that combines an Arduino Uno, an ultrasonic sensor, and a servo motor to scan a 180-degree environment, displaying real-time telemetry and object detection data via an OLED screen and laptop visualizers (Processing & HTML5 Canvas).

---

## 🛠️ Components Used
- **Microcontroller:** Arduino Uno
- **Sensor:** HC-SR04 Ultrasonic Distance Sensor
- **Actuator:** SG90 Servo Motor (180° sweep)
- **Display:** 0.96-inch I2C SSD1306 OLED Display
- **Indicators:** Buzzer & LEDs (for proximity alerts)
- **Software Visualizers:** Processing 4 & HTML5 Web Serial API

---

## 📂 Repository Structure
- `arduino/` - Contains the C++ firmware for the Arduino Uno handling sensor triggers, servo sweeps, and serial transmission.
- `processing/` - Contains the Processing 4 sketch for rendering the radar sweep interface on a laptop screen.
- `html_canvas/` - Contains the web-based HTML5/JavaScript dashboard for serial telemetry visualization.

---

## 🚀 Getting Started

### 1. Hardware Connections
| Component | Arduino Pin |
| :--- | :--- |
| **HC-SR04 Trigger** | Pin 9 |
| **HC-SR04 Echo** | Pin 10 |
| **Servo Signal** | Pin 11 |
| **OLED SDA / SCL** | A4 (SDA) / A5 (SCL) |
| **Buzzer / LEDs** | Digital Pins 6, 7, 8 |

### 2. Flashing the Arduino Code
1. Open the Arduino IDE.
2. Install required libraries via Library Manager: `Servo`, `Adafruit SSD1306`, and `Adafruit GFX`.
3. Open `arduino/radar_firmware/radar_firmware.ino` and upload it to your Arduino Uno.

### 3. Running the Visualizer
- Launch the **Processing 4** sketch in `processing/radar_visualizer/` and ensure the correct COM port is selected, or open `html_canvas/index.html` in a browser supporting the Web Serial API.
