import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechine_test/models/cart_models.dart';
import 'package:mechine_test/models/order_models.dart';
import 'package:mechine_test/models/product_models.dart';
import 'package:mechine_test/roots/approot.dart';
import 'package:mechine_test/service/api_service.dart';
import 'package:mechine_test/service/storage_service.dart';
import '../controller/cart_controller.dart';

class CheckoutController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final isLoading = false.obs;

  Product? buyNowProduct;
  final buyNowQuantity = 1.obs;

  late final CartController _cartController;

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();
    _loadUserData();

    if (Get.arguments != null && Get.arguments is Product) {
      buyNowProduct = Get.arguments as Product;
    }
  }

  void _loadUserData() {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      nameController.text = user.name;
      phoneController.text = user.phone ?? '';
      addressController.text = user.address ?? '';
    }
  }

  bool get isBuyNowCheckout => buyNowProduct != null;

  List<CartItem> get checkoutItems {
    if (isBuyNowCheckout) {
      return [
        CartItem(product: buyNowProduct!, quantity: buyNowQuantity.value),
      ];
    } else {
      return _cartController.cartItems;
    }
  }

  double get subtotal {
    if (isBuyNowCheckout) {
      return buyNowProduct!.price * buyNowQuantity.value;
    } else {
      return _cartController.subtotal;
    }
  }

  double get shippingFee {
    if (isBuyNowCheckout) {
      return 1.3;
    } else {
      return _cartController.shippingFee;
    }
  }

  double get total {
    return subtotal + shippingFee;
  }

  void incrementBuyNowQuantity() {
    buyNowQuantity.value++;
  }

  void decrementBuyNowQuantity() {
    if (buyNowQuantity.value > 1) {
      buyNowQuantity.value--;
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

      final user = AuthService.getCurrentUser();

      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user?.id ?? '',
        items: checkoutItems,
        totalAmount: subtotal,
        status: 'Pending',
        deliveryAddress: addressController.text.trim(),
        customerName: nameController.text.trim(),
        customerPhone: phoneController.text.trim(),
        orderDate: DateTime.now(),
      );

      await StorageService.saveOrder(order);

      if (!isBuyNowCheckout) {
        _cartController.clearCart();
      }

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
