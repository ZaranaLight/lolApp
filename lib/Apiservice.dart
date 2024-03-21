class Apiservice {
  static const String BASE_URL = 'https://mcq.codingbandar.com/api/';
  static const String IMAGE_URL =
      'https://mcq.codingbandar.com/front/assets/posts/';
  static var getAllCategory = "${BASE_URL}getAllCategory";
  static var getAllPosts = "${BASE_URL}getAllPosts";
  static var uploadPost = "${BASE_URL}uploadPost";
  static var updateProfile = "${BASE_URL}updateProfile";
  static var login = "${BASE_URL}login";
  static var getUserById = "${BASE_URL}getUserById";
  static var getProfile = "${BASE_URL}getProfile";
  static var postLike = "${BASE_URL}postLike";
  static var postComment = "${BASE_URL}postComment";
  static var postShare = "${BASE_URL}postShare";
  static var updateProfilePicture = "${BASE_URL}updateProfilePicture";
  static var getCommentById = "${BASE_URL}getCommentById";
}
