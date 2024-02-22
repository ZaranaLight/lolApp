import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:lol/constanmt/app_constant.dart';
import 'package:lol/controller/authController.dart';
import 'package:lol/utils/appConstants.dart';
import 'package:lol/utils/colors.dart';
import 'package:lol/utils/dimentions.dart';
import 'package:lol/utils/images.dart';
import 'package:lol/utils/styles.dart';
import 'package:lol/widget/dropDownWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var authCon = Get.find<AuthController>();

  String SelectNEFTStatusTypeTitle = "Select Type";

  showCatDropdown(BuildContext context, AuthController authController) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return ListView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Text(
                        'Select Type Title',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 18),
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 5,
                      endIndent: 0,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
                Column(
                    children: authController.catDetails['data'].map((entry) {
                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.circle_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                      ),
                    ),
                    title: Text(
                      entry['text'],
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                    onTap: () {
                      if (SelectNEFTStatusTypeTitle == "Select Status") {
                        authController.setCatVal(entry['category_name']);

                        authController.setCategoryDropdownDetail(
                            context,
                            entry['category_name'],
                            entry['id'],
                            entry['status']);
                        authController.addDropdowndata(
                          'category_name',
                          entry['category_name'],
                        );
                        authController.addDropdowndata(
                          'id',
                          entry['id'],
                        );
                        authController.addDropdowndata(
                          'status',
                          entry['status'],
                        );
                      }

                      Get.back();
                      // showNEFTFilterPopup(context);
                    },
                  );
                }).toList())
              ]);
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // if (authCon.catDetails.isEmpty) {
      //   authCon.getCategory();
      // }
      authCon.getCategory();
      authCon.getAllPosts();
    });
  }

  List selecterArray = [];
  List<String> _items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  String _selectedItem = 'Item 1';

  showFilterInPopUp(BuildContext context, {required Widget child}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.all(20),
            backgroundColor: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          );
        });
  }

  String SelectTypeTitle = "Select Type";

  showCustomerDropdown(BuildContext context, AuthController companyController) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        backgroundColor: Colors.white,
        builder: (context) {
          return ListView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Text(
                        'Select Type Title',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 18),
                      ),
                    ),
                    Divider(
                      height: 20,
                      thickness: 5,
                      endIndent: 0,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
                Column(
                    children: companyController.catList.map((entry) {
                  // Map<String, dynamic> data = entry.value;

                  return ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.red)),
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(
                          Icons.circle_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                      ),
                    ),
                    title: Text(entry),
                    onTap: () {
                      print('SelectTypeTitle----${SelectTypeTitle}');
                      print('entry----${entry}');
                      if (SelectTypeTitle == "Select Type") {
                        companyController.setCatVal(entry);
                        // companyController.setCategoryDropdownDetail(
                        //     context, entry['category_name'], entry['id'], entry['status']);
                        companyController.addDropdowndata(
                          'category_name',
                          entry,
                        );
                        // companyController.addDropdowndata(
                        //   'id',
                        //   entry['id'],
                        // );
                      }

                      Get.back();
                      // showNEFTFilterPopup(context);
                    },
                  );
                }).toList())
              ]);
        });
  }

  showNEFTFilterPopup(BuildContext context) {
    return showFilterInPopUp(
      context,
      child: StatefulBuilder(builder: (BuildContext context, setState) {
        return GetBuilder<AuthController>(builder: (authController) {
          return Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(12),
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: -1.0,
                  blurRadius: 12.0,
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Categories',
                        style: poppinsMedium.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeExtraLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 2,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatefulBuilder(
                            builder: (BuildContext context, setState) {
                          return InkWell(
                            onTap: () {
                              print('hi--------');
                              print(authController.catDropdownvalue);
                              setState(() {
                                SelectTypeTitle = "Select Type";
                                selecterArray = authController.catList;
                              });
                              Get.back();
                              showCustomerDropdown(context, authController);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: DropdownTextFiled(
                                isFlagList: false,
                                isSelected: authController.catDropdownvalue !=
                                            '' &&
                                        authController.catDropdownvalue != ""
                                    ? true
                                    : false,
                                depth: true,
                                hint: authController.catDropdownvalue != '' &&
                                        authController.catDropdownvalue != ""
                                    ? authController.catDropdownvalue
                                    : "Select Type",
                                onChanged: (value) {
                                  setState(() {
                                    SelectTypeTitle = value;
                                    authController.addDropdowndata(
                                        "category_name", SelectTypeTitle);
                                    authController.setCatVal(
                                        authController.catDropdownvalue);
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
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
                      InkWell(
                        onTap: () {
                          showNEFTFilterPopup(context);
                        },
                        child: Container(
                          width: Get.width * 0.3,
                          height: 40,
                          decoration: BoxDecoration(
                              gradient: ColorssA.AppLinears,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  authController.catDropdownvalue ==
                                          'Select Type'
                                      ? 'Categories'
                                      : authController.catDropdownvalue,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    itemCount: authController.postList.length,
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
                                    child:  Image.asset(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                authController.postList[index]['title'] ?? "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            authController.postList[index]
                            ['file'] !=
                                ''
                                ? Image.network(
                              AppConstants.IMAGE_URL+ authController.postList[index]
                              ['file'],
                              width: Get.width,fit: BoxFit.fill,
                              height: Get.height*0.27,
                            )
                                :Container(),
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
