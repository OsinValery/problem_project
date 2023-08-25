import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:problem_project/services/internet_service.dart';
import 'package:problem_project/ui/root/events_and_state.dart';

import '../../logic/device_config.dart';
import '../../services/config_service.dart';
import '../../services/platform_jobs.dart';
import '../../services/storage_service.dart';

class RootBloc extends Cubit<AppState> {
  RootBloc() : super(AppState(false, false, ''));

  bool checkedConditions = false;
  bool firebaseBrocen = false;

  Future<AppState> _determineState() async {
    var state = AppState(false, false, '');
    checkedConditions = true;
    state.conditionsChecked = true;

    var deviceService = PlatformJobs();
    var info = await deviceService.getDeviceInfo();
    var deviceConfig = DeviceConfig(info);
    print(info);

    if (!deviceConfig.deviceGood) {
      state.presentUrl = false;
      return state;
    }

    print('read storage');

    var storageService = StorageService();
    var storageUrl = await storageService.getUrl();
    var internetService = InternetService();

    if (storageUrl != null) {
      print("storage url: $storageUrl");
      state.url = storageUrl;
      state.presentUrl = true;
      state.haveInternet = await internetService.haveInternet();
      print("storage + internet: ${state.haveInternet}");
      return state;
    }

    try {
      state.presentUrl = true;
      var urlService = RemoteConfigService();
      urlService.initService();
      var url = await urlService.getUrl();
      if (url == null) {
        state.url = "";
        state.presentUrl = false;
      } else {
        state.url = url;
      }
    } catch (_) {
      print(_);
      state.haveInternet = false;
      firebaseBrocen = true;
      return state;
    }

    print("firebase requested");
    print(state.haveInternet);
    print(state.url);

    if (state.presentUrl && state.url.isNotEmpty) {
      storageService.saveUrl(state.url);
    }
    return state;
  }

  void getStartState() async {
    var state = await _determineState();
    emit(state);
  }

  void refrashInternet() async {
    if (firebaseBrocen) return;
    state.haveInternet = await InternetService().haveInternet();
    print(state.haveInternet);
  }
}
