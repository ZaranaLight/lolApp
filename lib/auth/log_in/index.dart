import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lol/controller/authController.dart';
import 'package:lol/helpers/routes_helper.dart';
import 'package:lol/utils/colors.dart';
import 'package:lol/utils/dimentions.dart';
import 'package:lol/utils/styles.dart';
import 'package:lol/widget/myTextFeildWidget.dart';
import 'package:lol/widget/showCustomsnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/images.dart';
import '../../widget/customButton.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  bool _rememberMe = true;

  _loadRememberMePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('_rememberMe============ ${_rememberMe}');
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('customer_unique_id') ?? '';

        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  // Save remember me preference to shared preferences
  _saveRememberMePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      prefs.setString('customer_unique_id', _emailController.text);
      prefs.setString('password', _passwordController.text);
    } else {
      prefs.remove('customer_unique_id');
      prefs.remove('password');
    }
  }

    _logIn(AuthController authController) async {
    String _email = _emailController.text.trim();
    String _password = _passwordController.text.trim();
    print(authController.sigupdata);

    final bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);

    if (_email.isEmpty) {
      showCustomSnackBar('Enter your email address', context);
      return;
    } else if (emailValid == false) {
      showCustomSnackBar('Email id should be valid', context);
    } else if (_password.isEmpty) {
      showCustomSnackBar('Enter your password', context);
      return;
    } else if (_password.length < 6) {
      showCustomSnackBar(
          'Password should be greater than 6 characters', context);
      return;
    } else {
      authController.login(_email,_password, context);
      _emailController.clear();
      _passwordController.clear();
    }
  }

  @override
  void initState() {
    super.initState();

    _loadRememberMePreference();
  }

  @override
  Widget build(BuildContext context) {
    // return GetBuilder<LoginController>(
    builder:
    // (loginController) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: ColorssA.whiteColor,
      body: GetBuilder<AuthController>(
        builder: (authController) {
          return SafeArea(
            child: Stack(
              children: [
                Container(

                  height: Get.height,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Center(
                            child: Image.asset(
                              'assets/images/rat.png',
                              width: 260,
                              height: 250,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Sign In',
                                  style: poppinsMedium.copyWith(
                                      color: ColorssA.blackColor,
                                      fontSize: Dimensions.fontSizeOverLarge,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'E-mail',
                                  style: TextStyle(
                                      color: ColorssA.blackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                MyTextField(
                                    controller: _emailController,
                                    textInputType: TextInputType.emailAddress,
                                    onTap: () {},
                                    onSubmit: () {},
                                    onChanged: (email) {
                                      print('onChange-------------- ');
                                      // loginController.addSigupdata(
                                      //     "email", email);
                                    },
                                    hintText: 'Enter Your Email',
                                    titleText: 'Email'),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Password',
                                  style: TextStyle(
                                      color: ColorssA.blackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                MyTextField(
                                  controller: _passwordController,
                                  onTap: () {},
                                  onSubmit: () {},
                                  onChanged: (password) {
                                    // loginController.addSigupdata(
                                    //     "password", password);
                                  },
                                  hintText: 'Enter Your Password',
                                  titleText: 'Password',
                                  maxLines: 1,
                                  isPassword: true,
                                  selectedPass: true,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _rememberMe = !_rememberMe;
                                            });
                                            _saveRememberMePreference();
                                          },
                                          icon: Icon(
                                            !_rememberMe == false
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Text('Remember Me')
                                      ],
                                    ),
                                    Text('Forgot Password ?')
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: ButtonWight(
                                    buttonText: "Login",
                                    borderButton: false,
                                    width: Get.width * 0.9,
                                    height: Get.height * 0.08,loading: authController.isLoading,
                                    // loading: load,
                                    onClick: () =>
                                        {_logIn(authController)},
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(RouteHelper.getSignUp());
                                  },
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              color: Theme.of(context).hintColor),
                                          children: [
                                            const TextSpan(
                                              text: "Don’t have account ? ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Sign Up',
                                              style: TextStyle(
                                                  color:  ColorssA.blackColor,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Center(
                                  child: Center(
                                    child: Text(
                                      '--- Or login with---',
                                      style: TextStyle(
                                          // color: ColorssA.Black.withOpacity(0.5),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        gradient: ColorssA.AppLinears,
                                        borderRadius: BorderRadius.circular(10)),
                                    padding:
                                        const EdgeInsets.only(left: 0, right: 0),
                                    child: MaterialButton(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Colors.transparent,
                                      // color: Colors.teal[100],
                                      elevation: 0,
                                      onPressed: () {
                                        // loginController.loginWithSignup(context);
                                      },

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            Images.google,
                                            width: 30,
                                            height: 30,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Continue with Google",
                                            style: TextStyle(
                                                color: ColorssA.whiteColor,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
    // }
    // );
  }
}
