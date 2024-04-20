import 'package:chatapp_mqtt/app_state.dart';
import 'package:chatapp_mqtt/home_screen.dart';
import 'package:chatapp_mqtt/name_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MQTTAppState>(
      create: (_) => MQTTAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NameScreen(),
      ),
    );
  }
}
