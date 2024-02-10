import 'package:get/get.dart';
import 'package:lol/auth/log_in/index.dart';
import 'package:lol/auth/sign_up/index.dart';
import 'package:lol/dashboard/createPost.dart';
import 'package:lol/dashboard/home_page.dart';
import 'package:lol/dashboard/profile_page.dart';
import 'package:lol/splash/index.dart';

import '../dashboard/bottomBar.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String signUp = '/signUp';
  static const String signIn = '/signIn';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String createPost = '/createPost';
  static const String profilePage = '/profilePage';

  static String getSplash() => '$splash';

  static String getSignUp() => '$signUp';

  static String getSignIn() => '$signIn';
  static String getDashboard() => '$dashboard';
  static String getHome() => '$home';
  static String getCreatePost() => '$createPost';
  static String getProfilePage() => '$profilePage';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: signUp, page: () => SignupScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: dashboard, page: () => BottomNavigationBarApp()),
    GetPage(name: createPost, page: () => CreatePost()),
    GetPage(name: profilePage, page: () => ProfilePage()),
  ];
}
