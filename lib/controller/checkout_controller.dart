import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechine_test/models/order_models.dart';
import 'package:mechine_test/roots/approot.dart';
import 'package:mechine_test/service/api_service.dart';
import 'package:mechine_test/service/storage_service.dart';
import '../controller/cart_controller.dart';

class CheckoutController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      nameController.text = user.name;
      phoneController.text = user.phone ?? '';
      addressController.text = user.address ?? '';
    }
  }

  Future<void> placeOrder() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return;
    }

    if (addressController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter delivery address');
      return;
    }

    try {
      isLoading.value = true;

      final cartController = Get.find<CartController>();
      final user = AuthService.getCurrentUser();

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user?.id ?? '',
        items: cartController.cartItems,
        totalAmount: cartController.cartItems.fold(
          0,
          (sum, item) => sum + item.product.price * item.quantity,
        ),
        status: 'Pending',
        deliveryAddress: addressController.text.trim(),
        customerName: nameController.text.trim(),
        customerPhone: phoneController.text.trim(),
        orderDate: DateTime.now(),
      );

      await StorageService.saveOrder(order);
      cartController.clearCart();

      Get.snackbar(
        'Success',
        'Order placed successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(AppRoutes.orderSuccess);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
