import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Color.dart';

void errorDialog(String message, String btntext) {
  Get.defaultDialog(
    radius: 10.0,
    contentPadding: const EdgeInsets.all(15.0),
    titlePadding: EdgeInsets.only(top: 15),
    title: 'Not Success!',
    titleStyle: TextStyle(fontSize: 25, color: errorColor),
    middleText: message.toString(),
    confirm: ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(errorColor),
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
        style: TextStyle(color: whiteColor),
      ),
    ),
  );
}
