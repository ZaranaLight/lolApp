import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/Profilecontroller.dart';
import 'controller/homecontroller.dart';
import 'home.dart';
import 'post.dart';
import 'profile.dart';

class MyBottombar extends StatelessWidget {
  final PageController _pageController = PageController();
  final RxInt _selectedIndex = 0.obs;

  final ProfileController profileController = Get.put(ProfileController());
  final Homecontroller homecontroller = Get.put(Homecontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: [
            MyHome(),
            MyPost(),
            MyProfile(),
          ],
          onPageChanged: (index) {
            _selectedIndex.value = index;
            if (index == 0) {
              homecontroller.getPostdata();
            } else if (index == 2) {
              profileController.getUserId();
            }
            _selectedIndex.value = index;
          },
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex.value,
            onTap: (index) {
              _selectedIndex.value = index;
              if (index == 0) {
                homecontroller.getPostdata();
              } else if (index == 2) {
                profileController.getUserId();
              }
              _selectedIndex.value = index;
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline_sharp),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
