import 'package:get_storage/get_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:mechine_test/models/cart_models.dart';
import 'package:mechine_test/models/order_models.dart';
import 'dart:convert';

import 'package:mechine_test/models/user_models.dart';

class StorageService {
  static final GetStorage _box = GetStorage();

  // Keys
  static const String _userKey = 'current_user';
  static const String _usersKey = 'users';
  static const String _cartKey = 'cart_items';
  static const String _ordersKey = 'orders';
  static const String _isLoggedInKey = 'is_logged_in';

  // Initialize GetStorage
  static Future<void> init() async {
    await GetStorage.init();
  }

  // Hash password using SHA-256
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // User Authentication
  static Future<void> saveUser(User user) async {
    await _box.write(_userKey, user.toJson());
    await _box.write(_isLoggedInKey, true);

    // Save to users list
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

  // Check password with hashing
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

  // Register user with password hashing
  static Future<bool> registerUser(
    String name,
    String email,
    String password,
  ) async {
    List<dynamic> users = _box.read(_usersKey) ?? [];

    // Check if user already exists
    if (users.any((u) => u['email'] == email.toLowerCase())) {
      return false;
    }

    // Hash password before storing
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

  // Update user login time
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

  // Update user profile
  static Future<void> updateUser(User user) async {
    List<dynamic> users = _box.read(_usersKey) ?? [];
    final userIndex = users.indexWhere((u) => u['email'] == user.email);

    if (userIndex != -1) {
      users[userIndex] = user.toJson();
      await _box.write(_usersKey, users);

      // Update current user if it's the same
      final currentUser = getCurrentUser();
      if (currentUser?.email == user.email) {
        await _box.write(_userKey, user.toJson());
      }
    }
  }

  // Cart Management
  static Future<void> saveCart(List<CartItem> items) async {
    final jsonItems = items.map((item) => item.toJson()).toList();
    await _box.write(_cartKey, jsonItems);
  }

  static List<CartItem> getCart() {
    final List<dynamic> items = _box.read(_cartKey) ?? [];
    return items.map((item) => CartItem.fromJson(item)).toList();
  }

  static Future<void> clearCart() async {
    await _box.remove(_cartKey);
  }

  // Order Management
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

  // Clear all data (for testing or logout)
  static Future<void> clearAll() async {
    await _box.erase();
  }

  // Get all users (for admin purposes)
  static List<User> getAllUsers() {
    final List<dynamic> users = _box.read(_usersKey) ?? [];
    return users.map((user) => User.fromJson(user)).toList();
  }
}
