import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechine_test/app_theme/appcolor.dart';
import 'package:mechine_test/controller/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile'),
      ),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // Profile Options
              _buildProfileOption(
                icon: Icons.person,
                title: 'Edit Profile',
                onTap: () => controller.showEditProfile(),
              ),
              _buildProfileOption(
                icon: Icons.shopping_bag,
                title: 'My Orders',
                onTap: () => Get.toNamed('/my-orders'),
              ),
              _buildProfileOption(
                icon: Icons.location_on,
                title: 'Saved Addresses',
                onTap: () => Get.snackbar('Info', 'Coming soon'),
              ),
              _buildProfileOption(
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () => Get.snackbar('Info', 'Coming soon'),
              ),
              _buildProfileOption(
                icon: Icons.info,
                title: 'About',
                onTap: () => Get.snackbar('Info', 'Lapma v1.0.0'),
              ),
              const SizedBox(height: 16),
              _buildProfileOption(
                icon: Icons.logout,
                title: 'Logout',
                onTap: controller.logout,
                isDestructive: true,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : AppColors.textPrimary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDestructive ? Colors.red : AppColors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
