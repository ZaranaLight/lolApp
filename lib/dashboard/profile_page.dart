import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/constanmt/app_constant.dart';
import 'package:lol/controller/authController.dart';
import 'package:lol/helpers/routes_helper.dart';
import 'package:lol/utils/colors.dart';
import 'package:lol/utils/styles.dart';
import 'package:lol/widget/customButton.dart';
import 'package:lol/widget/customDroopdown.dart';
import 'package:lol/widget/myTextFeildWidget.dart';
import 'package:lol/widget/showCustomsnackBar.dart';

import '../utils/dimentions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var authCon = Get.find<AuthController>();

  var userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userData = authCon.authRepo.getUserDetail();
    authCon.getProfile();
    print('check-----------');
    print(authCon.userDetails['contact']);
    print(authCon.userDetails['address']);
    print(authCon.userDetails['qualification']);
    print(authCon.userDetails['pincode']);
    contactController =
        TextEditingController(text: authCon.userDetails['contact'] ?? "");
    addressController =
        TextEditingController(text: authCon.userDetails['address'] ?? "");
    pinCode = TextEditingController(text: authCon.userDetails['pincode'] ?? "");
    qualificationPassController =
        TextEditingController(text: authCon.userDetails['qualification'] ?? "");
  }

  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController editPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController qualificationPassController = TextEditingController();
  List<String> dropdownItemListType = [
    "Male",
    "Female",
  ];

  void _updateProfile(AuthController authController) async {


  /*  if (contactController.text.isEmpty) {
      showCustomSnackBar('Enter your contact number.', context);
      return;
    }
    if (addressController.text.isEmpty) {
      showCustomSnackBar('Enter your address.', context);
      return;
    }
    if (editPassController.text.isEmpty) {
      showCustomSnackBar('Enter your edit password.', context);
      return;
    }
    if (confirmPassController.text.isEmpty) {
      showCustomSnackBar('Enter your confirm password.', context);
      return;
    }
    if (confirmPassController.text != editPassController.text) {
      showCustomSnackBar(
          'Edit password and confirm password must be same.', context);
      return;
    }
    if (pinCode.text.isEmpty) {
      showCustomSnackBar('Enter pin code number.', context);
      return;
    }
    if (qualificationPassController.text.isEmpty) {
      showCustomSnackBar('Enter your qualification.', context);
      return;
    }
    if (selectedGender == '') {
      showCustomSnackBar('Select Gender.', context);
      return;
    } */  {
      authController.addSignupData("email", jsonDecode(userData)['email']);
      authController.addSignupData("id", jsonDecode(userData)['id']);
      authController.addSignupData("gender", selectedGender);
      print('validation s');

      // authController.profile(authController.sigupdata, context);
    }
  }

  String? selectedGender;
  File? pickedImage;
  bool picked = false;

  Future pickImage(AuthController authController) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // pickedImage = imageFile;
      setState(() {
        pickedImage = imageFile;

        print('imageFilepath------------${imageFile}');
        picked = true;

        // catalougeUploadImage(pickedImage!);
      });
      //  return imageFile;
    } else {
      picked = false;
    }
    //else{
    // throw "null";
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorssA.whiteColor,
          elevation: 1,
          automaticallyImplyLeading: false,
          actions: [
            SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                pickImage(authController);
              },
              child: Stack(
                children: [
                  Container(
                    // padding: EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: ColorssA.dialpgColor.withOpacity(0.3),
                    ),
                    child: pickedImage?.path != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              File(pickedImage!.path).absolute,
                              height: 60,
                              width: 60,
                              fit: BoxFit.fill,
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(17),
                            child: Icon(Icons.person_rounded)),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.edit_note_outlined,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jsonDecode(userData)['email'],
                  style: TextStyle(color: ColorssA.blackColor),
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () async {
                await authController.clearSharedData();
                await authController.clearsigupdata();
                Get.offNamed(RouteHelper.getSignIn());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.logout,
                  color: ColorssA.errorColor,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: Container(
              color: ColorssA.primaryColor,
              height: 3.0,
            ),
          ),
        ),
        body: FocusDetector(
          onFocusGained: () {
            authController.getProfile();
            pinCode = TextEditingController(
                text: authCon.userDetails['pincode'] ?? "");
            emailController = TextEditingController(
                text: jsonDecode(userData)['email'] ?? "");
            contactController = TextEditingController(
                text: authCon.userDetails['contact'] ?? "");
            addressController = TextEditingController(
                text: authCon.userDetails['address'] ?? "");
            qualificationPassController = TextEditingController(
                text: authCon.userDetails['qualification'] ?? "");
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'E-mail',
                    style: TextStyle(
                        color: ColorssA.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                    TextField(
                    readOnly: true,
                    controller: emailController,
                    decoration: const InputDecoration(

                        constraints: BoxConstraints(maxHeight: 25, minHeight: 5),
                        hintText: "Enter your email",
                        hintStyle: TextStyle(fontSize: 13),
                        // labelText: jsonDecode(userData)['email'],
                        labelStyle: TextStyle(
                            color: Color(0xFF424242), fontSize: 13)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Contact Number',
                    style: TextStyle(
                        color: ColorssA.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: contactController,

                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        constraints: BoxConstraints(maxHeight: 25, minHeight: 5),
                        hintText: 'Contact Number',
                        hintStyle: TextStyle(fontSize: 13),
                        labelStyle: TextStyle(color: Color(0xFF424242),  fontSize: 13)),
                    onChanged: (contact) {
                      authController.addSignupData("contact", contact);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Address',
                    style: TextStyle(
                        color: ColorssA.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: addressController,
                    keyboardType: TextInputType.emailAddress,

                    decoration: InputDecoration(
                        hintText: 'Complete address',
                        constraints: BoxConstraints(maxHeight: 25, minHeight: 5),
                        hintStyle: TextStyle(fontSize: 13),
                        labelStyle: TextStyle(color: Color(0xFF424242),  fontSize: 13)),
                    onChanged: (address) {
                      authController.addSignupData("address", address);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Update Password',
                    style: TextStyle(
                        color: ColorssA.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: editPassController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        constraints: BoxConstraints(maxHeight: 25, minHeight: 5),
                        hintText: 'Update Password',
                        hintStyle: TextStyle(fontSize: 13),
                        labelStyle: TextStyle(color: Color(0xFF424242),  fontSize: 13)),
                    onChanged: (edit_password) {
                      authController.addSignupData(
                          "edit_password", edit_password);
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Pin Code',
                    style: TextStyle(
                        color: ColorssA.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: pinCode,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        constraints: BoxConstraints(maxHeight: 25, minHeight: 5),
                        hintText: 'Pincode',
                        hintStyle: TextStyle(fontSize: 13),
                        labelStyle: TextStyle(color: Color(0xFF424242),  fontSize: 13)),
                    onChanged: (pincode) {
                      authController.addSignupData("pincode", pincode);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Gender',
                    style: TextStyle(
                        color: ColorssA.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),

                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            value: 'male',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          Text('Male'),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            value: 'female',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Qualification',
                    style: TextStyle(
                        color: ColorssA.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: qualificationPassController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        constraints: BoxConstraints(maxHeight: 25, minHeight: 5),
                        hintText: 'Qualification',
                        hintStyle: TextStyle(fontSize: 13),
                        labelStyle: TextStyle(color: Color(0xFF424242),  fontSize: 13)),
                    onChanged: (qualification) {
                      authController.addSignupData(
                          "qualification", qualification);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),



                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:  Container(
          height: 55,
          margin: EdgeInsets.only(bottom: 15),
          alignment: Alignment.bottomCenter,
          child: ButtonWight(
            buttonText: "Save",
            borderButton: false,
            width: Get.width * 0.9,
            height: Get.height * 0.08,
            loading: authController.isLoading,
            onClick: () => {
              _updateProfile(authController)
            },
          ),
        ),
      );

    });
  }

  String? gender;
}
