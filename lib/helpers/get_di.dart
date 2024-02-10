import 'package:get/get.dart';
import 'package:lol/api/api_client.dart';
import 'package:lol/constanmt/app_constant.dart';
import 'package:lol/controller/authController.dart';
import 'package:lol/controller/splashController.dart';
import 'package:lol/repo/authRepo.dart';
import 'package:lol/repo/splashRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';


init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()),fenix: true);

  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find()), fenix: true);
  Get.lazyPut(() => SplashController(splashRepo: Get.find()), fenix: true);
 Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => AuthController(authRepo: Get.find()), fenix: true);
}
