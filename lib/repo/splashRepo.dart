
import 'package:lol/utils/appConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepo {
  final SharedPreferences sharedPreferences;
  SplashRepo({required this.sharedPreferences});

  Future<bool> initSharedData() {
    if (!sharedPreferences.containsKey(AppConstants.THEME)) {
      sharedPreferences.setBool(AppConstants.THEME, false);
    }
    return Future.value(true);
  }

  void disableIntro() {
    sharedPreferences.setBool(AppConstants.INTRO, false);
  }

  bool? showIntro() {
    return sharedPreferences.getBool(AppConstants.INTRO);
  }
}
