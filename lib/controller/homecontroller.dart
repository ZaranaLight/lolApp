import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lol/Apiservice.dart';
import 'package:http/http.dart' as http;
import 'package:lol/Color.dart';
import 'package:lol/api/responeModel.dart';
import 'package:lol/localDatabse/sqlDatabase.dart';
import 'package:lol/utils/images.dart';
import 'package:lol/widget/Globelnotsuccess.dart';
import 'package:lol/widget/postmodal.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homecontroller extends GetxController {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  var isTextFieldVisible = false.obs;
  var commentName = TextEditingController().obs;
  final storage = GetStorage();

  String get catDropdownvalue => _catDropdownvalue;
  String _catDropdownvalue = 'Select Post Categories';
  var postdata = RxList<Map<String, dynamic>>([]);
  var commentdata = RxList<Map<String, dynamic>>([]);
  var postimage = ''.obs;
  var post = TextEditingController().obs;
  RxBool isLoading = false.obs;
  RxBool isPostLoading = false.obs;
  RxString selectedCategory = ''.obs;
  RxList categories = [].obs;
  var selectedValue = ''.obs; // Initial selected value
  var options = [].obs; // Dropdown options
  RxString PostId = ''.obs;

  void onRefresh() {

    _pageIndex = 1;
    print('============1============');

    getPostdata(isRefresh: true);
  }

  void clear() {
    commentName.value.clear();
  }

  void toggleTextFieldVisibility() {
    isTextFieldVisible.toggle();
  }

  @override
  void onInit() async {
    super.onInit();
    print('============2============');
    await     getPostdata(isRefresh: true);

  }

  @override
  void onReady() async {
    super.onReady();
    await fetchCategories();
    print('============3============');

    // await     getPostdata(isRefresh: true);

  }

  ////////////////  getPostdata  ////////////////

  bool _isApplyLoading = false;

  bool get isApplyLoading => _isApplyLoading;

  bool _isLoading = false;

  bool get isLoadings => _isLoading;

  int get pageIndex => _pageIndex;
  int _pageIndex = 1;

  final RefreshController postRefreshController =
      RefreshController(initialRefresh: true);

  bool _isNoMore = false;

  bool get isNoMore => _isNoMore;

  int get totalPage => _totalPage;
  int _totalPage = 50;

  List<dynamic> get postList => _postList;
  List<dynamic> _postList = [];


  List<dynamic> get offlinePost => _offlinePost;
  List<dynamic> _offlinePost=[
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post1,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.posT2,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post3,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post4,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post5,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post6,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post7,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post8,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post9,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post10,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post11,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post12,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post13,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post14,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post15,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post16,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post17,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post18,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post19,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post20,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post21,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post22,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post23,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post24,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post25,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post26,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post27,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post28,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post29,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post30,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post31,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post32,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post33,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post34,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post35,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post36,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post37,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post38,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post39,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post40,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post41,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post42,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post43,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post44,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post45,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post46,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post47,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post48,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post49,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
    {
      "id":"1",
      "c_id":"14",
      "user_id":null,
      "title":null,
      "file":Images.post50,
      "file_type":'image',
      "status":'1',
      "share":'0',
      "created_at":'2 weeks ago',
      "category_name":'हिंदी जोक्स',
      "likes_sum":'0',
      "user_name":null,
      "user_profile":null,
      "commentsCount":0,
      "user_likes_count":0,
    },
  ];


  bool _offlineInternet = false;

  bool get  offlineInternet => _offlineInternet;
  setOfflineStatus(bool newVal)async{
    _offlineInternet = newVal;
    update();
  }

  Future<bool> getPostdata({bool isRefresh = false}) async {
    print('isRefresh-----${isRefresh}');
    if (isRefresh && _pageIndex == 0) {
      _isApplyLoading = true;
      update();
    }
    _isLoading = true;
    update();
    if (isRefresh == false && isNoMore == true) {
      return false;
    }
    if (isRefresh) {
      _pageIndex =1;
    } else {
      if (_pageIndex >= _totalPage) {
        postRefreshController.loadNoData();
        return false;
      }
    }
    print('URL=======${Apiservice.getAllPosts}?page=$_pageIndex');
    var url = '${Apiservice.getAllPosts}?page=$_pageIndex';
    final response = await http.post(
      Uri.parse(url),
      body: {"userid": storage.read("userid").toString()},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if(responseData.isEmpty){
        print('_responseData.isEmpty==========');
        print(responseData.isEmpty);
        _isNoMore = true;
        update();
        return false;
      }
      if (_pageIndex==1&& isRefresh) {

        print('_postList===_postList==========');
        _postList = await responseData['data']['data'];
        _postList.shuffle();
        _isApplyLoading = false;
        update();
      } else {
        print('blabla=============');



        
        print(responseData['data']['data'].length);
        print('test=========================================1');
        print(responseData['data']['data']);
        List temp = responseData['data']['data'];

        print('temp==========${temp}');
        for (int i = 0; i < temp.length; i++) {
          if (!_postList.contains(temp[i]['id'])) {
            _postList.addAll(temp);
            break;
          }
        }
      }
      print('check------------------');
      print('_pageIndex=============${_pageIndex}');
      print('_totalPage=============${_totalPage}');
      print('_totalPage=============${_postList.length}');
      _pageIndex++;
      _totalPage = 50;

      if (response.body.isEmpty) {
        _isNoMore = true;
        update();
        return false;
      }
      _isLoading = false;
      update();
      return true;
    } else {
      print('Failed to getPostdata');

      throw Exception('Failed to getPostdata');
    }
  }
///
//   Future<void> getPostdata({bool isRefresh = false}) async {
//     try {
//       final response = await http.post(
//         Uri.parse(Apiservice.getAllPosts),
//         body: {"userid": storage.read("userid").toString()},
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//
//         if (responseData['status'] == true) {
//           print('---currentPAge----');
//           print(responseData['data']['current_page']);
//           var currentPage = responseData['data']['current_page'];
//           final List<dynamic> postDataList = responseData['data']['data'];
//
//           postimage.value = responseData['file_path'];
//           if (isRefresh) {
//             postdata.clear();
//           }
//           postdata.assignAll(postDataList.cast<Map<String, dynamic>>());
//           if (isRefresh) {
//             refreshController.refreshCompleted();
//           }
//           currentPage=currentPage+1;
//         } else {
//           print('Failed to getPostdata');
//           throw Exception('Failed to getPostdata');
//         }
//       } else {
//         print('Failed to getPostdata');
//         throw Exception('Failed to getPostdata');
//       }
//     } catch (error) {
//       print('Error fetching data in getPostdata: $error');
//     }
//   }

  ////////////  getcommentdata  ////////////////

  Future<void> getcommentdata(String postid) async {
    try {
      final response = await http.post(
        Uri.parse(Apiservice.getCommentById),
        body: {'post_id': postid.toString()},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> commentDataList = responseData['data'];
          commentdata.assignAll(commentDataList.cast<Map<String, dynamic>>());
        } else {
          print('Failed to getcommentdata ');
          throw Exception('Failed to getcommentdata ');
        }
      } else {
        print('Failed to getcommentdata data');
        throw Exception('Failed to getcommentdata ');
      }
    } catch (error) {
      print('Error fetching data in getcommentdata: $error');
    }
  }

  ////////////////  searchdata  ////////////////

  void searchdata() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(Apiservice.getAllPosts),
        body: {
          "c_id": selectedCategory.value,
          "userid": storage.read("userid").toString()
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          final List<dynamic> postDataList = responseData['data']['data'];
          postdata.assignAll(postDataList.cast<Map<String, dynamic>>());

          Get.back();
        } else {
          print('Failed to searchdata ');
          throw Exception('Failed to searchdata ');
        }
      } else {
        print('Failed to searchdata ');
        throw Exception('Failed to searchdata ');
      }
      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      print('Error fetching data in getPostdata: $error');
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

  ////////////////  loadprofilepic  ///////////////

  Future<Image?> loadprofilepic(String image) async {
    isLoading.value = true;
    try {
      // ignore: unnecessary_null_comparison
      if (image == null) {
        return Image.asset(
          'assets/images/user.png',
          height: 5,
          width: 5,
          fit: BoxFit.fitWidth,
        );
      }
      final response = await http.get(Uri.parse(image));
      if (response.statusCode == 200) {
        return Image.network(
          image,
          fit: BoxFit.cover,
        );
      } else if (response.statusCode == 404) {
        isLoading.value = false;
        return Image.asset(
          cacheHeight: 30,
          cacheWidth: 30,
          color: blackColor,
          'assets/images/user.png',
        );
      } else {
        isLoading.value = false;
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (error) {
      isLoading.value = false;
      print('Error loading image: $error');
      // throw Exception('Failed to load image');
    }
    return null;
  }

  ////////////////  postLike  ///////////////

  void postLike(String postid, String toid) async {
    isLoading.value = true;
    print('likeb---------');
    print(storage.read("userid").toString());
    try {
      print(
          'response.statusCode--${postid}--${storage.read("userid").toString()}---${toid}');
      print('rApiservice.postLikee--${Apiservice.postLike}');
      final response = await http.post(
        Uri.parse(Apiservice.postLike),
        body: {
          "post_id": postid,
          "from_id": storage.read("userid").toString(),
          "to_id": toid
        },
      );
      print(
        storage.read("userid").toString(),
      );
      print('response.statusCode--${json.decode(response.body)}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          print("success");
          print('============4============');

          getPostdata();
        } else {
          errorDialog("Already Liked!", "ok");
          throw Exception('Failed to load data');
        }
      } else {
        errorDialog('Something went wrong', "ok");
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      print('Error fetching data in postLike: $error');
    }
  }

  ////////////////  postComment  ///////////////

  void postComment(String postid, String toid,
      {bool clearTextField = false}) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(Apiservice.postComment),
        body: {
          "comments": commentName.value.text,
          "post_id": postid,
          "from_id": storage.read("userid").toString(),
          "to_id": toid
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          commentName.value.text = '';
          Get.back();
          print('============5============');

          getPostdata();
          print("success");
        } else {
          errorDialog('Something went wrong please try again.', "ok");
          print('Failed to load data');
          throw Exception('Failed to load data');
        }
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      print('Error fetching data in postComment: $error');
    }
  }

  ////////////////  postShare  ///////////////

  void postShare(String postid) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(Apiservice.postShare),
        body: {
          "post_id": postid,
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          print('============6============');

          getPostdata();
        } else {
          print('Failed to load data');
          throw Exception('Failed to load data');
        }
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      print('Error fetching data in postShare: $error');
    }
  }

  Future<void> fetchCategories() async {
    try {
      var response = await http.post(Uri.parse(Apiservice.getAllCategory));
      print('getAllCategory--------------');
      print(Uri.parse(Apiservice.getAllCategory));
      print(response.body);
      print(response.statusCode);
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
}
