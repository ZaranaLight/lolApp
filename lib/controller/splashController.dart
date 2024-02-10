import 'dart:async';

import 'package:get/get.dart';
import 'package:lol/repo/splashRepo.dart';

class SplashController extends GetxController implements GetxService {
  SplashController({required this.splashRepo});
  final SplashRepo splashRepo;
  bool _firstTimeConnectionCheck = true;
  bool _hasConnection = true;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get hasConnection => _hasConnection;

  Future<bool> getConfigData() async {
    _hasConnection = true;
    return _hasConnection;
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  redirect(String page) {
    Timer timer = Timer(const Duration(seconds: 3), () {
      Get.offNamed(page);
    });
  }
}
