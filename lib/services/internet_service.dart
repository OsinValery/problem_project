import 'dart:io';

class InternetService {
  Future<bool> haveInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print(result);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      print(_);
      return false;
    }
  }
}
