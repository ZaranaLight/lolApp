import 'dart:convert';
import 'dart:io' as Io;
import 'package:get/get.dart';
import 'package:http/http.dart' as Http;
import 'package:lol/api/api_client.dart';
import 'package:lol/constanmt/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;

  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> registration(Map<String, dynamic> signUpBody) async {
    return await apiClient.postData(AppConstants.register, signUpBody);
  }

  Future<Response> login(
      {required String email, required String password}) async {
    return await apiClient
        .postData(AppConstants.login, {"email": email, "password": password});
  }

  Future<Response> updateProfile(Map<String, dynamic> profileData) async {
    return await apiClient.postData(AppConstants.update_profile, {
      "contact": profileData['contact'],
      "address": profileData['address'],
      "qualification": profileData['qualification'],
      "pincode": profileData['pincode'],
      "gender":'male',
      "id": profileData['id'],
      "email": profileData['email'],
    });
  }

  Future<Response> uploadPost(Map<String, dynamic> postDetail) async {
    return await apiClient.postData(AppConstants.uploadPost, {
      "c_id": postDetail['c_id'],
      "file":postDetail['file'].toString(),
      "user_id": postDetail['id'],
    });
  }

  Future<Response> getProfile(int userId) async {
    return await apiClient.getData('${AppConstants.get_profile}?id=${userId}');
  }

  Future<Response> getAllPosts(int userId) async {
    return await apiClient.getData('${AppConstants.getAllPosts}');
  }

  Future<Response> getCategory() async {
    return await apiClient.getData('${AppConstants.getAllCategory}');
  }

  Future<bool> saveMAil(String email) async {
    return sharedPreferences.setString(AppConstants.EMAIL, email);
  }

  String getUserMail() {
    return sharedPreferences.getString(AppConstants.EMAIL) ?? "";
  }

  Future<bool> saveUserDetails(String userdetails) async {
    return sharedPreferences.setString(AppConstants.USER_DETAILS, userdetails);
  }

  String getUserDetail() {
    return sharedPreferences.getString(AppConstants.USER_DETAILS) ?? "";
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.USER_DETAILS);
    sharedPreferences.remove(AppConstants.EMAIL);
    apiClient.token = null;
    apiClient.reToken = null;
    apiClient.updateHeader(
      "",
      "",
    );
    return true;
  }
}
