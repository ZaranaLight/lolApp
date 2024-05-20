 import 'package:get/get.dart';
import 'package:lol/widget/networkController.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}