import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'control_page.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  List<BluetoothDevice> _devices = [];
  BluetoothConnection? _connection;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  void _initBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }

    var bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    var bluetoothScanStatus = await Permission.bluetoothScan.request();
    var locationStatus = await Permission.locationWhenInUse.request();

    if (bluetoothConnectStatus.isGranted && bluetoothScanStatus.isGranted && locationStatus.isGranted) {
      FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
        setState(() {
          _bluetoothState = state;
        });
      });

      _getPairedDevices();
    } 
  }

  void _getPairedDevices() async {
    List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      _devices = devices;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ControlPage(connection: _connection!),
      ));
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  @override
  void dispose() {
    _connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        title: const Text('Bluetooth Serial',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
      ),
      body: Container(
        // Adding background image using BoxDecoration
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/image2.png"), // Replace with your image path
            fit: BoxFit.cover,
            opacity: 0.7, // Adjust transparency if needed
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text('Bluetooth Status: ${_bluetoothState.toString().split('.').last}',style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_devices[index].name ?? "Unknown Device",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    onTap: () => _connectToDevice(_devices[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

