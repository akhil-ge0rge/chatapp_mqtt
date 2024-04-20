import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'mqtt_manager.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  late MQTTAppState currentAppState;
  String _host = "test.mosquitto.org";
  String _topic = "chat-app";
  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: size.width * 0.8,
                height: size.height * 0.07,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _nameTextEditingController,
                  decoration: const InputDecoration(
                    hintText: "Enter Your Name",
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameTextEditingController.text.trim().isNotEmpty) {
                  context.read<MQTTAppState>().manager = MQTTManager(
                      host: _host,
                      topic: _topic,
                      identifier: _nameTextEditingController.text.trim(),
                      state: currentAppState);
                  context.read<MQTTAppState>().userName =
                      _nameTextEditingController.text.trim();
                  context.read<MQTTAppState>().manager.initializeMQTTClient();
                  context.read<MQTTAppState>().manager.connect(context);
                } else {
                  Fluttertoast.showToast(msg: "Enter Name");
                }
              },
              child: const Text("Enter Chat"),
            )
          ],
        ),
      ),
    );
  }
}
