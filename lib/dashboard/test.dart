import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lol/utils/colors.dart';
import 'package:lol/utils/dimentions.dart';
import 'package:lol/utils/styles.dart';

class CreatePost extends StatelessWidget {
  const CreatePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorssA.whiteColor,
        title: Text(
          'Create Post',
          style: poppinsMedium.copyWith(
              color: ColorssA.blackColor,
              fontSize: Dimensions.fontSizeExtraLarge,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          Icon(
            Icons.close,
            color: ColorssA.blackColor,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorssA.dialpgColor.withOpacity(0.2),
                      ),
                      child: Icon(
                        Icons.person,
                        color: ColorssA.blackColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sachin jain',
                            style: poppinsMedium.copyWith(
                                color: ColorssA.blackColor,
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .disabledColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.add_circle,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Public'),
                                Icon(Icons.arrow_drop_down),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                width: Get.width,
                child: Center(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLines: 2,

                    // controller: widget.controller,
                    // focusNode: widget.focusNode,

                    // obscureText: widget.isPassword! ? obscureText! : false,
                    decoration: InputDecoration(
                      hintText: 'What is on your mind?',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.person_pin),
                      ),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Theme.of(context).hintColor.withOpacity(0.3),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.9),
                    ),
                    // onTap: () => widget.onTap!(),
                    // onSubmitted: (text) => widget.nextFocus != null
                    //     ? FocusScope.of(context).requestFocus(widget.nextFocus)
                    //     : widget.onSubmit != null
                    //     ? widget.onSubmit!(text)
                    //     : null,
                    // onChanged: widget.onChanged!,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: Get.width,
                    height: Get.height * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ColorssA.dialpgColor.withOpacity(0.05),
                      border: Border.all(
                          color: ColorssA.dialpgColor.withOpacity(0.3),
                          width: 1.5),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network('https://images.unsplash.com/photo-1607355739828-0bf365440db5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1444&q=80',fit: BoxFit.cover,)),
                  ),
                  Positioned(
                    left: 30,
                    top: 10,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorssA.whiteColor),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.edit),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  // width: 70,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorssA.whiteColor),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.add_box),
                                      Text('Add Photos/Videos'),
                                    ],
                                  ),
                                ),
                                // Spacer(),
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.close,color: ColorssA.whiteColor,))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 130,
                          ),
                          Column(
                            children: [
                              Container(
                                width: Get.width * 0.82,
                                height: Get.height * 0.07,
                                decoration: BoxDecoration(
                                  color: ColorssA.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text(
                                      'Add Your Post',
                                      style: poppinsMedium.copyWith(
                                          color: ColorssA.blackColor,
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: Get.width * 0.82,
                                height: Get.height * 0.06,
                                decoration: BoxDecoration(
                                  color: ColorssA.loginColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Post',
                                    style: poppinsMedium.copyWith(
                                        color: ColorssA.whiteColor,
                                        fontSize: Dimensions.fontSizeDefault,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
