import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ControlPage extends StatelessWidget {
  final BluetoothConnection connection;

  const ControlPage({super.key, required this.connection});

  // Function to send a byte value to the Bluetooth device
  void _sendByte(int value) {
    connection.output.add(utf8.encode(
        String.fromCharCode(value))); // Send byte as UTF-8 encoded string
    connection.output.allSent; // Ensure the byte is fully sent
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent going back to this page
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Control',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage("images/image2.png"), // Set the background image
              fit: BoxFit.cover, // Cover the entire container
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Create two columns (open devices and close devices)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Column for sending bytes (Open Devices)
                    Column(
                      children: [
                        _buildButton('LED1 On', 0x30), // 0
                        _buildButton('LED2 On', 0x31), // 1
                        _buildButton('LED3 On', 0x32), // 2
                        _buildButton('Relay1 On', 0x33), // 3
                        _buildButton('Relay2 On', 0x34), // 4
                        _buildButton('Motor On', 0x35), // 5
                      ],
                    ),
                    // Column for sending bytes (Close Devices)
                    Column(
                      children: [
                        _buildButton('LED1 Off', 0x36), // 6
                        _buildButton('LED2 Off', 0x37), // 7
                        _buildButton('LED3 Off', 0x38), // 8
                        _buildButton('Relay1 Off', 0x39), // 9
                        _buildButton('Relay2 Off', 0x41), // A
                        _buildButton('Motor Off', 0x42), // B
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color.fromARGB(255, 8, 216, 15), // Background color
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 15.0), // Padding
            textStyle: const TextStyle(
              fontSize: 20, // Font size
              fontWeight: FontWeight.bold,
              color: Colors.black, // Font color
            ),
          ),
          onPressed: () => _sendByte(value), // Send byte
          child: Text(label, style: const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
