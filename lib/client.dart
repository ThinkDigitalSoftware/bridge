import 'dart:io';

import 'package:bridge/service.dart';
import 'package:meta/meta.dart';

class Client extends ClientOrServiceOrig {
  Client({
    @required String address,
    @required int port,
    @required String name,
    @required WebSocket webSocket,
  }) : super(name: name, webSocket: webSocket, address: address, port: port);
}
