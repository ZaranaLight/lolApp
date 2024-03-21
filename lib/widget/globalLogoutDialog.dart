import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Color.dart';
import '../login.dart';

void showLogoutDialog(String message) {
  Get.defaultDialog(
    radius: 10.0,
    contentPadding: const EdgeInsets.all(15.0),
    titlePadding: EdgeInsets.only(top: 15),
    title: 'Are you Sure?',
    titleStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
    middleText: message.toString(),
    middleTextStyle: TextStyle(fontSize: 18),
    actions: [
      ElevatedButton.icon(
        style: ButtonStyle(
          elevation: MaterialStatePropertyAll(0),
          backgroundColor: MaterialStateProperty.all(success),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        onPressed: () {
          Get.to(MyLogin());
        },
        icon: Icon(
          Icons.check,
          color: whiteColor,
        ),
        label: Text(
          "Yes",
          style: TextStyle(color: whiteColor, fontSize: 17),
        ),
      ),
    ],
    confirm: ElevatedButton.icon(
      style: ButtonStyle(
        elevation: MaterialStatePropertyAll(0),
        backgroundColor: MaterialStateProperty.all(errorColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      onPressed: () => Get.back(),
      icon: Icon(
        Icons.close,
        color: whiteColor,
      ),
      label: Text(
        "No",
        style: TextStyle(color: whiteColor, fontSize: 17),
      ),
    ),
  );
}
