class PostModel {
  final String? id;
  final String? c_id;
  final String? user_id;
  final String? title;
  final String? file;
  final int? file_type;
  final String? status;
  final String? share;
  final String? created_at;
  final String? category_name;
  final String? likes_sum;
  final String? user_name;
  final String? user_profile;
  final String? commentsCount;
  final String? user_likes_count;

  PostModel({
    this.id,
    this.c_id,
    this.user_id,
    this.title,
    this.file,
    this.file_type,
    this.status,
    this.share,
    this.created_at,
    this.category_name,
    this.likes_sum,
    this.user_name,
    this.user_profile,
    this.commentsCount,
    this.user_likes_count,
  });

  PostModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        c_id = res["c_id"],
        user_id = res["user_id"],
        title = res["title"],
        file = res["file"],
        file_type = res["file_type"],
        status = res["status"],
        share = res["share"],
        created_at = res["created_at"],
        category_name = res["category_name"],
        likes_sum = res["likes_sum"],
        user_name = res["user_name"],
        user_profile = res["user_profile"],
        commentsCount = res["commentsCount"],
        user_likes_count = res["user_likes_count"];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'c_id': c_id,
      'user_id': user_id,
      'title': title,
      'file': file,
      'file_type': file_type,
      'status': status,
      'share': share,
      'created_at': created_at,
      'category_name': category_name,
      'likes_sum': likes_sum,
      'user_name': user_name,
      'user_profile': user_profile,
      'commentsCount': commentsCount,
      'user_likes_count': user_likes_count,

    };
  }
  @override
  String toString() {
    return 'PostModel{'
        'id:$id,'
        'c_id:$c_id,'
        'user_id:$user_id,'
        'title:$title,'
        'file:$file,'
        'file_type:$file_type,'
        'status:$status,'
        'share:$share,'
        'created_at:$created_at,'
        'category_name:$category_name,'
        'likes_sum:$likes_sum,'
        'user_name:$user_name,'
        'user_profile:$user_profile,'
        'commentsCount:$commentsCount,'
        'user_likes_count:$user_likes_count,'
        '}';
  }


}
