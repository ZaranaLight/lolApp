import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lol/utils/colors.dart';
import 'package:lol/utils/dimentions.dart';
import 'package:lol/utils/images.dart';
import 'package:lol/utils/styles.dart';
import 'package:lol/widget/customButton.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({super.key});

  @override
  Widget build(BuildContext context) {
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
                          margin: EdgeInsets.symmetric(
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
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                hintText: 'Write here...',
                                enabledBorder: InputBorder.none),
                          ),
                          Spacer(),
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.photo),
                                Icon(Icons.slow_motion_video),
                                Icon(Icons.gif_box_outlined),
                                Icon(Icons.music_note),
                                Spacer(),
                                Icon(Icons.emoji_emotions_outlined),
                              ],
                            ),
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
                          Text('Post Privacy'),
                          SizedBox(width: 15,),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  Text('Public'),
                                  Icon(Icons.arrow_drop_down_sharp)
                                ],
                              )), SizedBox(width: 15,),
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
                      Get.back()
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
  }
}
