import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('broker.hivemq.com', 'dsfhbjuhdsf');

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Not connected';
  String _cabintemp = 'NA';
  String _enginetemp = 'NA';
  String _longitude = 'NA';
  String _latitude = 'NA';
  String _speed = 'NA';
  String _alcoholconcentration = 'NA';


  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() async {
    client.logging(on: false);

    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('client-id')
        .authenticateAs('', '')
        .keepAliveFor(60)
        .startClean()
        .withWillTopic('will-topic')
        .withWillMessage('Will message')
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.subscribe('topic', MqttQos.atLeastOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage receivedMessage = c[0].payload as MqttPublishMessage;
      final String message =
      MqttPublishPayload.bytesToStringAsString(receivedMessage.payload.message);
      Map<String, dynamic> parsedJson = jsonDecode(message);
      setState(() {
        _cabintemp = parsedJson['Cabin Temperature'];
        _alcoholconcentration = parsedJson["Alcohol Concentration"];
        _longitude = parsedJson["Longitude"];
        _latitude = parsedJson["Latitude"];
        _enginetemp = parsedJson["Engine Temperature"];
        _speed = parsedJson["Speed"];

      });
    });
  }

  void onConnected() {
    print('Connected to MQTT server');
    setState(() {
      _status = 'Connected to MQTT broker';
    });
  }

  void onDisconnected() {
    print('Disconnected from MQTT broker');
    setState(() {
      _status = 'Disconnected from MQTT broker';
    });
  }

  void onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MQTT Client'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Status: $_status',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Cabin Temperature: $_cabintemp °C',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Engine Temperature: $_enginetemp °C',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Longitude: $_longitude',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Latitude: $_latitude',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Alcohol Concentration: $_alcoholconcentration PPM',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                'Speed: $_speed KM/hr',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),


            ],
          ),
        ),
      ),
    );
  }
}