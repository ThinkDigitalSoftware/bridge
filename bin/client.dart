import 'dart:convert';
import 'dart:io';

import 'package:bridge/bridge.dart';
import 'package:bridge/client.dart';

void main(List<String> args) async {
  WebSocket webSocket;
  try {
    const address = '0.0.0.0';
    const port = 8080;

    final name = 'test_client_${Object().hashCode}';
    webSocket = await Bridge.getWebSocket(
        registrationType: RegistrationType.client,
        name: name,
        address: address,
        port: port);
    final client =
        Client(name: name, webSocket: webSocket, address: address, port: port);
    client.listen(dataHandler,
        onError: errorHandler,
        onDone: () => doneHandler(webSocket),
        cancelOnError: false);
    client.send(
        '{"service": "echo_service", "function": "echo", "data": {"text":"echo this back"}}');
  } catch (e) {
    print('Unable to connect: $e');
    exit(1);
  }

  stdin.listen((data) {
    var parsedJson;
    try {
      final text = String.fromCharCodes(data);
      parsedJson = jsonDecode(text);
      webSocket.addUtf8Text(data);
    } on FormatException {
      stderr.writeln('Invalid json received. Try again.');
    }
  });
}

void dataHandler(dynamic data) {
  String dataString;
  if (data is String) {
    dataString = data;
  } else {
    assert(data is List<int>);
    dataString = String.fromCharCodes(data).trim();
  }
  print(dataString);
}

void errorHandler(error, StackTrace trace) {
  print(error);
}

void doneHandler(WebSocket webSocket) {
  webSocket.close();
  exit(0);
}
