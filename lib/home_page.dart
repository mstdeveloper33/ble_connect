import 'package:ble_flutter/ble_controller.dart';
import 'package:ble_flutter/veri_transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ScanResult> devices = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ble Scannner"),
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (BleController controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<List<ScanResult>>(
                  stream: controller.scanResult,
                  builder: (context, snapshot) {
                    {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return Card(
                                elevation: 2,
                                child: ListTile(
                                  onTap: () {
                                    controller.connectToDevice(data.device);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => TextSend()));
                                  },
                                  title: Text(
                                    data.device.name ?? "unknown",
                                  ),
                                  subtitle: Text(data.device.id.id),
                                  trailing: Text(
                                    data.rssi.toString(),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("no devices found"),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.scanDevices();
                  },
                  child: Text("Scan"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
