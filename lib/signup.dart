import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/Signupcontroller.dart';
import 'controller/homecontroller.dart';
import 'login.dart';

class MySignUp extends StatelessWidget {
  final SignUpController signUpController = Get.put(SignUpController());
  final Homecontroller homecontroller = Get.put(Homecontroller());
  MySignUp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () => signUpController.isLoading.value
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Loading please wait..."),
                    ],
                  ),
                )
              : Center(
                  heightFactor: 1.4,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/logo-2.png',
                          height: 200.0,
                          width: 200.0,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextField(
                          controller: signUpController.name.value,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Name',
                            hintText: 'Enter Your Name',
                            suffixIcon: Icon(
                              Icons.man,
                              size: 23,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: signUpController.email,
                          keyboardType: TextInputType.emailAddress,

                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Email',
                            hintText: 'Enter Your Email',
                            suffixIcon: Icon(
                              Icons.email_rounded,
                              size: 23,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => TextField(
                            keyboardType: TextInputType.text,
                            obscureText: !signUpController.passwordVisible,
                            controller: signUpController.password,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              labelText: 'Password',
                              hintText: 'Enter Your Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  signUpController.passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  signUpController.togglePasswordVisibility();
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xff4675B8), Color(0xff57B8D6)],
                                // stops: [0,0.8],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              homecontroller.getPostdata();
                              signUpController.register();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[800],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(const MyLogin());
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Center(
                          child: Text(
                            'By Signing up you agree with our T&C and privacy policy',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
