import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lol/controller/authController.dart';
import 'package:lol/utils/colors.dart';
import 'package:lol/utils/dimentions.dart';
import 'package:lol/utils/images.dart';
import 'package:lol/utils/styles.dart';
import 'package:lol/widget/customButton.dart';
import 'package:lol/widget/dropDownWidget.dart';
import 'package:lol/widget/showCustomsnackBar.dart';
import 'package:video_player/video_player.dart';

class CreatePost extends StatefulWidget {
  CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
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

  TextEditingController descController = TextEditingController();

  void _updatePost(AuthController authController) async {
    print(authController.sigupdata);

    if (descController.text.isEmpty) {
      showCustomSnackBar('Please Enter Text For Upload Post.', context);
      return;
    } else {
      var userData = authController.authRepo.getUserDetail();
      authController.addPostData('c_id', '1');
      authController.addPostData('id', jsonDecode(userData)['id']);
      authController.addPostData('user_id', jsonDecode(userData)['id']);
      authController.addPostData('title', descController.text);
      authController.addPostData('file', pickedImage?.path);
      authController.uploadPost(authController.postData, context);
    }
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

  List selecterArray = [];
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

  VideoPlayerController? _videoPlayerController;
  File? _video;
  final piker = ImagePicker();

  _pickVideo() async {
    final video = await piker.pickVideo(source: ImageSource.gallery);
    _video = File(video!.path);
    _videoPlayerController = VideoPlayerController.file(_video!)
      ..initialize().then((value) {
        setState(() {});
        _videoPlayerController?.play();
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

  Future uploadPosts(/*String title, String body*/) async {
    Map<String, dynamic> req = {
      'id': "1",
      'c_id':"1",
      'title': 'dfsfsdfsf',
      'user_id': "1",
    };
    final uri = Uri.parse("https://mcq.codingbandar.com/api/uploadPost");
    final response = await http.post(uri, body: req);
print('ssssssssss- ${response.statusCode}');
print('ssssssssss- ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load ppost');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorssA.whiteColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Text(
            'Create Post',
            style: poppinsMedium.copyWith(
                color: ColorssA.blackColor,
                fontSize: Dimensions.fontSizeExtraLarge,
                fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: Get.height * .7,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: ColorssA.AppLinears,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
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
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shalini Chauhan',
                                  style: poppinsMedium.copyWith(
                                      color: ColorssA.whiteColor,
                                      fontSize: Dimensions.fontSizeLarge,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: Get.height * 0.5,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Select Category',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: () {
                                      showNEFTFilterPopup(context);
                                    },
                                    child: Container(
                                      width: Get.width * 0.3,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          gradient: ColorssA.AppLinears,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              authController.catDropdownvalue ==
                                                      'Select Type'
                                                  ? 'Categories'
                                                  : authController
                                                      .catDropdownvalue,
                                              style: TextStyle(
                                                  color: ColorssA.whiteColor),
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
                                ),
                              ],
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                  hintText: 'Write here...',
                                  enabledBorder: InputBorder.none),
                              controller: descController,
                              onSubmitted: (val) {
                                authController.addPostData('title', val);
                              },
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                pickImage(authController);
                              },
                              child: Container(
                                  child: pickedImage == null
                                      ? const Column(
                                          children: [
                                            Center(
                                              child: Icon(
                                                Icons.cloud_upload,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'Upload Here..',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            )
                                          ],
                                        )
                                      : Center(
                                          child: Image.file(
                                            File(pickedImage!.path).absolute,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                            ),
                            InkWell(
                              onTap: () {
                                _pickVideo();
                              },
                              child: Container(
                                  child: _video == null
                                      ? Container()
                                      : _videoPlayerController!
                                              .value.isInitialized
                                          ? AspectRatio(
                                              aspectRatio:
                                                  _videoPlayerController!
                                                      .value.aspectRatio,
                                              child: VideoPlayer(
                                                  _videoPlayerController!),
                                            )
                                          : Container()),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      pickImage(authController);
                                    },
                                    child: Icon(Icons.photo)),
                                InkWell(
                                    onTap: () {
                                      _pickVideo();
                                    },
                                    child: Icon(Icons.slow_motion_video)),
                                Icon(Icons.gif_box_outlined),
                                Icon(Icons.music_note),
                                Spacer(),
                                Icon(Icons.emoji_emotions_outlined),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Post Privacy'),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Row(
                                  children: [
                                    Text('Public'),
                                    Icon(Icons.arrow_drop_down_sharp)
                                  ],
                                )),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonWight(
                      buttonText: "Cancel",
                      borderButton: false,
                      width: Get.width * 0.4,
                      height: Get.height * 0.07,
                      // loading: load,
                      onClick: () => {
                        Get.back()
                        // Navigator.pop(context)
                      },
                    ),
                    ButtonWight(
                      buttonText: "Publish",
                      borderButton: false,
                      width: Get.width * 0.4,
                      height: Get.height * 0.07,
                      // loading: load,
                      onClick: () => {
                        // uploadPosts()
                        _updatePost(authController)
                        // Navigator.pop(context)
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
