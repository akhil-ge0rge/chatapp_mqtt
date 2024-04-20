import 'package:chatapp_mqtt/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: size.width * 0.75,
            height: size.height * 0.07,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextFormField(
              controller: _messageTextEditingController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final String message =
                  '${context.read<MQTTAppState>().userName} says: ${_messageTextEditingController.text.trim()}';
              context.read<MQTTAppState>().manager.publish(message);
              _messageTextEditingController.clear();
            },
            child: Container(
              width: size.height * 0.07,
              height: size.height * 0.07,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Text(
              context.watch<MQTTAppState>().getHistoryText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}
