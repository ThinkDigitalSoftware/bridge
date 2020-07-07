import 'dart:io';

import 'package:args/args.dart';
import 'package:bridge/bridge.dart';

const _hostname = 'localhost';

void main(List<String> args) async {
  var parser = ArgParser()
    ..addOption('address', abbr: 'a')
    ..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  // For Google Cloud Run, we respect the PORT environment variable
  final portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  final port = int.tryParse(portStr);
  final addressStr =
      result['address'] ?? Platform.environment['ADDRESS'] ?? _hostname;

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }
  final bridge = Bridge(address: addressStr, port: port);
  bridge.start();
}
