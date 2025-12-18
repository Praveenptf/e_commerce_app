import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mechine_test/models/product_models.dart';
import 'package:mechine_test/models/user_models.dart';
import 'package:mechine_test/service/storage_service.dart';

class AuthService {
  // Signup
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Register user (password will be hashed in StorageService)
      final success = await StorageService.registerUser(name, email, password);

      if (!success) {
        return {
          'success': false,
          'message': 'User with this email already exists',
        };
      }

      return {'success': true, 'message': 'Account created successfully'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create account: ${e.toString()}',
      };
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Check if user exists
      final user = StorageService.getUserByEmail(email);

      if (user == null) {
        return {
          'success': false,
          'message': 'No account found with this email',
        };
      }

      // Verify password (will be hashed and compared in StorageService)
      if (!StorageService.checkPassword(email, password)) {
        return {'success': false, 'message': 'Incorrect password'};
      }

      // Update last login time
      await StorageService.updateUserLoginTime(email);

      // Save current user
      final updatedUser = StorageService.getUserByEmail(email);
      if (updatedUser != null) {
        await StorageService.saveUser(updatedUser);
      }

      return {
        'success': true,
        'message': 'Login successful',
        'user': updatedUser,
      };
    } catch (e) {
      return {'success': false, 'message': 'Login failed: ${e.toString()}'};
    }
  }

  // Logout
  static Future<void> logout() async {
    await StorageService.logout();
  }

  // Get current user
  static User? getCurrentUser() {
    return StorageService.getCurrentUser();
  }

  // Check if logged in
  static bool isLoggedIn() {
    return StorageService.isLoggedIn();
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser == null) {
        return {'success': false, 'message': 'No user logged in'};
      }

      final updatedUser = currentUser.copyWith(
        name: name,
        phone: phone,
        address: address,
      );

      await StorageService.updateUser(updatedUser);
      await StorageService.saveUser(updatedUser);

      return {
        'success': true,
        'message': 'Profile updated successfully',
        'user': updatedUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update profile: ${e.toString()}',
      };
    }
  }
}

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  // Fetch all products
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Fetch all categories
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/categories'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((category) => category.toString()).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Fetch products by category
  static Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$category'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products by category');
      }
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Fetch single product by ID
  static Future<Product?> getProductById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }
}
