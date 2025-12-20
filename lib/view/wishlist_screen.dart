// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mechine_test/app_theme/appcolor.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: AppColors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add products to your wishlist',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
