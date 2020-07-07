import 'package:bridge/client.dart';
import 'package:bridge/service.dart';
import 'package:bridge/services/echo.dart';
import 'package:bridge/services/service.dart';
import 'package:bridge/services/system.dart';
import 'package:bridge/services/time.dart';

class Registrar {
  final Map<String, Client> _clients = {};
  Map<String, Service> _defaultServices;
  Map<String, Service> _services;

  Registrar() {
    _services = {
      'time': TimeService(),
      'echo': EchoService(),
      'system': SystemService(this)
    };
  }

  Iterable<Service> get services => _services.values;

  bool register(
    ClientOrServiceOrig clientOrService, {
    Function onFailedToRegister,
  }) {
    final records = clientOrService is Client ? _clients : _services;
    if (!records.containsKey(clientOrService.name)) {
      records[clientOrService.name] = clientOrService;
      print('Registering ${clientOrService.name}');
      return true;
    } else {
      onFailedToRegister?.call();
      return false;
    }
  }

  void deregister(ClientOrServiceOrig clientOrService) =>
      (clientOrService is Client ? _clients : _services)
          .remove(clientOrService.name);

/*  T lookup<T extends Service>*/
  Service lookup(String name) {
    //TODO: Change back to support clients
    return _services[name];
  }

//    if (T == Client) {
//      return _clients[name] as T;
//    } else if (T == Service_) {
//      return _services[name] as T;
//    } else {
//      throw Exception('You must specify either Client or Service as the Type');
//    }
//  }

  bool hasService(String service) => _services.containsKey(service);
}
