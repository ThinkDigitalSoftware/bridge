import 'package:bridge/registrar.dart';
import 'package:bridge/services/service.dart';

class SystemService extends Service {
  @override
  final String name = 'system';
  final Registrar registrar;

  SystemService(this.registrar);

  @override
  Map<String, Future<Map> Function(Map p1)> get functions =>
      {'list_services': (_) => listServices()};

  Future<Map> listServices() async {
    final services = {
      for (final service in registrar.services)
        service.name: service.functions.keys.toList()
    };
    return services;
  }
}
