import 'package:flutter/foundation.dart';

class DeviceConfig {
  bool deviceGood = false;

  DeviceConfig(Map? config) {
    print(config);
    if (config == null) {
      deviceGood = false;
      debugPrint('can\'t get device info');
      return;
    }
    String brand = config['brand']!;

    deviceGood = (config['emulator'] != 'true') &&
        !brand.toLowerCase().contains('google');
  }
}
