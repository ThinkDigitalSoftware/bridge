import 'dart:io';

import 'package:bridge/bridge.dart';
import 'package:bridge/service.dart';

void main(List<String> args) async {
  WebSocket webSocket;
  try {
    const address = '0.0.0.0';
    const port = 8080;

    final name = 'echo_service';
    webSocket = await Bridge.getWebSocket(
        registrationType: RegistrationType.service,
        name: name,
        address: address,
        port: port);
    final echoService = Service_(
        name: name,
        webSocket: webSocket,
        address: address,
        port: port,
        handleData: (String functionName, Object data) async {
          final mappedData = data as Map;
          var response = {'data': mappedData['data']['text']};
          return response;
        });
  } catch (e) {
    print('Unable to connect: $e');
    exit(1);
  }
}

void errorHandler(error, StackTrace trace) {
  print(error);
}

void doneHandler(WebSocket webSocket) {
  webSocket.close();
  exit(0);
}
