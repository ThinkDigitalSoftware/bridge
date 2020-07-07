import 'package:bridge/models/work_order.dart';
import 'package:meta/meta.dart';

abstract class Service {
  final String name;
  final Map _requests = {};

  /// All functions must be async
  final Map<String, Future<Map> Function(Map)> functions;

  Service({
    @required this.name,
    @required Map<String, Function(Map)> functions,
  }) : functions = functions;

  bool supports(String function) => functions.containsKey(function);

  /// data is transported in JSON Strings for the time being
  Future<Map> process(WorkOrder workOrder) async {
    // must be json encodable
    final response = functions[workOrder.function](workOrder.data);
    return response;
  }
}
