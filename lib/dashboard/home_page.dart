import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:lol/controller/authController.dart';
import 'package:lol/utils/colors.dart';
import 'package:lol/utils/dimentions.dart';
import 'package:lol/utils/images.dart';
import 'package:lol/utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var authCon = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (authCon.homeList.isEmpty) {
        authCon.getHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: Get.width * 0.55,
                          height: 40,
                          decoration: BoxDecoration(
                              gradient: ColorssA.AppLinears,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.search,
                                color: ColorssA.whiteColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Center(
                                child: Text(
                                  'Search',
                                  style: TextStyle(color: ColorssA.whiteColor),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        width: Get.width * 0.3,
                        height: 40,
                        decoration: BoxDecoration(
                            gradient: ColorssA.AppLinears,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(color: ColorssA.whiteColor),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    itemCount: authController.homeList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        height: Get.height * 0.475,
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            gradient: ColorssA.AppLinears,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                gradient: ColorssA.AppLinears,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: ColorssA.dialpgColor),
                                    child: Image.asset(
                                      Images.bio,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Shalini Chauhan',
                                          style: poppinsMedium.copyWith(
                                              color: ColorssA.whiteColor,
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'Suggested for your . 1d',
                                          style: TextStyle(
                                              color: ColorssA.whiteColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.save,
                                        color: ColorssA.whiteColor,
                                      ))
                                ],
                              ),
                            ),
                            // Image.network('https://images.unsplash.com/photo-1584810359583-96fc3448beaa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1267&q=80',fit: BoxFit.cover,width: Get.width,height: 143,),
                            // Image.asset(Images.post2, fit: BoxFit.fill,
                            //   width: Get.width,
                            //   height: 200,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                              child: Center(
                                child: Text(
                                  authController.homeList[index]['text'],

                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            // Image.file(File(authController.homeList[index]['file'])),

                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                gradient: ColorssA.AppLinears,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.thumb_up_alt_rounded,
                                          color: ColorssA.blackColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          '27',
                                          style: TextStyle(
                                            color: ColorssA.blackColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.comment,
                                          color: ColorssA.blackColor,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          '20',
                                          style: TextStyle(
                                            color: ColorssA.blackColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.share_sharp,
                                          color: ColorssA.blackColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          '10',
                                          style: TextStyle(
                                            color: ColorssA.blackColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
