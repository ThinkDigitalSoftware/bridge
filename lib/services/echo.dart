import 'package:bridge/services/service.dart';

class EchoService extends Service {
  @override
  final String name = 'echo';

  static Future<Map> echo(Map data) async {
    return data;
  }

  @override
  final Map<String, Future<Map> Function(Map data)> functions = {'echo': echo};
}
