import 'dart:convert';

Postmodal postFromJson(String str) => Postmodal.fromJson(json.decode(str));

class Postmodal {
  List<PostData>? data;
  bool? status;
  String? message;

  Postmodal({this.data, this.status, this.message});

  Postmodal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PostData>[];
      json['data'].forEach((v) {
        data!.add(new PostData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class PostData {
  dynamic id;
  dynamic name;

  PostData({
    this.id,
    this.name,
  });

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.name;

    return data;
  }
}
