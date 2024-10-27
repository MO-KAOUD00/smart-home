import 'dart:async';
import 'package:flutter/material.dart';
import 'bluetooth_page.dart'; // Ensure this import path is correct for your Bluetooth page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // Timer to navigate to the next screen after 5 seconds
  void _startTimer() {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BluetoothPage()), // Navigate to BluetoothPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width, // Full width of the screen
        height: MediaQuery.of(context).size.height, // Full height of the screen
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("images/image2.png"), // Background image for splash screen
            fit: BoxFit.cover,
            opacity: 0.4, // Slight opacity for a faded effect
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}
