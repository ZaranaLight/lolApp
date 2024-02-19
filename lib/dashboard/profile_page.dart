import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
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
    contactController = TextEditingController(text: authCon.userDetails['contact']??"");
    addressController = TextEditingController(text: authCon.userDetails['address']??"");
    pinCode = TextEditingController(text: authCon.userDetails['pincode']??"");
    qualificationPassController = TextEditingController(text: authCon.userDetails['qualification']??"");
  }

  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  TextEditingController editPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController qualificationPassController = TextEditingController();
  List<String> dropdownItemListType = [
    "Male",
    "Female",
  ];
  void _updateProfile(AuthController authController) async {
    print(authController.sigupdata);


    if (contactController.text.isEmpty) {

      showCustomSnackBar('Enter your contact number.', context);
      return;
    }if (addressController.text.isEmpty) {

      showCustomSnackBar('Enter your address.', context);
      return;
    } if (editPassController.text.isEmpty) {

      showCustomSnackBar('Enter your edit password.', context);
      return;
    } if (confirmPassController.text.isEmpty) {

      showCustomSnackBar('Enter your confirm password.', context);
      return;
    } if (confirmPassController.text!=editPassController.text) {

      showCustomSnackBar('Edit password and confirm password must be same.', context);
      return;
    } if (pinCode.text.isEmpty) {

      showCustomSnackBar('Enter pin code number.', context);
      return;
    } if (qualificationPassController.text.isEmpty) {

      showCustomSnackBar('Enter your qualification.', context);
      return;
    }  if (selectedGender=='') {
      showCustomSnackBar('Select Gender.', context);
      return;
    }  else {
       authController.addSignupData(
          "email", jsonDecode(userData)['email']);
     authController.addSignupData(
          "id", jsonDecode(userData)['id']);
     authController.addSignupData(
          "gender", selectedGender);
      print('validation s');

      authController.profile(authController.sigupdata,context);
    }
  }
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorssA.whiteColor,
            elevation: 1,
            automaticallyImplyLeading: false,
            actions: [
            SizedBox(width: 15,),
              Container(
                padding: EdgeInsets.all(17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: ColorssA.dialpgColor.withOpacity(0.3),
                ),
                child: Icon(Icons.person_4_outlined),
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
                onTap: ()async{
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
            onFocusGained: (){
              authController.getProfile();
              pinCode = TextEditingController(text: authCon.userDetails['pincode']??"");
              contactController = TextEditingController(text: authCon.userDetails['contact']??"");
              addressController = TextEditingController(text: authCon.userDetails['address']??"");
              qualificationPassController = TextEditingController(text: authCon.userDetails['qualification']??"");
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    MyTextField(
                        // controller: _emailController,
                        textInputType: TextInputType.emailAddress,
                        onTap: () {},isReadonly: true,
                        onSubmit: () {},
                        onChanged: (email) {

                        },
                        lableText: jsonDecode(userData)['email'],
                        hintText: '',
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Contact Number',
                      style: TextStyle(
                          color: ColorssA.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    MyTextField(
                        controller: contactController,
                        textInputType: TextInputType.phone,
                        onTap: () {},
                        onSubmit: () {},
                        onChanged: (contact) {
                          authController.addSignupData(
                              "contact", contact);
                        },
                        hintText: '*** ***** *****',
                        titleText: 'Contact Number'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Address',
                      style: TextStyle(
                          color: ColorssA.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    MyTextField(
                        controller: addressController,
                        textInputType: TextInputType.emailAddress,maxLines: 3,
                        onTap: () {},
                        onSubmit: () {},
                        onChanged: (address) {
                          print('onChange-------------- ');
                          authController.addSignupData(
                              "address", address);
                        },
                        hintText: 'Complete address',
                        titleText: 'Complete address'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Edit Password',
                      style: TextStyle(
                          color: ColorssA.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    MyTextField(
                        controller: editPassController,

                        onTap: () {},
                        isPassword: true,
                        isEnabled: true,
                        onSubmit: () {},
                        onChanged: (edit_password) {
                          authController.addSignupData(
                              "edit_password", edit_password);
                        },
                        hintText: '************',
                        maxLines: 1,
                        selectedPass: true,
                        titleText: 'Edit Password'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                          color: ColorssA.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    MyTextField(
                        controller: confirmPassController,

                        onTap: () {},
                        isPassword: true,
                        isEnabled: true,
                        onSubmit: () {},
                        onChanged: (confirm_password) {
                          authController.addSignupData(
                              "confirm_password", confirm_password);
                        },
                        hintText: '************',
                        maxLines: 1,
                        selectedPass: true,
                        titleText: 'Confirm Password'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Qualification',
                      style: TextStyle(
                          color: ColorssA.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    MyTextField(
                        controller: qualificationPassController,
                        onTap: () {},
                        onSubmit: () {},
                        onChanged: (qualification) {
                          authController.addSignupData(
                              "qualification", qualification);
                        },
                        hintText: '',
                        titleText: 'Qualification'),

                     const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Pin Code',
                      style: TextStyle(
                          color: ColorssA.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    MyTextField(
                        controller: pinCode,
                        onTap: () {},
                        onSubmit: () {},
                        onChanged: (pincode) {
                          authController.addSignupData(
                              "pincode", pincode);
                        },
                        hintText: '',textInputType: TextInputType.number,
                        titleText: 'Pincode'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Gender',
                      style: TextStyle(
                          color: ColorssA.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropDown(
                      icon: Container(
                        margin: EdgeInsets.fromLTRB(30, 0, 20, 29),
                        child:Text('bll'),
                      ),
                      hintText: "Select Gender",
                      hintStyle: TextStyle(),
                      items: dropdownItemListType,
                      contentPadding: EdgeInsets.only(
                        left: 20 ,
                        top: 5 ,
                        bottom: 21,
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value; // Update the selected value
                        });
                      },
                    ),
                     const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ButtonWight(
                        buttonText: "Confirm",
                        borderButton: false,
                        width: Get.width * 0.9,
                        height: Get.height * 0.08,
                        loading: authController.isLoading,
                        onClick: () => {
                          _updateProfile(authController)
                          // Get.toNamed(RouteHelper.getSignIn())
                          // Navigator.pop(context)
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
