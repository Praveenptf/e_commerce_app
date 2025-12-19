import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechine_test/models/cart_models.dart';
import 'package:mechine_test/models/product_models.dart';
import 'package:mechine_test/service/storage_service.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  void loadCart() {
    final user = StorageService.getCurrentUser();
    if (user != null) {
      cartItems.value = StorageService.getUserCart(user.id);
    } else {
      cartItems.clear();
    }
  }

  void addToCart(Product product) {
    final user = StorageService.getCurrentUser();
    if (user == null) {
      Get.snackbar(
        'Error',
        'Please login to add items to cart',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product, quantity: 1));
    }

    saveCart();
    Get.snackbar(
      'Success',
      'Item added to cart',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      cartItems[index].quantity = quantity;
      cartItems.refresh();
      saveCart();
    }
  }

  void incrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
      saveCart();
    }
  }

  void decrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
        saveCart();
      } else {
        removeFromCart(productId);
      }
    }
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
    saveCart();
    Get.snackbar(
      'Removed',
      'Item removed from cart',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearCart() {
    final user = StorageService.getCurrentUser();
    if (user != null) {
      cartItems.clear();
      StorageService.clearUserCart(user.id);
    }
  }

  void saveCart() {
    final user = StorageService.getCurrentUser();
    if (user != null) {
      StorageService.saveUserCart(user.id, cartItems);
    }
  }

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get shippingFee {
    return cartItems.isEmpty ? 0 : 1.3;
  }

  double get total {
    return subtotal + shippingFee;
  }

  int get itemCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
