import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Apiservice.dart';
import '../Color.dart';
import '../Widget/Globelnotsuccess.dart';
import '../Widget/globalsuccess.dart';
import '../Widget/postmodal.dart';

class PostController extends GetxController {
  List<String> selectedPaths = [];
  RxBool isLogoSelected = false.obs;
  RxBool isVideoSelected = false.obs;
  RxString ImagePath = ''.obs;
  var message = TextEditingController().obs;
  Map<String, dynamic> get postData => _postData;
  final Map<String, dynamic> _postData = {};
  var post = TextEditingController();
  PostData? selectedpost;
  final storage = GetStorage();
  var profileimage = TextEditingController().obs;
  RxBool isLoading = false.obs;
  RxString selectedCategory = ''.obs;
  RxList categories = [].obs;
  @override
  void onInit() async {
    super.onInit();
    profileimage.value.text = '${storage.read("profile")}';
    fetchCategories();
  }

  void clean() {
    message.value.clear();
    ImagePath.value = "";
    post.clear();
    message.value.clear();
  }

  ////////////////  chooseLogo  ////////////////

  void chooseLogo() async {
    isLoading.value = true;

    try {
      final pickedFile =
          // ignore: deprecated_member_use
          await ImagePicker().getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        ImagePath.value = pickedFile.path;
        isLogoSelected.value = true;
        isVideoSelected.value = false;
        await uploadImage(File(ImagePath.value));
      }
    } finally {
      isLoading.value = false;
    }
  }

////////////////  chooseVideo  ////////////////

  void chooseVideo() async {
    isLoading.value = true;
    try {
      final pickedFile =
          // ignore: deprecated_member_use
          await ImagePicker().getVideo(source: ImageSource.gallery);

      if (pickedFile != null) {
        isLogoSelected.value = false;
        isVideoSelected.value = true;
        ImagePath.value = pickedFile.path;
        uploadImage(File(ImagePath.value));
      }
    } finally {
      isLoading.value = false;
    }
  }

  ////////////////  getAllCategory  ////////////////

  Future<List<PostData>> getAllCategory(String pattern) async {
    var body = {};
    var urlState = Uri.parse(Apiservice.getAllCategory);
    final response = await http.post(
      urlState,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonData['data'];

      List<PostData> fileList =
          jsonList.map((json) => PostData.fromJson(json)).toList();

      return fileList;
    } else {
      throw Exception('Failed to getAllCategory data');
    }
  }

  Future<void> fetchCategories() async {
    try {
      var response = await http.post(Uri.parse(Apiservice.getAllCategory));
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        print(response.body);
        if (jsonData['status'] == true) {
          categories.clear();
          List<dynamic> categoryData = jsonData['data'];
          categoryData.forEach((category) {
            categories.add(category);
          });
        } else {
          throw Exception('Failed to load categories');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      // print(e);
    }
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }
  ////////////////  uploadpost  ////////////////

  Future<void> uploadpost() async {
    isLoading.value = true;
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(Apiservice.uploadPost));
      if (File(ImagePath.value).existsSync()) {
        File imageFile = File(ImagePath.value);
        request.files
            .add(await http.MultipartFile.fromPath('file', imageFile.path));
      }
      request.fields['c_id'] = selectedCategory.value;
      // if (selectedpost != null) {
      //   request.fields['c_id'] = selectedpost!.id.toString();
      // } else {
      //   request.fields['c_id'] = '';
      // }
      request.fields['user_id'] = storage.read("userid").toString();
      // ignore: unnecessary_null_comparison
      if (message.value.text != null) {
        request.fields['title'] = message.value.text;
      } else {
        request.fields['title'] = '';
      }
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      Map<dynamic, dynamic> map = json.decode(responseString);
      if (response.statusCode == 200) {
        if (map['status'] == true) {
          showSuccessDialog("Upload Successfully", "ok");
          clean();
        } else {
          print(map['error'] ?? '');
          errorDialog('Something went wrong please try again.', "ok");
        }
      } else {}
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("uploadpost " + e.toString());
    }
  }

  ////////////////  uploadImage  ////////////////

  Future<void> uploadImage(File ImagePath) async {
    isLoading.value = true;
    var uri = Uri.parse(Apiservice.uploadPost);
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = storage.read("userid").toString();
    request.files
        .add(await http.MultipartFile.fromPath("file", ImagePath.path));
    try {
      isLoading.value = true;
      var response = await request.send();
      if (response.statusCode == 200) {
        // ignore: unused_local_variable
        String responseString = await response.stream.bytesToString();
      } else {
        print('Failed to upload logo. Status code: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
      }
      isLoading.value = false;
    } catch (error, stacktrace) {
      isLoading.value = false;
      print('Error uploading logo: $error');
      print('Error uploading logo: $stacktrace');
    }
  }

  ////////////////  loadprofilepic  ////////////////

  Future<Image?> loadprofilepic() async {
    try {
      final response = await http
          .get(Uri.parse('${Apiservice.IMAGE_URL}${profileimage.value.text}'));
      if (response.statusCode == 200) {
        return Image.network(
          '${Apiservice.IMAGE_URL}${profileimage.value.text}',
          fit: BoxFit.cover,
        );
      } else if (response.statusCode == 404) {
        return Image.asset(
          cacheHeight: 30,
          cacheWidth: 30,
          color: blackColor,
          'assets/images/user.png',
        );
      } else {
        throw Exception('Failed to loadprofilepic: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading image: $error');
      // throw Exception('Failed to load image');
    }
    return null;
  }
}
