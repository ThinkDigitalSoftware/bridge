import 'package:meta/meta.dart';

class WorkOrder {
  final String service;
  final String function;
  final Map data;

  const WorkOrder({
    @required this.service,
    @required this.function,
    @required this.data,
  });
}
