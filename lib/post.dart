// ignore_for_file: sort_child_properties_last, unnecessary_string_interpolations, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'Color.dart';
import 'controller/postcontroller.dart';

class MyPost extends StatelessWidget {
  const MyPost({Key? key});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.put(PostController());
    final storage = GetStorage();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff4675B8), Color(0xff57B8D6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 16.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 50,
                          height: 50,
                          child: FutureBuilder(
                            future: postController.loadprofilepic(),
                            builder: (context, AsyncSnapshot<Image?> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                //print('Error loading image: ${snapshot.error}');
                                return Image.asset(
                                  'assets/images/user.png',
                                  cacheHeight: 30,
                                  cacheWidth: 30,
                                  // fit: BoxFit.fill,
                                );
                              } else if (snapshot.hasData) {
                                return snapshot.data!;
                              } else {
                                return Image.asset(
                                  'assets/images/user.png',
                                  cacheHeight: 30,
                                  cacheWidth: 30,
                                  // fit: BoxFit.fill,
                                );
                              }
                            },
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xff57B8D6)),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            storage.read("username") ?? '',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Expanded(
                    child: Container(
                      // width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Obx(
                                  () => DropdownButton(
                                    isExpanded: true,
                                    value: postController
                                            .selectedCategory.isEmpty
                                        ? null
                                        : postController.selectedCategory.value,
                                    hint: Text('Select Category'),
                                    onChanged: (newValue) {
                                      postController.setSelectedCategory(
                                          newValue.toString());
                                      print(postController
                                          .selectedCategory.value);
                                    },
                                    items: postController.categories
                                        .map<DropdownMenuItem<String>>(
                                      (dynamic category) {
                                        // Cast category to dynamic
                                        Map<String, dynamic> categoryData =
                                            category as Map<String,
                                                dynamic>; // Cast category to Map<String, dynamic>
                                        return DropdownMenuItem<String>(
                                          value: categoryData['category_name'],
                                          child: Text(
                                              categoryData['category_name']
                                                  .toString()),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),

                                // GlobalTypeAheadField<PostData>(
                                //   isEnabled: true,
                                //   hint: 'Select Type',
                                //   label: 'Select Type',
                                //   controller: postController.post,
                                //   fetchSuggestions: (pattern) async {
                                //     return await postController.getAllCategory(
                                //       pattern,
                                //     );
                                //     // Corrected method name
                                //   },
                                //   itemBuilder: (context, suggestion) {
                                //     return ListTile(
                                //       title: Text(suggestion.name ?? ''),
                                //     );
                                //   },
                                //   onSuggestionSelected: (suggestion) {
                                //     postController.selectedpost = suggestion;
                                //     postController.post.text = suggestion.name;
                                //   },
                                // ),
                                TextField(
                                  controller: postController.message.value,
                                  decoration: const InputDecoration(
                                      hintText: 'Write here...',
                                      enabledBorder: InputBorder.none),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Obx(() => postController
                                            .isLogoSelected.value
                                        ? Container(
                                            //height: 280,
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              image: DecorationImage(
                                                image: FileImage(
                                                  File(postController
                                                      .ImagePath.value),
                                                ),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            "${postController.ImagePath.value}")),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /////////////////////////////////////////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  postController.chooseLogo();
                                },
                                icon: const Icon(
                                  Icons.photo,
                                ),
                                color: blackColor,
                                iconSize: 30.0,
                              ),
                              IconButton(
                                onPressed: () {
                                  postController.chooseVideo();
                                },
                                icon: const Icon(
                                  Icons.play_circle_outline_sharp,
                                ),
                                color: Colors.black,
                                iconSize: 30.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff4675B8), Color(0xff57B8D6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MaterialButton(
                  onPressed: () {
                    postController.clean();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff4675B8), Color(0xff57B8D6)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MaterialButton(
                  onPressed: () {
                    postController.uploadpost();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: const Text(
                    'Publish',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
