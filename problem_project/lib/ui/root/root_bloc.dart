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

    if (!deviceConfig.deviceGood) {
      state.presentUrl = false;
      return state;
    }

    var storageService = StorageService();
    var storageUrl = await storageService.getUrl();
    var internetService = InternetService();

    if (storageUrl != null) {
      state.url = storageUrl;
      state.presentUrl = true;
      state.haveInternet = await internetService.haveInternet();
      print("storage + internet: ${state.haveInternet}");
      return state;
    }

    state = await checkFirebase(state);
    if (firebaseBrocen) return state;

    print("final url = ${state.url}");

    if (state.presentUrl && state.url.isNotEmpty) {
      storageService.saveUrl(state.url);
    }
    return state;
  }

  void getStartState() async {
    await Future.delayed(const Duration());
    var state = await _determineState();
    emit(state);
  }

  void refrashInternet() async {
    if (firebaseBrocen) {
      var state2 = await checkFirebase(state);
      emit(state2);
      print("final url = ${state2.url}");

      if (state2.presentUrl && state2.url.isNotEmpty) {
        var storageService = StorageService();
        storageService.saveUrl(state2.url);
      }
      return;
    }
    state.haveInternet = await InternetService().haveInternet();
    print(state.haveInternet);
    emit(state);
  }

  Future<AppState> checkFirebase(AppState state) async {
    try {
      state.presentUrl = true;
      var urlService = RemoteConfigService();
      await urlService.initService();
      print('firebase configured');
      var url = await urlService.getUrl();
      state.haveInternet = true;
      print("firebase url: $url<!");
      if (url == null) {
        state.url = "";
        state.presentUrl = false;
      } else {
        state.url = url;
      }
      firebaseBrocen = false;
    } catch (_) {
      print("can't request firebase!");
      print(_);
      state.haveInternet = false;
      firebaseBrocen = true;
    }
    return state;
  }
}
