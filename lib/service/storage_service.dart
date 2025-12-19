import 'package:get_storage/get_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:mechine_test/models/cart_models.dart';
import 'package:mechine_test/models/order_models.dart';
import 'dart:convert';

import 'package:mechine_test/models/user_models.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  static const String _userKey = 'current_user';
  static const String _usersKey = 'users';
  static const String _cartKey = 'cart_items';
  static const String _ordersKey = 'orders';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<void> init() async {
    await GetStorage.init();
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static Future<void> saveUser(User user) async {
    await _box.write(_userKey, user.toJson());
    await _box.write(_isLoggedInKey, true);

    List<dynamic> users = _box.read(_usersKey) ?? [];
    final existingIndex = users.indexWhere((u) => u['email'] == user.email);
    if (existingIndex != -1) {
      users[existingIndex] = user.toJson();
    } else {
      users.add(user.toJson());
    }
    await _box.write(_usersKey, users);
  }

  static User? getCurrentUser() {
    final userData = _box.read(_userKey);
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  static bool isLoggedIn() {
    return _box.read(_isLoggedInKey) ?? false;
  }

  static Future<void> logout() async {
    await _box.remove(_userKey);
    await _box.write(_isLoggedInKey, false);
  }

  static User? getUserByEmail(String email) {
    List<dynamic> users = _box.read(_usersKey) ?? [];
    try {
      final userData = users.firstWhere(
        (u) => u['email'] == email.toLowerCase(),
      );
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  static bool checkPassword(String email, String password) {
    List<dynamic> users = _box.read(_usersKey) ?? [];
    try {
      final userData = users.firstWhere(
        (u) => u['email'] == email.toLowerCase(),
      );
      final hashedPassword = _hashPassword(password);
      return userData['password'] == hashedPassword;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> registerUser(
    String name,
    String email,
    String password,
  ) async {
    List<dynamic> users = _box.read(_usersKey) ?? [];

    if (users.any((u) => u['email'] == email.toLowerCase())) {
      return false;
    }

    final hashedPassword = _hashPassword(password);

    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email.toLowerCase(),
      password: hashedPassword,
      createdAt: DateTime.now(),
    );

    users.add(user.toJson());
    await _box.write(_usersKey, users);
    return true;
  }

  static Future<void> updateUserLoginTime(String email) async {
    List<dynamic> users = _box.read(_usersKey) ?? [];
    final userIndex = users.indexWhere(
      (u) => u['email'] == email.toLowerCase(),
    );

    if (userIndex != -1) {
      final userData = users[userIndex];
      final user = User.fromJson(userData);
      final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
      users[userIndex] = updatedUser.toJson();
      await _box.write(_usersKey, users);
      await _box.write(_userKey, updatedUser.toJson());
    }
  }

  static Future<void> updateUser(User user) async {
    List<dynamic> users = _box.read(_usersKey) ?? [];
    final userIndex = users.indexWhere((u) => u['email'] == user.email);

    if (userIndex != -1) {
      users[userIndex] = user.toJson();
      await _box.write(_usersKey, users);

      final currentUser = getCurrentUser();
      if (currentUser?.email == user.email) {
        await _box.write(_userKey, user.toJson());
      }
    }
  }

  static Future<void> saveUserCart(String userId, List<CartItem> items) async {
    List<dynamic> allCarts = _box.read(_cartKey) ?? [];

    allCarts.removeWhere((cart) => cart['userId'] == userId);

    for (var item in items) {
      final cartData = item.toJson();
      cartData['userId'] = userId;
      allCarts.add(cartData);
    }

    await _box.write(_cartKey, allCarts);
  }

  static List<CartItem> getUserCart(String userId) {
    final List<dynamic> allCarts = _box.read(_cartKey) ?? [];
    final userCarts = allCarts
        .where((cart) => cart['userId'] == userId)
        .toList();
    return userCarts.map((item) => CartItem.fromJson(item)).toList();
  }

  static Future<void> clearUserCart(String userId) async {
    List<dynamic> allCarts = _box.read(_cartKey) ?? [];
    allCarts.removeWhere((cart) => cart['userId'] == userId);
    await _box.write(_cartKey, allCarts);
  }

  static Future<void> saveCart(List<CartItem> items) async {
    final user = getCurrentUser();
    if (user != null) {
      await saveUserCart(user.id, items);
    }
  }

  static List<CartItem> getCart() {
    final user = getCurrentUser();
    if (user != null) {
      return getUserCart(user.id);
    }
    return [];
  }

  static Future<void> clearCart() async {
    final user = getCurrentUser();
    if (user != null) {
      await clearUserCart(user.id);
    }
  }

  static Future<void> saveOrder(Order order) async {
    List<dynamic> orders = _box.read(_ordersKey) ?? [];
    orders.insert(0, order.toJson());
    await _box.write(_ordersKey, orders);
  }

  static List<Order> getOrders() {
    final List<dynamic> orders = _box.read(_ordersKey) ?? [];
    return orders.map((order) => Order.fromJson(order)).toList();
  }

  static List<Order> getUserOrders(String userId) {
    final List<dynamic> orders = _box.read(_ordersKey) ?? [];
    return orders
        .map((order) => Order.fromJson(order))
        .where((order) => order.userId == userId)
        .toList();
  }

  static Future<void> clearAll() async {
    await _box.erase();
  }

  static List<User> getAllUsers() {
    final List<dynamic> users = _box.read(_usersKey) ?? [];
    return users.map((user) => User.fromJson(user)).toList();
  }
}
