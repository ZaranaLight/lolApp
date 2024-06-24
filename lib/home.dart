import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';
import 'package:lol/localDatabse/sqlDatabase.dart';
import 'package:lol/widget/Globelnotsuccess.dart';
import 'package:lol/widget/globalsuccess.dart';
import 'package:lol/widget/noInternetScreen.dart';
import 'package:lol/widget/videoplayer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'Apiservice.dart';
import 'Color.dart';
import 'controller/homecontroller.dart';
import 'package:http/http.dart' as http;

class MyHome extends StatefulWidget {
  MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  VideoPlayerController? _videoPlayerController;
  bool showShimmer = true;
var home = Get.find<Homecontroller>();
  Future<void> _checkInternetAndNavigate() async {
    final result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      home.offlinePost.shuffle();
      // Get.offAll(() => const NoInternetScreen());
      setState(() {
        home.setOfflineStatus(true);
      });
    } else {

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     dbHelper.initDB();
    _checkInternetAndNavigate();

    if(home.postList.isNotEmpty){
      home.postList.shuffle();
    }
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showShimmer = false;
        });
      }
    });
    getPostData();

  }

  DBHelper dbHelper = DBHelper();
  List postL = [];

  getPostData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    postL = [];

    var sdf = dbHelper.getTodos();
    dbHelper.getTodos();
    sdf.then((value) async {
      if (value.isEmpty) {

        postL.addAll(value);

      } else {


        postL = value;
        print('postL================456${postL}');


        setState(() {});
      }
    });
  }

  ScrollController scrollController = ScrollController(
    initialScrollOffset: 10, // or whatever offset you wish
    keepScrollOffset: true,
  );
dynamic temp;
dynamic selCat;
List postLi = [];

    filterProductsByPrice( ) {
    setState(() {
      // Use the 'where' method to filter products by price

      postLi = home.postList
          .where((product) =>
      product['category_name']==home.selectedCategory.value)
          .toList();
      print('postLi=====${postLi}');
    });
  }



  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return GetBuilder<Homecontroller>(builder: (homecontroller) {

      return Scaffold(
          body: FocusDetector(
            onFocusGained: ()async{
              temp = await Connectivity().checkConnectivity();
               _checkInternetAndNavigate();
            },
            child:  (temp == ConnectivityResult.none  ) ?
            SafeArea(
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
                          value: homecontroller.selectedCategory.isEmpty
                              ? null
                              : homecontroller.selectedCategory.value,
                          hint: Text(
                            'Select Category',
                            style: TextStyle(color: whiteColor),
                          ),
                          onChanged: (newValue) {

                            print('newValue.toString()=1==${newValue.toString()}');
                            filterProductsByPrice( );

                            homecontroller.setSelectedCategory(newValue.toString());
                            homecontroller.searchdata();
                          },
                          items: homecontroller.categories
                              .map<DropdownMenuItem<String>>(
                                (dynamic category) {
                              Map<String, dynamic> categoryData = category as Map<
                                  String,
                                  dynamic>; // Cast category to Map<String, dynamic>
                              print('categoryData====${categoryData}');
                              return DropdownMenuItem<String>(
                                value: categoryData['category_name'],
                                child: Text(
                                  categoryData['category_name'].toString(),
                                  style: TextStyle(
                                    color: homecontroller.selectedCategory.value ==
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
                          controller: scrollController,
                          addAutomaticKeepAlives: true,
                          physics: BouncingScrollPhysics(),
                          itemCount:homecontroller.offlinePost.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            var tempindex = index + 1;
                            final post = homecontroller.offlinePost[index];
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
                                                  future: homecontroller
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
                                          homecontroller.offlinePost[index]['file'],
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
                                              homecontroller.isLoading
                                                  .value = true;
                                              homecontroller
                                                  .postShare(post[
                                              'id']
                                                  .toString());
                                              String imagePath =
                                                  '${Apiservice.IMAGE_URL}${post['file'].toString()}';
                                              Uint8List bytes;

                                              try {
                                                homecontroller
                                                    .isLoading
                                                    .value = true;
                                                http.Response
                                                response =
                                                await http.get(
                                                    Uri.parse(
                                                        imagePath));
                                                bytes = response
                                                    .bodyBytes;
                                              } catch (e) {
                                                homecontroller
                                                    .isLoading
                                                    .value = false;
                                                // Handle the exception, e.g., fallback to a default image URL
                                                imagePath =
                                                'https://mcq.codingbandar.com/front/assets/posts/212112.jpg';
                                                http.Response
                                                response =
                                                await http.get(
                                                    Uri.parse(
                                                        imagePath));
                                                bytes = response
                                                    .bodyBytes;
                                              }
                                              homecontroller.isLoading
                                                  .value = true;
                                              // Save the image to a temporary file
                                              Directory tempDir =
                                              await getTemporaryDirectory();
                                              File tempFile =
                                              File('');
                                              homecontroller.isLoading
                                                  .value = false;
                                              if (post['file_type'] ==
                                                  'image') {
                                                tempFile = File(
                                                    '${tempDir.path}/image.jpg');
                                              } else if (post[
                                              'file_type'] ==
                                                  'video') {
                                                tempFile = File(
                                                    '${tempDir.path}/video.mp4');
                                              } else if (post[
                                              'file_type'] ==
                                                  'gif') {
                                                tempFile = File(
                                                    '${tempDir.path}/image.jpg');
                                              }
                                              homecontroller.isLoading
                                                  .value = true;
                                              if (post['file_type'] !=
                                                  'text') {
                                                await tempFile
                                                    .writeAsBytes(
                                                    bytes);
                                              }

                                              // Convert File to XFile
                                              XFile xFile = XFile(
                                                  tempFile.path);

                                              Share.shareXFiles(
                                                post['file_type'] ==
                                                    'text'
                                                    ? []
                                                    : [xFile],
                                                // Use XFile instead of file path
                                                text: post['title'] ==
                                                    null
                                                    ? null
                                                    : post['title']
                                                    .toString(),
                                                subject: post[
                                                'title'] ==
                                                    null
                                                    ? null
                                                    : post['title']
                                                    .toString(),
                                                sharePositionOrigin:
                                                Rect.fromCenter(
                                                  center:
                                                  Offset(0, 0),
                                                  width: 0,
                                                  height: 0,
                                                ),
                                              );
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
            )
                :Container(
                    margin: const EdgeInsets.all(0),
                    width: double.infinity,
                    height: double.infinity,
                    child: StreamBuilder(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
              // sometimes the stream builder doesn't work with simulator so you can check this on real devices to get the right result
              print(snapshot.toString());
              if (snapshot.hasData) {
                ConnectivityResult? result = snapshot.data;
                if (result == ConnectivityResult.mobile) {
                  return SafeArea(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
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
                                value: homecontroller.selectedCategory.isEmpty
                                    ? null
                                    : homecontroller.selectedCategory.value,
                                hint: Text(
                                  'Select Category',
                                  style: TextStyle(color: whiteColor),
                                ),
                                onChanged: (newValue) {
                                  print('newValue.toString()2===${newValue.toString()}');
                                  filterProductsByPrice( );

                                  homecontroller
                                      .setSelectedCategory(newValue.toString());
                                  homecontroller.searchdata();
                                },
                                items: homecontroller.categories
                                    .map<DropdownMenuItem<String>>(
                                  (dynamic category) {
                                    Map<String, dynamic> categoryData = category
                                        as Map<String,
                                            dynamic>; // Cast category to Map<String, dynamic>
                                    return DropdownMenuItem<String>(
                                      value: categoryData['category_name'],
                                      child: Text(
                                        categoryData['category_name'].toString(),
                                        style: TextStyle(
                                          color: homecontroller
                                                      .selectedCategory.value ==
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
                            SizedBox(
                              height: Get.height * .8,
                              child: homecontroller.postList.length == 0
                                  ? Container(
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    )
                                  : SmartRefresher(
                                      controller:
                                          homecontroller.postRefreshController,
                                      enablePullUp: true,
                                      onRefresh: () async {
                                        if(home.postList.isNotEmpty){
                                          home.postList.shuffle();
                                        }
                                        dynamic result;
                                        if (homecontroller.pageIndex == 0 &&
                                            homecontroller.postList.isEmpty) {
                                          result = homecontroller.getPostdata(
                                              isRefresh: true);
                                        }

                                        if (result == true) {
                                          homecontroller.postRefreshController
                                              .refreshCompleted();
                                        } else {
                                          homecontroller.postRefreshController
                                              .refreshFailed();
                                        }
                                      },
                                      onLoading: () async {
                                        final result = homecontroller.getPostdata(
                                            isRefresh: false);
                                        if (result == true) {
                                          homecontroller.postRefreshController
                                              .loadComplete();
                                        } else {
                                          homecontroller.postRefreshController
                                              .loadFailed();
                                        }
                                      },
                                      // onRefresh: homecontroller.onRefresh,EasyRefresh
                                      child: ListView.builder(
                                        controller: scrollController,
                                        addAutomaticKeepAlives: true,
                                        itemCount: homecontroller.postList.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var tempindex = index + 1;
                                          final post =
                                              homecontroller.postList[index];
                                          String shareValue =
                                              post["share"].toString();
                                          return Container(
                                            // height: 380,
                                            margin:
                                                const EdgeInsets.only(bottom: 15),
                                            decoration: BoxDecoration(
                                                gradient: (tempindex % 3 == 0)
                                                    ? AppLinears3
                                                    : (tempindex % 2 == 0)
                                                        ? AppLinears2
                                                        : AppLinears,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Container(
                                                            width: 50,
                                                            height: 50,
                                                            child: ClipRRect(
                                                              child:
                                                                  FutureBuilder(
                                                                future: homecontroller
                                                                    .loadprofilepic(
                                                                        '${Apiservice.IMAGE_URL}${post['user_profile']}'),
                                                                builder: (context,
                                                                    AsyncSnapshot<
                                                                            Image?>
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
                                                                    return Image
                                                                        .asset(
                                                                      'assets/images/user.png',
                                                                      height: 5,
                                                                      width: 5,
                                                                      // fit: BoxFit.fill,
                                                                    );
                                                                  } else if (snapshot
                                                                      .hasData) {
                                                                    return snapshot
                                                                        .data!;
                                                                  } else {
                                                                    return Image
                                                                        .asset(
                                                                      'assets/images/user.png',
                                                                      height: 5,
                                                                      width: 5,
                                                                      // fit: BoxFit.fill,
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50),
                                                                    color: (tempindex %
                                                                                3 ==
                                                                            0)
                                                                        ? Color(
                                                                            0xffE09349)
                                                                        : (tempindex % 2 ==
                                                                                0)
                                                                            ? Color(
                                                                                0xffD8DE3F)
                                                                            : Color(
                                                                                0xff57B8D6)),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 15),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                post['user_name'] ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        IconButton(
                                                            onPressed: () async {
                                                              homecontroller
                                                                  .isLoading
                                                                  .value = true;
                                                              try {
                                                                String imagePath =
                                                                    '${Apiservice.IMAGE_URL}${post['file'].toString()}';
                                                                http.Response
                                                                    response =
                                                                    await http.get(
                                                                        Uri.parse(
                                                                            imagePath));
                                                                Uint8List bytes =
                                                                    response
                                                                        .bodyBytes;

                                                                //Get the download directory path
                                                                Directory
                                                                    downloadDir =
                                                                    (await getDownloadsDirectory()) ??
                                                                        Directory(
                                                                            '/default/path');

                                                                File tempFile =
                                                                    File('');
                                                                if (post[
                                                                        'file_type'] ==
                                                                    'image') {
                                                                  tempFile = File(
                                                                      '${downloadDir.path}/image.jpg');
                                                                } else if (post[
                                                                        'file_type'] ==
                                                                    'video') {
                                                                  tempFile = File(
                                                                      '${downloadDir.path}/video.mp4');
                                                                } else if (post[
                                                                        'file_type'] ==
                                                                    'gif') {
                                                                  tempFile = File(
                                                                      '${downloadDir.path}/image.jpg');
                                                                }
                                                                await tempFile
                                                                    .writeAsBytes(
                                                                        bytes);

                                                                showSuccessDialog(
                                                                    "Save Successfully",
                                                                    "ok");
                                                                print(
                                                                    'Image downloaded and saved to: ${tempFile.path}');
                                                              } catch (e) {
                                                                homecontroller
                                                                        .isLoading
                                                                        .value =
                                                                    false;
                                                                errorDialog(
                                                                    "Please Try again",
                                                                    "ok");
                                                                print(
                                                                    'Error downloading image: $e');
                                                              } finally {
                                                                homecontroller
                                                                        .isLoading
                                                                        .value =
                                                                    false;
                                                              }
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
                                                    padding:
                                                        const EdgeInsets.all(8.0),
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
                                                    post['file_type'] == 'image'
                                                        ? _showImageDialog(
                                                            context,
                                                            '${Apiservice.IMAGE_URL}${post['file'].toString()}')
                                                        : false;
                                                  },
                                                  child: Container(
                                                      height: 220,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: whiteColor
                                                            .withOpacity(0.3),
                                                      ),
                                                      child: post['file'] != ''
                                                          ? post['file_type'] ==
                                                                  'video'
                                                              ? _videoPlayerController ==
                                                                          null ||
                                                                      homecontroller.postList[index]
                                                                              [
                                                                              'file'] ==
                                                                          null
                                                                  ? VideoPlayerWidget(
                                                                      videoUrl: Apiservice
                                                                              .IMAGE_URL +
                                                                          homecontroller.postList[index]
                                                                              [
                                                                              'file'],
                                                                    )
                                                                  : Container()
                                                              : homecontroller.postList[
                                                                              index]
                                                                          [
                                                                          'file'] ==
                                                                      null
                                                                  ? Container() // Display an empty container if image file is null
                                                                  : Image.network(
                                                                      Apiservice
                                                                              .IMAGE_URL +
                                                                          homecontroller.postList[index]
                                                                              [
                                                                              'file'],
                                                                      width: Get
                                                                          .width,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          Get.height *
                                                                              0.27,
                                                        errorBuilder: (BuildContext context,
                                                            Object exception, StackTrace? stackTrace) {
                                                          return Image.asset(
                                                            homecontroller.offlinePost[0]['file'],
                                                            width: Get
                                                                .width,
                                                            fit: BoxFit
                                                                .cover,
                                                            height:
                                                            Get.height *
                                                                0.27,
                                                          );
                                                        },
                                                                    )
                                                          : Container()),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                //homecontroller.getPostdata();

                                                                homecontroller.postLike(
                                                                    post['id']
                                                                        .toString(),
                                                                    post['user_id']
                                                                        .toString());
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .thumb_up_alt_rounded,
                                                                color: post['user_likes_count'] >
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
                                                          homecontroller
                                                              .getcommentdata(
                                                                  post['id']
                                                                      .toString())
                                                              .then((value) =>
                                                                  Get.bottomSheet(Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      children: [
                                                                        Container(
                                                                            height:
                                                                                500,
                                                                            decoration: BoxDecoration(
                                                                                color: whiteColor,
                                                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
                                                                            child: Column(children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(12.0),
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: dialpgColor),
                                                                                  height: 4,
                                                                                  width: 70,
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(bottom: 90),
                                                                                  child: Container(
                                                                                    height: 400,
                                                                                    decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
                                                                                    child: SingleChildScrollView(
                                                                                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                                                                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                                        ListView.builder(
                                                                                            physics: NeverScrollableScrollPhysics(),
                                                                                            itemCount: homecontroller.commentdata.length,
                                                                                            shrinkWrap: true,
                                                                                            itemBuilder: (BuildContext context, int index) {
                                                                                              final comment = homecontroller.commentdata[index];

                                                                                              return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                                Expanded(
                                                                                                  flex: 1,
                                                                                                  child: Container(
                                                                                                    padding: EdgeInsets.all(25),
                                                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: blackColor, image: DecorationImage(image: NetworkImage('${Apiservice.IMAGE_URL + comment['user_profile'].toString()}'))),
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(
                                                                                                    flex: 4,
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsets.symmetric(vertical: 10.0),
                                                                                                      child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          RichText(
                                                                                                            text: TextSpan(
                                                                                                              children: <TextSpan>[
                                                                                                                TextSpan(
                                                                                                                  text: '${comment['user_name'] ?? ''}',
                                                                                                                  style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w500),
                                                                                                                ),
                                                                                                                TextSpan(
                                                                                                                  text: "${""}  ${comment['created_at'] ?? ''}",
                                                                                                                  style: TextStyle(color: dialpgColor, fontSize: 13),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            '${comment['comment'] ?? ''}',
                                                                                                            style: TextStyle(color: blackColor.withOpacity(0.8), fontSize: 17),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ))
                                                                                              ]);
                                                                                            }),
                                                                                      ]),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ])),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              12.0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: TextField(
                                                                                  controller: TextEditingController(
                                                                                    text: homecontroller.postList[index]['comment'] ?? '',
                                                                                  ),
                                                                                  onChanged: (value) {
                                                                                    homecontroller.commentName.value.text = value;
                                                                                  },
                                                                                  decoration: InputDecoration(
                                                                                      border: OutlineInputBorder(borderSide: BorderSide(color: blackColor), borderRadius: BorderRadius.circular(15)),
                                                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blackColor), borderRadius: BorderRadius.circular(15)),
                                                                                      filled: true,
                                                                                      fillColor: grayColor,
                                                                                      focusColor: grayColor,
                                                                                      hoverColor: grayColor,
                                                                                      suffixIcon: GestureDetector(
                                                                                        onTap: () {
                                                                                          homecontroller.postComment(
                                                                                            post['id'].toString(),
                                                                                            post['user_id'].toString(),
                                                                                            clearTextField: true,
                                                                                          );
                                                                                        },
                                                                                        child: Icon(Icons.send_sharp),
                                                                                      ),
                                                                                      hintText: 'Add comment...'),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ])).then(
                                                                      (value) {
                                                                    Get.back();
                                                                    Get.back();
                                                                  }));
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
                                                                  color:
                                                                      blackColor,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        child:
                                                            post['file_type'] ==
                                                                    'text'
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      homecontroller
                                                                          .isLoading
                                                                          .value = true;
                                                                      homecontroller
                                                                          .postShare(
                                                                              post['id'].toString());
                                                                      Share.share(post['title'] ==
                                                                              null
                                                                          ? null
                                                                          : post[
                                                                              'title']);
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .share_sharp,
                                                                          color:
                                                                              blackColor,
                                                                          size:
                                                                              23,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Text(
                                                                          shareValue,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                blackColor,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      homecontroller
                                                                          .isLoading
                                                                          .value = true;
                                                                      homecontroller
                                                                          .postShare(
                                                                              post['id'].toString());
                                                                      String
                                                                          imagePath =
                                                                          '${Apiservice.IMAGE_URL}${post['file'].toString()}';
                                                                      Uint8List
                                                                          bytes;

                                                                      try {
                                                                        homecontroller
                                                                            .isLoading
                                                                            .value = true;
                                                                        http.Response
                                                                            response =
                                                                            await http
                                                                                .get(Uri.parse(imagePath));
                                                                        bytes = response
                                                                            .bodyBytes;
                                                                      } catch (e) {
                                                                        homecontroller
                                                                            .isLoading
                                                                            .value = false;
                                                                        // Handle the exception, e.g., fallback to a default image URL
                                                                        imagePath =
                                                                            'https://mcq.codingbandar.com/front/assets/posts/212112.jpg';
                                                                        http.Response
                                                                            response =
                                                                            await http
                                                                                .get(Uri.parse(imagePath));
                                                                        bytes = response
                                                                            .bodyBytes;
                                                                      }
                                                                      homecontroller
                                                                          .isLoading
                                                                          .value = true;
                                                                      // Save the image to a temporary file
                                                                      Directory
                                                                          tempDir =
                                                                          await getTemporaryDirectory();
                                                                      File
                                                                          tempFile =
                                                                          File(
                                                                              '');
                                                                      homecontroller
                                                                          .isLoading
                                                                          .value = false;
                                                                      if (post[
                                                                              'file_type'] ==
                                                                          'image') {
                                                                        tempFile =
                                                                            File(
                                                                                '${tempDir.path}/image.jpg');
                                                                      } else if (post[
                                                                              'file_type'] ==
                                                                          'video') {
                                                                        tempFile =
                                                                            File(
                                                                                '${tempDir.path}/video.mp4');
                                                                      } else if (post[
                                                                              'file_type'] ==
                                                                          'gif') {
                                                                        tempFile =
                                                                            File(
                                                                                '${tempDir.path}/image.jpg');
                                                                      }
                                                                      homecontroller
                                                                          .isLoading
                                                                          .value = true;
                                                                      if (post[
                                                                              'file_type'] !=
                                                                          'text') {
                                                                        await tempFile
                                                                            .writeAsBytes(
                                                                                bytes);
                                                                      }

                                                                      // Convert File to XFile
                                                                      XFile
                                                                          xFile =
                                                                          XFile(tempFile
                                                                              .path);

                                                                      Share
                                                                          .shareXFiles(
                                                                        post['file_type'] ==
                                                                                'text'
                                                                            ? []
                                                                            : [
                                                                                xFile
                                                                              ],
                                                                        // Use XFile instead of file path
                                                                        text: post['title'] ==
                                                                                null
                                                                            ? null
                                                                            : post['title']
                                                                                .toString(),
                                                                        subject: post['title'] ==
                                                                                null
                                                                            ? null
                                                                            : post['title']
                                                                                .toString(),
                                                                        sharePositionOrigin:
                                                                            Rect.fromCenter(
                                                                          center: Offset(
                                                                              0,
                                                                              0),
                                                                          width:
                                                                              0,
                                                                          height:
                                                                              0,
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .share_sharp,
                                                                          color:
                                                                              blackColor,
                                                                          size:
                                                                              23,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Text(
                                                                          shareValue,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                blackColor,
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else if (result == ConnectivityResult.wifi) {
                  return
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
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
                                value: homecontroller.selectedCategory.isEmpty
                                    ? null
                                    : homecontroller.selectedCategory.value,
                                hint: Text(
                                  'Select Category',
                                  style: TextStyle(color: whiteColor),
                                ),
                                onChanged: (newValue) {
                                  print('newValue.toString()3===${newValue.toString()}');
                                  filterProductsByPrice( );

                                  homecontroller.setSelectedCategory(newValue.toString());
                                  homecontroller.searchdata();
                                },
                                items: homecontroller.categories
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
                                          color: homecontroller.selectedCategory.value ==
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
                            SizedBox(
                              height: Get.height * .8,
                              child: homecontroller.postList.length == 0
                                  ? Container(
                                child: Center(child: CircularProgressIndicator()),
                              )
                                  : SmartRefresher(
                                controller: homecontroller.postRefreshController,
                                enablePullUp: true,
                                onRefresh: () async {
                                  dynamic result;
                                  if (homecontroller.pageIndex == 0 &&
                                      homecontroller.postList.isEmpty) {
                                    result =
                                        homecontroller.getPostdata(isRefresh: true);
                                  }

                                  if (result == true) {
                                    homecontroller.postRefreshController
                                        .refreshCompleted();
                                  } else {
                                    homecontroller.postRefreshController
                                        .refreshFailed();
                                  }
                                },
                                onLoading: () async {
                                  final result =
                                  homecontroller.getPostdata(isRefresh: false);
                                  if (result == true) {
                                    homecontroller.postRefreshController
                                        .loadComplete();
                                  } else {
                                    homecontroller.postRefreshController
                                        .loadFailed();
                                  }
                                },
                                // onRefresh: homecontroller.onRefresh,EasyRefresh
                                child: ListView.builder(
                                  controller: scrollController,
                                  addAutomaticKeepAlives: true,
                                  itemCount: homecontroller.postList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    var tempindex = index + 1;
                                    final post = homecontroller.postList[index];
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
                                                          future: homecontroller
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
                                                      onPressed: () async {
                                                        homecontroller
                                                            .isLoading.value = true;
                                                        try {
                                                          String imagePath =
                                                              '${Apiservice.IMAGE_URL}${post['file'].toString()}';
                                                          http.Response response =
                                                          await http.get(
                                                              Uri.parse(
                                                                  imagePath));
                                                          Uint8List bytes =
                                                              response.bodyBytes;

                                                          //Get the download directory path
                                                          Directory downloadDir =
                                                              (await getDownloadsDirectory()) ??
                                                                  Directory(
                                                                      '/default/path');

                                                          File tempFile = File('');
                                                          if (post['file_type'] ==
                                                              'image') {
                                                            tempFile = File(
                                                                '${downloadDir.path}/image.jpg');
                                                          } else if (post[
                                                          'file_type'] ==
                                                              'video') {
                                                            tempFile = File(
                                                                '${downloadDir.path}/video.mp4');
                                                          } else if (post[
                                                          'file_type'] ==
                                                              'gif') {
                                                            tempFile = File(
                                                                '${downloadDir.path}/image.jpg');
                                                          }
                                                          await tempFile
                                                              .writeAsBytes(bytes);

                                                          showSuccessDialog(
                                                              "Save Successfully",
                                                              "ok");
                                                          print(
                                                              'Image downloaded and saved to: ${tempFile.path}');
                                                        } catch (e) {
                                                          homecontroller.isLoading
                                                              .value = false;
                                                          errorDialog(
                                                              "Please Try again",
                                                              "ok");
                                                          print(
                                                              'Error downloading image: $e');
                                                        } finally {
                                                          homecontroller.isLoading
                                                              .value = false;
                                                        }
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
                                              post['file_type'] == 'image'
                                                  ? _showImageDialog(context,
                                                  '${Apiservice.IMAGE_URL}${post['file'].toString()}')
                                                  : false;
                                            },
                                            child: Container(
                                                height: 220,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color:
                                                  whiteColor.withOpacity(0.3),
                                                ),
                                                child: post['file'] != ''
                                                    ? post['file_type'] == 'video'
                                                    ? _videoPlayerController ==
                                                    null ||
                                                    homecontroller.postList[
                                                    index]
                                                    ['file'] ==
                                                        null
                                                    ? VideoPlayerWidget(
                                                  videoUrl: Apiservice
                                                      .IMAGE_URL +
                                                      homecontroller
                                                          .postList[
                                                      index]['file'],
                                                )
                                                    : Container()
                                                    : homecontroller.postList[
                                                index]
                                                ['file'] ==
                                                    null
                                                    ? Container() // Display an empty container if image file is null
                                                    : Image.network(
                                                  Apiservice
                                                      .IMAGE_URL +
                                                      homecontroller
                                                          .postList[
                                                      index]['file'],
                                                  width: Get.width,
                                                  fit: BoxFit.cover,
                                                  height: Get.height *
                                                      0.27,
                                                )
                                                    : Container()),
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
                                                          //homecontroller.getPostdata();

                                                          homecontroller.postLike(
                                                              post['id'].toString(),
                                                              post['user_id']
                                                                  .toString());
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
                                                    homecontroller
                                                        .getcommentdata(
                                                        post['id'].toString())
                                                        .then((value) =>
                                                        Get.bottomSheet(Stack(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            children: [
                                                              Container(
                                                                  height: 500,
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                      whiteColor,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              40),
                                                                          topRight: Radius.circular(
                                                                              40))),
                                                                  child: Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              12.0),
                                                                          child:
                                                                          Container(
                                                                            decoration:
                                                                            BoxDecoration(borderRadius: BorderRadius.circular(20), color: dialpgColor),
                                                                            height:
                                                                            4,
                                                                            width:
                                                                            70,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                          Padding(
                                                                            padding:
                                                                            EdgeInsets.only(bottom: 90),
                                                                            child:
                                                                            Container(
                                                                              height: 400,
                                                                              decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
                                                                              child: SingleChildScrollView(
                                                                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                                                                                child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                                  ListView.builder(
                                                                                      physics: NeverScrollableScrollPhysics(),
                                                                                      itemCount: homecontroller.commentdata.length,
                                                                                      shrinkWrap: true,
                                                                                      itemBuilder: (BuildContext context, int index) {
                                                                                        final comment = homecontroller.commentdata[index];

                                                                                        return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Container(
                                                                                              padding: EdgeInsets.all(25),
                                                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: blackColor, image: DecorationImage(image: NetworkImage('${Apiservice.IMAGE_URL + comment['user_profile'].toString()}'))),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                              flex: 4,
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    RichText(
                                                                                                      text: TextSpan(
                                                                                                        children: <TextSpan>[
                                                                                                          TextSpan(
                                                                                                            text: '${comment['user_name'] ?? ''}',
                                                                                                            style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.w500),
                                                                                                          ),
                                                                                                          TextSpan(
                                                                                                            text: "${""}  ${comment['created_at'] ?? ''}",
                                                                                                            style: TextStyle(color: dialpgColor, fontSize: 13),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      '${comment['comment'] ?? ''}',
                                                                                                      style: TextStyle(color: blackColor.withOpacity(0.8), fontSize: 17),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ))
                                                                                        ]);
                                                                                      }),
                                                                                ]),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ])),
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    12.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                      TextField(
                                                                        controller:
                                                                        TextEditingController(
                                                                          text: homecontroller.postList[index]['comment'] ??
                                                                              '',
                                                                        ),
                                                                        onChanged:
                                                                            (value) {
                                                                          homecontroller
                                                                              .commentName
                                                                              .value
                                                                              .text = value;
                                                                        },
                                                                        decoration: InputDecoration(
                                                                            border: OutlineInputBorder(borderSide: BorderSide(color: blackColor), borderRadius: BorderRadius.circular(15)),
                                                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blackColor), borderRadius: BorderRadius.circular(15)),
                                                                            filled: true,
                                                                            fillColor: grayColor,
                                                                            focusColor: grayColor,
                                                                            hoverColor: grayColor,
                                                                            suffixIcon: GestureDetector(
                                                                              onTap: () {
                                                                                homecontroller.postComment(
                                                                                  post['id'].toString(),
                                                                                  post['user_id'].toString(),
                                                                                  clearTextField: true,
                                                                                );
                                                                              },
                                                                              child: Icon(Icons.send_sharp),
                                                                            ),
                                                                            hintText: 'Add comment...'),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ])).then((value) {
                                                          Get.back();
                                                          Get.back();
                                                        }));
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
                                                      homecontroller.isLoading
                                                          .value = true;
                                                      homecontroller
                                                          .postShare(post[
                                                      'id']
                                                          .toString());
                                                      Share.share(post[
                                                      'title'] ==
                                                          null
                                                          ? null
                                                          : post['title']);
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
                                                      homecontroller.isLoading
                                                          .value = true;
                                                      homecontroller
                                                          .postShare(post[
                                                      'id']
                                                          .toString());
                                                      String imagePath =
                                                          '${Apiservice.IMAGE_URL}${post['file'].toString()}';
                                                      Uint8List bytes;

                                                      try {
                                                        homecontroller
                                                            .isLoading
                                                            .value = true;
                                                        http.Response
                                                        response =
                                                        await http.get(
                                                            Uri.parse(
                                                                imagePath));
                                                        bytes = response
                                                            .bodyBytes;
                                                      } catch (e) {
                                                        homecontroller
                                                            .isLoading
                                                            .value = false;
                                                        // Handle the exception, e.g., fallback to a default image URL
                                                        imagePath =
                                                        'https://mcq.codingbandar.com/front/assets/posts/212112.jpg';
                                                        http.Response
                                                        response =
                                                        await http.get(
                                                            Uri.parse(
                                                                imagePath));
                                                        bytes = response
                                                            .bodyBytes;
                                                      }
                                                      homecontroller.isLoading
                                                          .value = true;
                                                      // Save the image to a temporary file
                                                      Directory tempDir =
                                                      await getTemporaryDirectory();
                                                      File tempFile =
                                                      File('');
                                                      homecontroller.isLoading
                                                          .value = false;
                                                      if (post['file_type'] ==
                                                          'image') {
                                                        tempFile = File(
                                                            '${tempDir.path}/image.jpg');
                                                      } else if (post[
                                                      'file_type'] ==
                                                          'video') {
                                                        tempFile = File(
                                                            '${tempDir.path}/video.mp4');
                                                      } else if (post[
                                                      'file_type'] ==
                                                          'gif') {
                                                        tempFile = File(
                                                            '${tempDir.path}/image.jpg');
                                                      }
                                                      homecontroller.isLoading
                                                          .value = true;
                                                      if (post['file_type'] !=
                                                          'text') {
                                                        await tempFile
                                                            .writeAsBytes(
                                                            bytes);
                                                      }

                                                      // Convert File to XFile
                                                      XFile xFile = XFile(
                                                          tempFile.path);

                                                      Share.shareXFiles(
                                                        post['file_type'] ==
                                                            'text'
                                                            ? []
                                                            : [xFile],
                                                        // Use XFile instead of file path
                                                        text: post['title'] ==
                                                            null
                                                            ? null
                                                            : post['title']
                                                            .toString(),
                                                        subject: post[
                                                        'title'] ==
                                                            null
                                                            ? null
                                                            : post['title']
                                                            .toString(),
                                                        sharePositionOrigin:
                                                        Rect.fromCenter(
                                                          center:
                                                          Offset(0, 0),
                                                          width: 0,
                                                          height: 0,
                                                        ),
                                                      );
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  print('no internet');
                  return
                    SafeArea(
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
                                  value: homecontroller.selectedCategory.isEmpty
                                      ? null
                                      : homecontroller.selectedCategory.value,
                                  hint: Text(
                                    'Select Category',
                                    style: TextStyle(color: whiteColor),
                                  ),
                                  onChanged: (newValue) {

                                    print('newValue.toString()4===${newValue.toString()}');
                                    filterProductsByPrice( );

                                    homecontroller.setSelectedCategory(newValue.toString());
                                    homecontroller.searchdata();
                                  },
                                  items: homecontroller.categories
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
                                            color: homecontroller.selectedCategory.value ==
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
                                  controller: scrollController,
                                  addAutomaticKeepAlives: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount:homecontroller.offlinePost.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    var tempindex = index + 1;
                                    final post = homecontroller.offlinePost[index];
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
                                                          future: homecontroller
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
                                                  homecontroller.offlinePost[index]['file'],
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
                                                      homecontroller.isLoading
                                                          .value = true;
                                                      homecontroller
                                                          .postShare(post[
                                                      'id']
                                                          .toString());
                                                      String imagePath =
                                                          '${Apiservice.IMAGE_URL}${post['file'].toString()}';
                                                      Uint8List bytes;

                                                      try {
                                                        homecontroller
                                                            .isLoading
                                                            .value = true;
                                                        http.Response
                                                        response =
                                                        await http.get(
                                                            Uri.parse(
                                                                imagePath));
                                                        bytes = response
                                                            .bodyBytes;
                                                      } catch (e) {
                                                        homecontroller
                                                            .isLoading
                                                            .value = false;
                                                        // Handle the exception, e.g., fallback to a default image URL
                                                        imagePath =
                                                        'https://mcq.codingbandar.com/front/assets/posts/212112.jpg';
                                                        http.Response
                                                        response =
                                                        await http.get(
                                                            Uri.parse(
                                                                imagePath));
                                                        bytes = response
                                                            .bodyBytes;
                                                      }
                                                      homecontroller.isLoading
                                                          .value = true;
                                                      // Save the image to a temporary file
                                                      Directory tempDir =
                                                      await getTemporaryDirectory();
                                                      File tempFile =
                                                      File('');
                                                      homecontroller.isLoading
                                                          .value = false;
                                                      if (post['file_type'] ==
                                                          'image') {
                                                        tempFile = File(
                                                            '${tempDir.path}/image.jpg');
                                                      } else if (post[
                                                      'file_type'] ==
                                                          'video') {
                                                        tempFile = File(
                                                            '${tempDir.path}/video.mp4');
                                                      } else if (post[
                                                      'file_type'] ==
                                                          'gif') {
                                                        tempFile = File(
                                                            '${tempDir.path}/image.jpg');
                                                      }
                                                      homecontroller.isLoading
                                                          .value = true;
                                                      if (post['file_type'] !=
                                                          'text') {
                                                        await tempFile
                                                            .writeAsBytes(
                                                            bytes);
                                                      }

                                                      // Convert File to XFile
                                                      XFile xFile = XFile(
                                                          tempFile.path);

                                                      Share.shareXFiles(
                                                        post['file_type'] ==
                                                            'text'
                                                            ? []
                                                            : [xFile],
                                                        // Use XFile instead of file path
                                                        text: post['title'] ==
                                                            null
                                                            ? null
                                                            : post['title']
                                                            .toString(),
                                                        subject: post[
                                                        'title'] ==
                                                            null
                                                            ? null
                                                            : post['title']
                                                            .toString(),
                                                        sharePositionOrigin:
                                                        Rect.fromCenter(
                                                          center:
                                                          Offset(0, 0),
                                                          width: 0,
                                                          height: 0,
                                                        ),
                                                      );
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
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
                    ),
                  ),
          )

          );
    });
  }

  showNEFTFilterPopup(BuildContext context) {
    var selectedValue = 'Option 1'; // Initial selected value
    var options = ['Option 1', 'Option 2', 'Option 3']; // Dropdown options

    // final Homecontroller homecontroller = Get.put(Homecontroller());
    return showFilterInPopUp(
      context,
      child: StatefulBuilder(builder: (BuildContext context, setState) {
        return GetBuilder<Homecontroller>(builder: (authController) {
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
                  // GetBuilder<Homecontroller>(builder: (homecontroller) {
                  //   return DropdownButton<Category>(
                  //     hint: Text('Select Category'),
                  //     onChanged: (Category? newValue) {
                  //       print(newValue);
                  //     },
                  //     items: homecontroller.categories.map((Category category) {
                  //       return DropdownMenuItem<Category>(
                  //         value: category,
                  //         child: Text(category.categoryName),
                  //       );
                  //     }).toList(),
                  //   );
                  // }),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    elevation: 0,
                    color: dialpgColor,
                    disabledColor: dialpgColor,
                    focusColor: dialpgColor,
                    onPressed: () {
                      // if (homecontroller.selectedpost != null) {
                      //   String selectedPostName =
                      //       homecontroller.selectedpost?.name;
                      //   homecontroller.searchdata();
                      // }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }

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
}

void _showImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    barrierLabel: 'Custom barrier label',
    barrierColor: Colors.black.withOpacity(0.8),
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.all(0),
        child: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: PhotoViewGallery.builder(
            itemCount: 1,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.zero,
              shape: BoxShape.rectangle,
              color: Colors.transparent,
            ),
            pageController: PageController(),
          ),
        ),
      );
    },
  );
}
