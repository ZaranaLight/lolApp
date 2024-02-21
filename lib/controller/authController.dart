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

  Map<String, dynamic> get postData => _postData;
  Map<String, dynamic> _postData = {};

  String get userID => _userID;
  String _userID = '';

  Map<String, dynamic> get userDetails => _userDetails;
  Map<String, dynamic> _userDetails = {};

  Map<String, dynamic> get catDetails => _catDetails;
  Map<String, dynamic> _catDetails = {};

  String _userData = "";
  String get userData => _userData;

  void addSignupData(String key, dynamic value) {
    _sigupdata[key] = value;
    update();
  }
  void addPostData(String key, dynamic value) {
    _postData[key] = value;
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
      if (response.body['status'] == false) {
        showCustomSnackBar(response.body['error'], context, isError: true);
      } else if (response.body['status'] == 200 || response.body['status'] == true) {
        showCustomSnackBar('Profile Updated Succefully', context, isError: false);
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


  Future<ResponseModel> uploadPost(
      Map<String, dynamic> postDetail, BuildContext context) async {
    var userData = authRepo.getUserDetail();
    print('userData==============${jsonDecode(userData)}');
    print('postDetail==============${postDetail}');
    postDetail['id']=jsonDecode(userData)['id'];
    _isLoading = true;
    update();
    Response response = await authRepo.uploadPost(postDetail);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (response.body['status'] == false) {
        showCustomSnackBar(response.body['error'], context, isError: true);
      } else if (response.body['status'] == 200 || response.body['status'] == true) {
        showCustomSnackBar('Profile Updated Succefully', context, isError: false);
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
      update();
    } else {}
    _isLoading = false;
    update();
  }
  Future<void> getAllPosts() async {
    var userData = authRepo.getUserDetail();
    _isLoading = true;
    update();
    Response response = await authRepo.getAllPosts(jsonDecode(userData)['id']);
    if (response.statusCode == 200) {
      _userDetails = response.body['user'];
      update();
    } else {}
    _isLoading = false;
    update();
  }

  // Future<void> getHome() async {
  //   print('home getHome=-=== }');
  //   _isLoading = true;
  //   update();
  //   Response response = await authRepo.getHome();
  //
  //   if (response.statusCode == 200) {
  //     if(response.body['status']==200){
  //       _homeDetails = response.body;
  //       _homeList = response.body['result'];
  //       print('home list=-===${_homeList}');
  //     }
  //
  //     update();
  //   } else {}
  //   _isLoading = false;
  //   update();
  // }
  List  _catList = [];

  List  get catList => _catList;

  Map<String, dynamic> get catDropdown =>
      _catDropdown;
  Map<String, dynamic> _catDropdown = {};

  String get catDropdownvalue => _catDropdownvalue;
  String _catDropdownvalue = 'Select Type';

  setCategoryDropdownDetail(BuildContext context, String id, category_name,status) {
    _catDropdown['id'] = id;
    _catDropdown['category_name'] = category_name;
    _catDropdown['status'] = status;
    update();
  }

  setCatVal(String newVal){
    print('newnal-------${newVal}');
    _catDropdownvalue=newVal;
    update();
  }
  addDropdowndata(String key, dynamic value) {
    _catDropdown[key] = value;
    update();
  }
  Map<String, dynamic> get selectedEnterpriseList => _selectedEnterpriseList;
  Map<String, dynamic> _selectedEnterpriseList = {};
  List<dynamic> _specialist = [];
  List<dynamic> get specialist => _specialist;
  Future<void> getCategory() async {
    _isLoading = true;
    update();
    Response response = await authRepo.getCategory();
    if (response.statusCode == 200) {
      if(response.body['status']==true){
        _catDetails = response.body;
        print('_catDetails===${_catDetails}');
        List<String> items = [];
        List<String> idList = [];
        for (var element in _catDetails['data']) {
          items.add(element["category_name"]);
        }
        for (var element in  _catDetails['data']) {
          idList.add(element["id"].toString());
        }
        _selectedEnterpriseList['category_name']=items;
        _selectedEnterpriseList['id']=idList;
        _catList=items;

        print('items===${items}');
        print('_catList===${_catList}');

        update();
      }

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
    _catDetails = {};
    update();
  }
}
