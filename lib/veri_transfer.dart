import 'dart:convert';

import 'package:ble_flutter/ble_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class TextSend extends StatefulWidget {
  final BluetoothDevice device;
  const TextSend({super.key, required this.device});

  @override
  State<TextSend> createState() => _TextSendState();
}

class _TextSendState extends State<TextSend> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: "Metni Girin "),
            ),
            ElevatedButton(
              onPressed: () {
                String textToSend = textEditingController.text;
                BleController bleController = BleController();
                bleController.sendData(widget.device, textToSend);
              },
              child: Text("Gönder"),
            ),
          ],
        ),
      ),
    );
  }
}
