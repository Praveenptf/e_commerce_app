import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechine_test/models/user_models.dart';
import 'package:mechine_test/service/api_service.dart';

import '../controller/auth_controller.dart';

class ProfileController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  void loadUser() {
    user.value = AuthService.getCurrentUser();
  }

  void showEditProfile() {
    Get.snackbar('Info', 'Edit profile coming soon');
  }

  Future<void> logout() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final authController = Get.put(AuthController());
              await authController.logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
