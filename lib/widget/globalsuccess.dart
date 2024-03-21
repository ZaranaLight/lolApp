import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Color.dart';

void showSuccessDialog(String message, String btntext) {
  Get.defaultDialog(
    radius: 10.0,
    contentPadding: const EdgeInsets.all(15.0),
    titlePadding: EdgeInsets.only(top: 15),
    title: 'Success!'.tr,
    titleStyle: TextStyle(fontSize: 25),
    middleText: message.toString(),
    confirm: ElevatedButton.icon(
      style: ButtonStyle(
        elevation: MaterialStatePropertyAll(0),
        backgroundColor: MaterialStateProperty.all(greenColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      onPressed: () => Get.back(),
      icon: Icon(
        Icons.check,
        color: whiteColor,
      ),
      label: Text(
        btntext.toString(),
        style: TextStyle(color: whiteColor, fontSize: 17),
      ),
    ),
  );
}
