import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

abstract class ClientOrServiceOrig {
  final WebSocket webSocket;
  final String address;
  final int port;
  final Stream<dynamic> inputStream;

  @override
  String toString() {
    return 'ClientOrService{address: $address, port: $port, name: $name}';
  }

  final String name;

  ClientOrServiceOrig({
    @required this.address,
    @required this.port,
    @required this.webSocket,
    @required this.name,
  }) : inputStream = webSocket.asBroadcastStream();

  void send(String jsonEncodedResult) {
    webSocket.add(jsonEncodedResult);
  }

  StreamSubscription<dynamic> listen(
    void Function(dynamic event) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) {
    return inputStream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class Service_ extends ClientOrServiceOrig {
  final Future<Map> Function(String functionName, Object data) handleData;

  Service_({
    @required String address,
    @required int port,
    @required String name,
    @required WebSocket webSocket,
    @required this.handleData,
  }) : super(name: name, webSocket: webSocket, address: address, port: port) {
    super.inputStream.listen((event) async {
      final data = jsonDecode(event);
      final String functionName = data['function'];
      final value = await handleData(functionName, data);
      webSocket.add(jsonEncode(value));
      print(event);
//handleData(event);
    });
  }
}
