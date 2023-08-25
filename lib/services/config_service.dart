import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  Future<String?> getUrl() async {
    return _remoteConfig.getString("url");
  }

  late FirebaseRemoteConfig _remoteConfig;

  void initService() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 10),
    ));
    await _remoteConfig.fetchAndActivate();
  }
}
