import 'dart:io';

import 'package:get/get.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../Apiservice.dart';
import '../Widget/Globelnotsuccess.dart';
import '../Widget/globalsuccess.dart';
import 'postcontroller.dart';

class ProfileController extends GetxController {
  RxString profileImage = RxString('');
  RxString ProfileEmail = "".obs;
  RxString ProfileName = "".obs;
  final storage = GetStorage();
  var Gender = 'male'.obs;
  var email = TextEditingController().obs;
  var name = TextEditingController().obs;
  var contact = TextEditingController().obs;
  var password = TextEditingController().obs;
  var address = TextEditingController().obs;
  var pincode = TextEditingController().obs;
  var qualification = TextEditingController().obs;
  RxBool isLoading = false.obs;

  void clear() {}

  void onInit() async {
    super.onInit();
    getUserId();
  }

  //////////////////// updateProfile ////////////////////////

  void updateProfile() async {
    try {
      isLoading.value = true;
      final response =
          await http.post(Uri.parse(Apiservice.updateProfile), body: {
        'id': storage.read("userid").toString(),
        'email': email.value.text,
        'name': name.value.text,
        'contact': contact.value.text,
        'address': address.value.text,
        'password': password.value.text,
        'pincode': pincode.value.text,
        'gender': Gender.value.toString(),
        'qualification': qualification.value.text,
      });

      Map<dynamic, dynamic> map = json.decode(response.body);

      if (response.statusCode == 200) {
        if (map['status'] == true) {
          showSuccessDialog("Update Successfully", "ok");
          getUserId();
        } else {
          errorDialog("Please Try Again", "ok");
        }
      } else {
        // ServerError();
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('Error: in updateProfile $e');
    }
  }

  //////////////////// getUserId ////////////////////////

  Future<void> getUserId() async {
    try {
      final response = await http.post(
        Uri.parse(Apiservice.getUserById),
        body: {"id": storage.read("userid").toString()},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> userData = responseData['data'] ?? '';
        name.value.text = userData['name'] ?? '';
        email.value.text = userData['email'] ?? '';
        contact.value.text = userData['contact'] ?? '';
        address.value.text = userData['address'] ?? '';
        pincode.value.text = userData['pincode'] ?? '';
        Gender.value = userData['gender'].toString();
        qualification.value.text = userData['qualification'] ?? '';
        profileImage.value =
            Apiservice.IMAGE_URL + userData['profile'].toString();
        ProfileEmail.value = userData['email'] ?? "";
        ProfileName.value = userData['name'] ?? "";
        storage.write("username", userData['name'] ?? '');
        if (responseData['status'] == true) {
          print("getUserId Success");
        } else {
          print('Failed to getUserId data');
          throw Exception('Failed to getUserId data');
        }
      } else {
        print('Failed to getUserId data');
        throw Exception('Failed to getUserId data');
      }
    } catch (error) {
      print('Error fetching data in getUserId: $error');
    }
  }

  //////////////////// loadprofilepic ////////////////////////

  Future<Image?> loadprofilepic(String image) async {
    try {
      // ignore: unnecessary_null_comparison
      if (image == null) {
        return Image.asset(
          'assets/images/user.png',
          height: 5,
          width: 5,
        );
      }
      final response = await http.get(Uri.parse(profileImage.value));
      if (response.statusCode == 200) {
        return Image.network(
          image,
          height: 5,
          width: 5,
          fit: BoxFit.cover,
        );
      } else if (response.statusCode == 404) {
        return Image.asset(
          'assets/images/user.png',
          cacheHeight: 30,
          cacheWidth: 30,
        );
      } else {
        throw Exception(
            'Failed to load loadprofilepic: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading loadprofilepic: $error');
      // throw Exception('Failed to load image');
    }
    return null;
  }

  //////////////////// Changeprofile ////////////////////////

  void Changeprofile() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      isLoading.value = true;
      var request = http.MultipartRequest(
          'POST', Uri.parse(Apiservice.updateProfilePicture));
      if (File(pickedFile!.path).existsSync()) {
        File imageFile = File(pickedFile.path);
        request.files
            .add(await http.MultipartFile.fromPath('profile', imageFile.path));
      }

      request.fields['id'] = storage.read("userid").toString();

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      Map<dynamic, dynamic> map = json.decode(responseString);

      if (response.statusCode == 200) {
        if (map['status'] == true) {
          final PostController postController = Get.put(PostController());
          postController.profileimage.value.text = map['data']['profile'];
          storage.write("profile", map['data']['profile']);
          profileImage.value =
              '${Apiservice.IMAGE_URL}${map['data']['profile']}';
          showSuccessDialog("Profile updated Successfully", "ok");
        } else {
          errorDialog('Something went wrong please try again.', "ok");
        }
      } else {}
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Changeprofile " + e.toString());
    }
  }
}
