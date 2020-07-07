import 'package:bridge/services/service.dart';
import 'package:meta/meta.dart';

class ClientNotFoundException implements Exception {
  final String clientName;

  const ClientNotFoundException(this.clientName);

  String get message => 'There is no client found under the name $clientName';

  @override
  String toString() => message;
}

class ServiceNotFoundException implements Exception {
  final String serviceName;

  const ServiceNotFoundException(this.serviceName);

  String get message => 'There is no service found under the name $serviceName';

  @override
  String toString() => message;
}

class UnsupportedFunctionException implements Exception {
  final Service service;
  final String function;

  const UnsupportedFunctionException({
    @required this.service,
    @required this.function,
  });

  String get message =>
      '${service.name} does not have a function named: $function';
}

class UnsupportedDataStructureException implements Exception {
  final Service service;
  final String function;
  final Map data;
  final Map correctStructure;

  const UnsupportedDataStructureException({
    @required this.service,
    @required this.function,
    @required this.data,
    @required this.correctStructure,
  });

  String get message =>
      '${service.name} does not support the data structure for function $function.\n'
      'Supplied data: $data\n'
      'Correct structure: $correctStructure';
}
