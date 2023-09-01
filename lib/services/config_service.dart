import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  Future<String?> getUrl() async {
    return _remoteConfig!.getString("url");
  }

  FirebaseRemoteConfig? _remoteConfig;
  bool _serviceInitialized = false;

  Future initService() async {
    if (_serviceInitialized) return;
    _remoteConfig ??= FirebaseRemoteConfig.instance;
    await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    print("send config");
    await _remoteConfig!.fetchAndActivate();
    _serviceInitialized = true;
  }
}
