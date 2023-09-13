import 'package:flutter/services.dart';

class PlatformJobs {
  final _channel = const MethodChannel('platformJobs');

  Future<Map<dynamic, dynamic>?> getDeviceInfo() async {
    var info = await _channel.invokeMapMethod('devInfo');
    return info;
  }
}
