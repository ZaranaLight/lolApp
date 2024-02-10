import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lol/api/responeModel.dart';
import 'package:lol/helpers/routes_helper.dart';
import 'package:lol/repo/authRepo.dart';
import 'package:lol/widget/showCustomsnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo,
  });

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  Map<String, dynamic> get sigupdata => _sigupdata;
  Map<String, dynamic> _sigupdata = {};

  // Map<String, dynamic> get sigupdata => _userdata;
  // Map<String, dynamic> _sigupdata = {};

  String get userID => _userID;
  String _userID = '';

  Map<String, dynamic> get userDetails => _userDetails;
  Map<String, dynamic> _userDetails = {};

  Map<String, dynamic> get homeDetails => _homeDetails;
  Map<String, dynamic> _homeDetails = {};

  List<dynamic> get homeList => _homeList;
  List<dynamic> _homeList = [];

  String _userData = "";

  String get userData => _userData;

  void addSignupData(String key, dynamic value) {
    _sigupdata[key] = value;
    update();
  }

  Future<ResponseModel> registration(
      Map<String, dynamic> signUpBody, BuildContext context) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    ResponseModel responseModel;

    if (response.statusCode == 200) {
      print('resssss=${response.body}');
      print('status=${response.body['status']}');
      responseModel =
          ResponseModel(true, response.body["message"] ?? "", response.body);
      if (response.body['status'] == 400) {
        showCustomSnackBar(response.body['errors'].values.first[0], context,
            isError: true);
      } else if (response.body['status'] == 200) {
        Get.toNamed(RouteHelper.getSignIn());
      }
    } else if (response.statusCode == 400) {
      showCustomSnackBar(
          response.body['errors']["email"].values.first[0], context,
          isError: true);
      responseModel = ResponseModel(false, response.statusText!, {});
    } else {
      if (response.body["success"] == false) {
        showCustomSnackBar(response.statusText!, context, isError: true);
      } else {
        showCustomSnackBar(response.statusText!, context, isError: true);
      }

      responseModel = ResponseModel(false, response.statusText!, {});
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(email: email, password: password);

    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (response.body['status'] == false) {
        showCustomSnackBar(response.body['error'], context, isError: true);
      } else if (response.body['status'] == true) {
        print('userData==========${response.body}');

        await authRepo.saveMAil(jsonEncode(email));
        await authRepo.saveUserDetails(jsonEncode(response.body['data']));
        var data = authRepo.getUserDetail();
        print('data==========${data}');
        showCustomSnackBar(response.body['message'], context, isError: false);
        Get.toNamed(RouteHelper.getDashboard());
        _isLoading = false;
        update();
      }
      responseModel = ResponseModel(false, response.statusText!, {});
    } else if (response.statusCode == 404) {
      showCustomSnackBar(
          "We're sorry, but something went wrong. Please try again", context,
          isError: true);
      responseModel = ResponseModel(false, response.statusText!, {});
    } else {
      print('---------check-----------ResponseModel-');

      showCustomSnackBar(response.body["message"], context, isError: true);
      responseModel = ResponseModel(false, response.statusText!, {});
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> profile(
      Map<String, dynamic> userProfile, BuildContext context) async {
    _isLoading = true;
    update();
    Response response = await authRepo.updateProfile(userProfile);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      print("UserUpdate=================");
      print(response.body);
      if (response.body['status'] == false) {
        showCustomSnackBar(response.body['error'], context, isError: true);
      } else if (response.body['status'] == 200) {
        showCustomSnackBar(response.body['message'], context, isError: true);
      }

      responseModel =
          ResponseModel(true, '${response.body['message']}', response.body);
    } else {
      responseModel = ResponseModel(false, response.statusText!, {});
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getProfile() async {
    var userData = authRepo.getUserDetail();
    _isLoading = true;
    update();
    Response response = await authRepo.getProfile(jsonDecode(userData)['id']);
    if (response.statusCode == 200) {
      _userDetails = response.body['user'];
print('chaec=======${_userDetails}');
      update();
    } else {}
    _isLoading = false;
    update();
  }

  Future<void> getHome() async {
    print('home getHome=-=== }');
    _isLoading = true;
    update();
    Response response = await authRepo.getHome();
    print('response.statusCode -=== ${response.statusCode }');
    print('response.statusCode -=== ${response.body }');

    if (response.statusCode == 200) {
      if(response.body['status']==200){
        _homeDetails = response.body;
        _homeList = response.body['result'];
        print('home list=-===${_homeList}');
      }

      update();
    } else {}
    _isLoading = false;
    update();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  clearsigupdata() async {

    _userData = '';
    _sigupdata = {};
    _homeDetails = {};
    update();
  }
}
