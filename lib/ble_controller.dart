

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;
  // VZBEL için tanıma kontrolü
  BluetoothDevice? targetDevice;
  String targetDeviceName = "Vzbel";
  String targetDeviceUUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";

  //late BluetoothDevice raspberryPiDevice;
  Future scanDevices() async {
    // Bluetooth'un kullanılabilir ve açık olup olmadığını kontrol et
    bool isBluetoothAvailable = await ble.isAvailable;
    bool isBluetoothOn = await ble.isOn;

    // Bluetooth açık ise devam et
    if (isBluetoothAvailable && isBluetoothOn) {
      if (await Permission.bluetoothScan.request().isGranted) {
        if (await Permission.bluetoothConnect.request().isGranted) {
          // Tarama sırasında cihazları dinle
          ble.scanResults.listen((List<ScanResult> results) {
            // Belirli cihaz adı ve UUID'siyle eşleşen cihazı bul
            ScanResult? targetDevice = results.firstWhereOrNull((result) =>
                result.device.name == targetDeviceName &&
                result.device.id.id == targetDeviceUUID);

            // Eğer belirli cihaz bulunduysa, bağlantı kur
            if (targetDevice != null) {
              connectToDevice(targetDevice.device);
            }
          }, onError: (dynamic error) {
            // Hata durumunda işlemler burada yapılabilir
            print("Error during scanning: $error");
          }, cancelOnError: true); // Hata durumunda akışı iptal et

          // Taramayı başlat
          ble.startScan(timeout: Duration(seconds: 10));
        }
      }
    } else {
      // Bluetooth kapalı ise kullanıcıya bilgi ver
      print("Bluetooth is not available or turned off.");
    }
  }

  Future<void> sendData(BluetoothDevice device, String data) async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      service.characteristics.forEach((characteristic) async {
        if (characteristic.uuid == '6e400003-b5a3-f393-e0a9-e50e24dcca9e') {
          await characteristic.write(utf8.encode(data));
        }
      });
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    // if (device.state == BluetoothDeviceState.connected) {
    //   await device.disconnect();
    // }
    print(device);
    await device.connect(
      timeout: Duration(seconds: 15),
    );
    device.state.listen((isConnected) {
      if (isConnected == BluetoothDeviceState.connecting) {
        debugPrint("Device connecting to : ${device.name}");
      } else if (isConnected == BluetoothDeviceState.connected) {
        debugPrint("Device connected : ${device.name} ");
      } else {
        debugPrint("Device Disconnected");
      }
    });
  }

  Stream<List<ScanResult>> get scanResult => ble.scanResults;
  
}


//  for (ScanResult result in results) {
//               if (result.device.name == targetDeviceName &&
//                   result.device.id.id == targetDeviceUUID) {
//                 connectToDevice(result.device);
//                 break;
//               }
//             }