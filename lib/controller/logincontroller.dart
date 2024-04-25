import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lol/widget/Globelnotsuccess.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Apiservice.dart';
import '../bottombar.dart';
import 'homecontroller.dart';

class LoginController extends GetxController {
  final Homecontroller homecontroller = Get.put(Homecontroller());
  final storage = GetStorage();
  var email = TextEditingController().obs;
  var password = TextEditingController().obs;
  final _passwordVisible = false.obs;
  bool get passwordVisible => _passwordVisible.value;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    homecontroller.getPostdata();
  }

  void togglePasswordVisibility() {
    _passwordVisible.toggle();
  }

  ////////////////  login  ////////////////

  Future<void> login() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(Apiservice.login),
        body: {
          'email': email.value.text,
          'password': password.value.text,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);

        if (map['status'] == true) {
          final data = jsonDecode(response.body);
          var item = data['data'];

          storage.write("userid", item['id']);
          storage.write("profile", item['profile']);
          storage.write("username", item['name'] ?? '');

          Get.offAll(() => MyBottombar());
        } else {
          errorDialog(
              map['error'] ?? 'Something went wrong please try again.', "ok");
        }
      } else {
        errorDialog("Login failed", "ok");
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error in login: $e');
    }
  }
}
