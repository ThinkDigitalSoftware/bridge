import 'package:bridge/services/service.dart';

class TimeService extends Service {
  @override
  final String name = 'time';

  static Future<Map> getTime(Map data) async {
    switch (data['data']) {
      case 'now':
      case 'current':
        return {'data': DateTime.now().toIso8601String()};
      default:
        throw UnimplementedError('🙃 oops');
    }
  }

  @override
  final Map<String, Future<Map> Function(Map data)> functions = {
    'get_time': getTime
  };
}
