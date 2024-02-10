import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lol/controller/authController.dart';
import 'package:lol/helpers/routes_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var authCon = Get.find<AuthController>();
  var data;
  var mail;

  @override
  void initState() {
    data = authCon.authRepo.getUserDetail();
    Future.delayed(Duration(milliseconds: 100), () {
      if (data != '') {
        mail =  authCon.authRepo.getUserMail();
        print('mail========${mail}');
        authCon.getHome();
        Get.offNamed(RouteHelper.getDashboard());

      } else {
        Get.offNamed(RouteHelper.getSignUp());

      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/rat.png'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
