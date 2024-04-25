// ignore_for_file: avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lol/widget/globalLogoutDialog.dart';
import 'package:lol/widget/globalRadiobutton.dart';
import 'Color.dart';
import 'controller/Profilecontroller.dart';

class MyProfile extends StatelessWidget {
  MyProfile({Key? key});
  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      body: Obx(
        () => profileController.isLoading.value
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Loading please wait..."),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    profileController.Changeprofile();
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff4675B8),
                                          Color(0xff57B8D6)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Obx(
                                        () {
                                          final key =
                                              UniqueKey(); // Create a unique key for the FutureBuilder

                                          return FutureBuilder(
                                            key:
                                                key, // Set the key for the FutureBuilder
                                            future: profileController
                                                .loadprofilepic(
                                                    profileController
                                                        .profileImage.value),
                                            builder: (context,
                                                AsyncSnapshot<Image?>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Image.asset(
                                                  'assets/images/user.png',
                                                  height: 5,
                                                  width: 5,
                                                );
                                              } else if (snapshot.hasData) {
                                                // Display the loaded image
                                                return snapshot.data!;
                                              } else {
                                                // Default case, when there's no data
                                                return Image.asset(
                                                  'assets/images/user.png',
                                                  height: 5,
                                                  width: 5,
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => Text(
                                          profileController.ProfileName.value,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          profileController.ProfileEmail.value,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    showLogoutDialog(
                                        "Are you sure for log out");
                                  },
                                  child: Icon(
                                    Icons.logout,
                                    color: errorColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              color: Colors.blue,
                              thickness: 2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Column(
                              children: [
                                Obx(
                                  () => TextField(
                                    controller: profileController.name.value,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelText: 'Name',
                                      hintText: 'Enter Your Name',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => TextField(
                                    controller: profileController.email.value,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelText: 'Email',
                                      hintText: 'Enter Your Email',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => TextField(
                                    cursorColor: Colors.black,
                                    controller: profileController.contact.value,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelText: 'Contact',
                                      hintText: 'Enter Your Contact Number',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => TextField(
                                    controller: profileController.address.value,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelText: 'Address',
                                      hintText: 'Enter Your Address',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => TextField(
                                    controller:
                                        profileController.password.value,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelText: 'Update Password',
                                      hintText: 'Update Password',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Obx(
                                  () => TextField(
                                    controller: profileController.pincode.value,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelText: 'Pin Code',
                                      hintText: 'Pincode',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: RadioOptionsWidget(
                                    title: 'Gender :',
                                    options: const ['male', 'female'],
                                    selectedOption: profileController.Gender,
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        profileController.Gender.value = value;
                                      }
                                    },
                                  ),
                                ),
                                Obx(
                                  () => TextField(
                                    controller:
                                        profileController.qualification.value,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      labelText: 'Qualification',
                                      hintText: 'Qualification',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff4675B8),
                                    Color(0xff57B8D6)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  profileController.updateProfile();
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
              ),
      ),
    );
  }
}
