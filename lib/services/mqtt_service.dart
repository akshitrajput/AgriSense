// lib/services/mqtt_service.dart
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';
import 'package:agrisense/providers/farm_data_provider.dart';

class MQTTService {
  // --- Configuration ---
  final String _broker = "test.mosquitto.org";
  final String _commandTopic = "agrisense/rover/control";
  final String _statusTopic = "agrisense/rover/status";
  final String _clientId = "myFlutterApp_${DateTime.now().millisecondsSinceEpoch}";

  MqttServerClient? _client;
  final FarmDataProvider _provider;

  MQTTService(this._provider) {
    print("--- MQTTService Initialized ---");
  }

  Future<void> connect() async {
    print("--- MQTT Connect() method CALLED ---");

    _provider.setConnectionState(MqttConnectionState.connecting);
    _provider.setLastStatusMessage("Connecting...");

    if (_client != null && _client!.connectionStatus!.state != MqttConnectionState.disconnected) {
      print("[MQTT] connect() called, but client is already connecting or connected.");
      return;
    }

    print("[MQTT] Creating new MqttServerClient instance...");
    _client = MqttServerClient(_broker, _clientId);
    _client!.port = 1883;
    _client!.logging(on: true);
    _client!.keepAlivePeriod = 60;

    _client!.onConnected = _onConnected;
    _client!.onDisconnected = _onDisconnected;
    _client!.onSubscribed = _onSubscribed;
    _client!.pongCallback = _pong;
    _client!.onAutoReconnect = () => print("[MQTT] Auto Reconnect triggered");
    _client!.onAutoReconnected = () => print("[MQTT] Auto Reconnected");

    final connMess = _client!.connectionMessage ?? MqttConnectMessage();
    connMess
        .withWillTopic(_statusTopic)
        .withWillMessage('Rover App Offline')
        .withWillQos(MqttQos.atLeastOnce)
        .withWillRetain();
    _client!.connectionMessage = connMess;

    try {
      print("[MQTT] Attempting _client.connect()...");
      await _client!.connect();
      print("[MQTT] _client.connect() call FINISHED.");

      if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
        print("[MQTT] Connection successful (verified after await).");
        _provider.setConnectionState(MqttConnectionState.connected);
      } else {
        print("[MQTT] WARNING: connect() finished but state is NOT connected. State is: ${_client!.connectionStatus!.state}");
        _provider.setConnectionState(_client!.connectionStatus!.state);
        _provider.setLastStatusMessage("Connection failed.");
      }

    } on NoConnectionException catch (e) {
      print('[MQTT] CATCH: NoConnectionException: $e');
      _provider.setLastStatusMessage("Connection Error: $e");
      _provider.setConnectionState(MqttConnectionState.faulted);
      _client?.disconnect();
    } on SocketException catch (e) {
      print('[MQTT] CATCH: SocketException: $e');
      _provider.setLastStatusMessage("Network Error: $e");
      _provider.setConnectionState(MqttConnectionState.faulted);
      _client?.disconnect();
    } catch (e) {
      print('[MQTT] CATCH: Unknown exception: $e');
      _provider.setLastStatusMessage("Unknown Error: $e");
      _provider.setConnectionState(MqttConnectionState.faulted);
    }
  }

  void disconnect() {
    print("[MQTT] disconnect() CALLED");
    _client?.disconnect();
  }

  void publish(String message) {
    print("[MQTT] publish() CALLED with message: '$message'");

    if (_client == null) {
      print("[MQTT] PUBLISH FAILED: _client is null.");
      _provider.setLastStatusMessage("Error: Client not initialized.");
      connect();
      return;
    }

    final state = _client!.connectionStatus?.state;
    print("[MQTT] Current connection state: $state");

    if (state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client!.publishMessage(
        _commandTopic,
        MqttQos.atLeastOnce,
        builder.payload!,
      );
      print("[MQTT] PUBLISH SUCCESS: '$message' to $_commandTopic");
    } else {
      print("[MQTT] PUBLISH FAILED: Client not connected. State: $state");
      _provider.setLastStatusMessage("Cannot publish, not connected.");

      if (state == MqttConnectionState.disconnected || state == MqttConnectionState.faulted) {
        print("[MQTT] Attempting to reconnect...");
        _provider.setLastStatusMessage("Reconnecting...");
        connect();
      }
    }
  }

  // --- Internal Callbacks ---

  void _onConnected() {
    print("[MQTT] CALLBACK: _onConnected CALLED.");
    _provider.setLastStatusMessage("Connected to Rover");
    _provider.setConnectionState(MqttConnectionState.connected);

    print("[MQTT] Subscribing to $_statusTopic");
    _client!.subscribe(_statusTopic, MqttQos.atLeastOnce);

    _client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
      MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('[MQTT] Received: "$payload" from topic ${c[0].topic}');
      _provider.setLastStatusMessage(payload);

      if (payload == "Autonomous Mode: ON") {
        _provider.updateRoverState(true);
      } else if (payload == "Autonomous Mode: OFF" || payload == "Rover Online" || payload == "Rover Offline") {
        _provider.updateRoverState(false);
      }
      // --- Sprinkler logic REMOVED ---
    });
  }

  void _onDisconnected() {
    print("[MQTT] CALLBACK: _onDisconnected CALLED.");
    _provider.setLastStatusMessage("Disconnected");
    _provider.setConnectionState(MqttConnectionState.disconnected);
  }

  void _onSubscribed(String topic) {
    print("[MQTT] CALLBACK: _onSubscribed to $topic");
  }

  void _pong() {
    print("[MQTT] CALLBACK: _pong received");
  }
}