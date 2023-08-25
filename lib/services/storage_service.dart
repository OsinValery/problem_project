import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  void saveUrl(String url) async {
    final share = await SharedPreferences.getInstance();
    share.setString('url', url);
  }

  Future<String?> getUrl() async {
    final share = await SharedPreferences.getInstance();
    return share.getString('url');
  }

  void saveScore(int score) async {
    final share = await SharedPreferences.getInstance();
    share.setInt('score', score);
  }

  Future<int?> getScore() async {
    final share = await SharedPreferences.getInstance();
    return share.getInt('score');
  }
}
