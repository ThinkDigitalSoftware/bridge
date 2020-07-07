import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bridge/client.dart';
import 'package:bridge/exceptions.dart';
import 'package:bridge/models/work_order.dart';
import 'package:bridge/registrar.dart';
import 'package:bridge/service.dart';
import 'package:meta/meta.dart';

class Bridge {
  final registrar = Registrar();
  HttpServer _server;
  final _hasInit = Completer();

  Bridge({@required String address, @required int port}) {
    _init(address, port);
  }

  Future<void> _init(String address, int port) async {
    print('Starting server at $address:$port');

    print('Waiting for connections');
    _server = await HttpServer.bind(InternetAddress.loopbackIPv6, port);

    print('Server listening on port $port');
    _hasInit.complete();
  }

  void start() async {
    await _hasInit.future;
    await for (HttpRequest request in _server) {
      final contentType = request.headers.contentType;
      if (request.method != 'GET' && request.method != 'POST') {
        request.response
          ..statusCode = HttpStatus.methodNotAllowed
          ..write('Unsupported request: ${request.method}.');
        await request.response.close();
      }
      // TODO: set up help responses
      var sessionId = request.session.id;
      print('[Incoming request]: ${request.uri.path} ${sessionId}');
      final content = await utf8.decoder.bind(request).join();
      final data = jsonDecode(content) as Map;
      if (!validateDataFormat(data)) {
        throw UnsupportedDataStructureException(); // TODO: Fill this out.
      }
      final String serviceName = data['service'];
      final String functionName = data['function'];
      //TODO: change this to better handle errors.

      // assume any incoming call is a client for now.
      // bypassing registration for testing
//      final registrant = await _convert(request);
//      registrar.register(registrant);

      if (/*registrant is Client*/ true) {
//        final Map call = jsonDecode(event);
//        final functionName = call['function'];
//        final serviceName = call['service'];
        assert(functionName != null);

//        print('$registrant sent $event');
        final requestId = request.hashCode;
        try {
          final workOrder = WorkOrder(
            service: serviceName,
            function: functionName,
            data: data['data'],
          );
          final result = await dispatch(
            requestId: requestId,
            workOrder: workOrder,
//            clientName: registrant.name,
          );
          print('Responding with ${result}');
          request.response.write(result);
          await request.response.close();
        } on Exception catch (e) {
          print(e);
          request.response.statusCode = HttpStatus.notFound;
          request.response.reasonPhrase = '$e';
          request.response.write('{"error": "$e"}');
          await request.response.close();
        }
      }
    }
  }

  Future<ClientOrServiceOrig> _convert(HttpRequest request) async {
    final client = await WebSocketTransformer.upgrade(request);
    final name = request.uri.queryParameters['name'];
    if (name == null) {
      throw SocketException(
          'You must include the "name" parameter in your url');
    }
    final type = request.uri.queryParameters['type'];
    if (type != 'client' && type != 'service') {
      throw SocketException(
          'You must include the "type" parameter in your url. The value must be either "client" or "service"');
    }

    if (type == 'client') {
      return Client(
          name: name,
          webSocket: client,
          port: request.uri.port,
          address: request.uri.path);
    } else {
      assert(type == 'service');
      return Service_(
        name: name,
        webSocket: client,
        port: request.uri.port,
        address: request.uri.path,
      );
    }
  }

  Future<String> dispatch({
    @required int requestId,
    @required WorkOrder workOrder,
//    @required String clientName,
    Map data,
  }) async {
//    final client = registrar.lookup<Client>(clientName);
    final service = registrar.lookup(workOrder.service);

//    if (client == null) {
//      throw ClientNotFoundException(clientName);
//    }
    if (service == null) {
      throw ServiceNotFoundException(workOrder.service);
    }
    assert(service.supports(workOrder.function));

    final response = await service.process(workOrder);

    var returnValue = jsonEncode(response);
    return returnValue;
  }

  static Future<WebSocket> getWebSocket({
    RegistrationType registrationType,
    String address,
    final String name,
    int port,
  }) async {
    return await WebSocket.connect(
      'ws://$address:$port/ws?name=$name&type=${registrationType == RegistrationType.client ? 'client' : 'service'}',
    );
  }
}

enum RegistrationType { client, service }

bool validateDataFormat(Map data) =>
    data['service'] != null && data['function'] != null;
