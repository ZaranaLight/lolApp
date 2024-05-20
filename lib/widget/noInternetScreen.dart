 import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lol/Apiservice.dart';
import 'package:lol/Color.dart';
import 'package:lol/controller/homecontroller.dart';
import 'package:lol/widget/Globelnotsuccess.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isRefreshing = false;

  Future<void> _checkInternetAndNavigate() async {
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      Get.offAll(() => const NoInternetWidget());
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await _checkInternetAndNavigate();
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<Homecontroller>(
          builder: (homeController) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: Get.width * .91,
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            gradient: AppLinears,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton(
                          dropdownColor: Colors.grey[100],
                          elevation: 4,
                          focusColor: Colors.black,
                          iconDisabledColor: whiteColor,
                          iconEnabledColor: whiteColor,
                          isExpanded: true,
                          value: homeController.selectedCategory.isEmpty
                              ? null
                              : homeController.selectedCategory.value,
                          hint: Text(
                            'Select Category',
                            style: TextStyle(color: whiteColor),
                          ),
                          onChanged: (newValue) {
                            homeController.setSelectedCategory(newValue.toString());
                            homeController.searchdata();
                          },
                          items: homeController.categories
                              .map<DropdownMenuItem<String>>(
                                (dynamic category) {
                              Map<String, dynamic> categoryData = category as Map<
                                  String,
                                  dynamic>; // Cast category to Map<String, dynamic>
                              return DropdownMenuItem<String>(
                                value: categoryData['category_name'],
                                child: Text(
                                  categoryData['category_name'].toString(),
                                  style: TextStyle(
                                    color: homeController.selectedCategory.value ==
                                        categoryData['category_name']
                                        ? Color.fromARGB(255, 228, 228, 228)
                                        : Colors.black,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          underline: Container(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                          width: Get.width,
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                          decoration: BoxDecoration(color: Colors.red),
                          child: Text('no internet connection..!',style: TextStyle(color: Colors.white),)),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 600,
                        child: ListView.builder(
                          // controller: scrollController,
                          addAutomaticKeepAlives: true,
                          physics: BouncingScrollPhysics(),
                          itemCount:homeController.offlinePost.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            var tempindex = index + 1;
                            final post = homeController.offlinePost[index];
                            String shareValue = post["share"].toString();
                            return Container(
                              // height: 380,
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  gradient: (tempindex % 3 == 0)
                                      ? AppLinears3
                                      : (tempindex % 2 == 0)
                                      ? AppLinears2
                                      : AppLinears,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              child: ClipRRect(
                                                child: FutureBuilder(
                                                  future: homeController
                                                      .loadprofilepic(
                                                      '${Apiservice.IMAGE_URL}${post['user_profile']}'),
                                                  builder: (context,
                                                      AsyncSnapshot<Image?>
                                                      snapshot) {
                                                    if (snapshot
                                                        .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                          child:
                                                          CircularProgressIndicator());
                                                    } else if (snapshot
                                                        .hasError) {
                                                      //print('Error loading image: ${snapshot.error}');
                                                      return Image.asset(
                                                        'assets/images/user.png',
                                                        height: 5,
                                                        width: 5,
                                                        // fit: BoxFit.fill,
                                                      );
                                                    } else if (snapshot
                                                        .hasData) {
                                                      return snapshot.data!;
                                                    } else {
                                                      return Image.asset(
                                                        'assets/images/user.png',
                                                        height: 5,
                                                        width: 5,
                                                        // fit: BoxFit.fill,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50),
                                                  color: (tempindex % 3 ==
                                                      0)
                                                      ? Color(0xffE09349)
                                                      : (tempindex % 2 == 0)
                                                      ? Color(
                                                      0xffD8DE3F)
                                                      : Color(
                                                      0xff57B8D6)),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post['user_name'] ?? '',
                                                  style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          IconButton(
                                              onPressed: () async{
                                                errorDialog(
                                                    "Please Try again",
                                                    "ok");
                                              },
                                              icon: Icon(
                                                Icons.save,
                                                color: whiteColor,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (post['title'] != null)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        post['title'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),

                                  InkWell(
                                    onTap: () {

                                    },
                                    child: Container(
                                        height: 220,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color:
                                          whiteColor.withOpacity(0.3),
                                        ),
                                        child:Image.asset(
                                          homeController.offlinePost[index]['file'],
                                          width: Get.width,
                                          fit: BoxFit.cover,
                                          height: Get.height *
                                              0.27,
                                        )),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  errorDialog(
                                                      "Please Try again",
                                                      "ok");
                                                },
                                                child: Icon(
                                                  Icons
                                                      .thumb_up_alt_rounded,
                                                  color:
                                                  post['user_likes_count'] >
                                                      0
                                                      ? primaryColor
                                                      : blackColor,
                                                  size: 23,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                post["likes_sum"]
                                                    .toString(),
                                                style: TextStyle(
                                                  color: blackColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            errorDialog(
                                                "Please Try again",
                                                "ok");
                                          },
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.comment,
                                                  color: blackColor,
                                                  size: 23,
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  post["commentsCount"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: blackColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: post['file_type'] == 'text'
                                              ? InkWell(
                                            onTap: () {
                                              errorDialog(
                                                  "Please Try again",
                                                  "ok");
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.share_sharp,
                                                  color: blackColor,
                                                  size: 23,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  shareValue,
                                                  style: TextStyle(
                                                    color: blackColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                              : GestureDetector(
                                            onTap: () async {
                                              errorDialog(
                                                  "Please Try again",
                                                  "ok");
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.share_sharp,
                                                  color: blackColor,
                                                  size: 23,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  shareValue,
                                                  style: TextStyle(
                                                    color: blackColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 05,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),

    );/*Scaffold(
      body: Center(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.signal_wifi_off,
                  size: 100,
                  color: Colors.red,
                ),
                SizedBox(height: 16),
                Text(
                  "Oops! No internet connection.",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  "Please check your internet connection.",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  "Pull down to refresh.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );*/
  }
}

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<Homecontroller>(
        builder: (homeController) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width * .91,
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          gradient: AppLinears,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton(
                        dropdownColor: Colors.grey[100],
                        elevation: 4,
                        focusColor: Colors.black,
                        iconDisabledColor: whiteColor,
                        iconEnabledColor: whiteColor,
                        isExpanded: true,
                        value: homeController.selectedCategory.isEmpty
                            ? null
                            : homeController.selectedCategory.value,
                        hint: Text(
                          'Select Category',
                          style: TextStyle(color: whiteColor),
                        ),
                        onChanged: (newValue) {
                          homeController.setSelectedCategory(newValue.toString());
                          homeController.searchdata();
                        },
                        items: homeController.categories
                            .map<DropdownMenuItem<String>>(
                              (dynamic category) {
                            Map<String, dynamic> categoryData = category as Map<
                                String,
                                dynamic>; // Cast category to Map<String, dynamic>
                            return DropdownMenuItem<String>(
                              value: categoryData['category_name'],
                              child: Text(
                                categoryData['category_name'].toString(),
                                style: TextStyle(
                                  color: homeController.selectedCategory.value ==
                                      categoryData['category_name']
                                      ? Color.fromARGB(255, 228, 228, 228)
                                      : Colors.black,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        underline: Container(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: Get.width,
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        decoration: BoxDecoration(color: Colors.red),
                        child: Text('no internet connection..!',style: TextStyle(color: Colors.white),)),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 550,
                      child: ListView.builder(
                        // controller: scrollController,
                        addAutomaticKeepAlives: true,
                        physics: BouncingScrollPhysics(),
                        itemCount:homeController.offlinePost.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          var tempindex = index + 1;
                          final post = homeController.offlinePost[index];
                          String shareValue = post["share"].toString();
                          return Container(
                            // height: 380,
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                                gradient: (tempindex % 3 == 0)
                                    ? AppLinears3
                                    : (tempindex % 2 == 0)
                                    ? AppLinears2
                                    : AppLinears,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            child: ClipRRect(
                                              child: FutureBuilder(
                                                future: homeController
                                                    .loadprofilepic(
                                                    '${Apiservice.IMAGE_URL}${post['user_profile']}'),
                                                builder: (context,
                                                    AsyncSnapshot<Image?>
                                                    snapshot) {
                                                  if (snapshot
                                                      .connectionState ==
                                                      ConnectionState
                                                          .waiting) {
                                                    return const Center(
                                                        child:
                                                        CircularProgressIndicator());
                                                  } else if (snapshot
                                                      .hasError) {
                                                    //print('Error loading image: ${snapshot.error}');
                                                    return Image.asset(
                                                      'assets/images/user.png',
                                                      height: 5,
                                                      width: 5,
                                                      // fit: BoxFit.fill,
                                                    );
                                                  } else if (snapshot
                                                      .hasData) {
                                                    return snapshot.data!;
                                                  } else {
                                                    return Image.asset(
                                                      'assets/images/user.png',
                                                      height: 5,
                                                      width: 5,
                                                      // fit: BoxFit.fill,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    50),
                                                color: (tempindex % 3 ==
                                                    0)
                                                    ? Color(0xffE09349)
                                                    : (tempindex % 2 == 0)
                                                    ? Color(
                                                    0xffD8DE3F)
                                                    : Color(
                                                    0xff57B8D6)),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post['user_name'] ?? '',
                                                style: TextStyle(
                                                    color: whiteColor,
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () async{
                                              errorDialog(
                                                  "Please Try again",
                                                  "ok");
                                            },
                                            icon: Icon(
                                              Icons.save,
                                              color: whiteColor,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                if (post['title'] != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      post['title'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),

                                InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                      height: 220,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color:
                                        whiteColor.withOpacity(0.3),
                                      ),
                                      child:Image.asset(
                                        homeController.offlinePost[index]['file'],
                                        width: Get.width,
                                        fit: BoxFit.cover,
                                        height: Get.height *
                                            0.27,
                                      )),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                errorDialog(
                                                    "Please Try again",
                                                    "ok");
                                              },
                                              child: Icon(
                                                Icons
                                                    .thumb_up_alt_rounded,
                                                color:
                                                post['user_likes_count'] >
                                                    0
                                                    ? primaryColor
                                                    : blackColor,
                                                size: 23,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              post["likes_sum"]
                                                  .toString(),
                                              style: TextStyle(
                                                color: blackColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          errorDialog(
                                              "Please Try again",
                                              "ok");
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.comment,
                                                color: blackColor,
                                                size: 23,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                post["commentsCount"]
                                                    .toString(),
                                                style: TextStyle(
                                                  color: blackColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: post['file_type'] == 'text'
                                            ? InkWell(
                                          onTap: () {
                                            errorDialog(
                                                "Please Try again",
                                                "ok");
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.share_sharp,
                                                color: blackColor,
                                                size: 23,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                shareValue,
                                                style: TextStyle(
                                                  color: blackColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                            : GestureDetector(
                                          onTap: () async {
                                            errorDialog(
                                                "Please Try again",
                                                "ok");
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.share_sharp,
                                                color: blackColor,
                                                size: 23,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                shareValue,
                                                style: TextStyle(
                                                  color: blackColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 05,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
