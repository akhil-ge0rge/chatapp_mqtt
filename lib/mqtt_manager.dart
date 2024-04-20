import 'dart:developer';

import 'package:chatapp_mqtt/app_state.dart';
import 'package:chatapp_mqtt/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager {
  final MQTTAppState _currentState;
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topic;
  MQTTManager(
      {required String host,
      required String topic,
      required String identifier,
      required MQTTAppState state})
      : _identifier = identifier,
        _host = host,
        _topic = topic,
        _currentState = state;

  void initializeMQTTClient() {
    _client = MqttServerClient(_host, _identifier);
    _client?.port = 1883;
    _client?.keepAlivePeriod = 20;
    _client?.onDisconnected = onDisconnected;
    _client?.secure = false;
    _client?.logging(on: true);
    _client?.onConnected = onConnected;
    _client?.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willtopic')
      ..withWillMessage('My Will message')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);
    log(connMess.payload.toString());
    _client?.connectionMessage = connMess;
  }

  void onDisconnected() {
    log('Client disconnected');
    if (_client?.connectionStatus?.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      log('OnDisconnected callback is solicited, this is correct');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    log('client connected....');
    _client?.subscribe(_topic, MqttQos.atLeastOnce);
    _client?.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      log(c?[0].topic.toString() ?? "topicccccc");
      log(c?[0].payload.toString() ?? "payloaddddd");
      final MqttPublishMessage recMess = c?[0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      log("MESSAGE :: -$pt");
      _currentState.setReceivedText(pt);
    });
    log('Client connection was sucessful');
  }

  void onSubscribed(String topic) {
    log('Subscription  topic $topic');
  }

  void connect(BuildContext context) async {
    assert(_client != null);

    try {
      Fluttertoast.showToast(msg: "Connecting..");
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client?.connect().whenComplete(() {
        if (_currentState.getAppConnectionState ==
            MQTTAppConnectionState.connected) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: ((context) => HomeScreen())));
        } else {
          Fluttertoast.showToast(msg: "Something Went Wrong");
        }
      });
    } on Exception catch (e) {
      log("Error On Connect $e");
      disconnect();
    }
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void disconnect() {
    log('Disconnected');
    _client?.disconnect();
  }
}
