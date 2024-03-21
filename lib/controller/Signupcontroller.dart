import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lol/login.dart';

import '../Widget/Globelnotsuccess.dart';
import '../Widget/globalsuccess.dart';

class SignUpController extends GetxController {
  var name = TextEditingController().obs;
  var email = TextEditingController();
  var password = TextEditingController();
  RxBool isLoading = false.obs;
  var _passwordVisible = false.obs;

  bool get passwordVisible => _passwordVisible.value;

  void togglePasswordVisibility() {
    _passwordVisible.toggle();
  }

  //////////////////// register ////////////////////////

  Future<void> register() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('https://mcq.codingbandar.com/api/register'),
        body: {
          'email': email.value.text,
          'password': password.value.text,
          'name': name.value.text,
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body) ?? '';

        if (map['status'] == true) {
          showSuccessDialog("SignUp Successfully", "ok");
          Get.to(() => MyLogin());
        } else {
          errorDialog(
              map['error'] ?? "Something went wrong please try again.", "ok");
        }
      } else {
        errorDialog("Error: ${response.statusCode}", "ok");
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error in sign up: $e');
    }
  }
}
