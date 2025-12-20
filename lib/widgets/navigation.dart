import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mechine_test/app_theme/appcolor.dart';
import 'package:mechine_test/view/home_screen.dart';
import 'package:mechine_test/view/myorder_screen.dart';
import 'package:mechine_test/view/profile_screen.dart';
import 'package:mechine_test/view/wishlist_screen.dart';

class MainNavigationController extends GetxController {
  final selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}

class MainNavigationScreen extends GetView<MainNavigationController> {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MainNavigationController());

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomePage(),
            MyOrdersPage(),
            WishlistScreen(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index) {
          controller.changeTabIndex(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'My Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
