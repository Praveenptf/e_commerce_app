import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mechine_test/models/product_models.dart';
import 'package:mechine_test/models/user_models.dart';
import 'package:mechine_test/service/storage_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
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

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = StorageService.getUserByEmail(email);

      if (user == null) {
        return {
          'success': false,
          'message': 'No account found with this email',
        };
      }

      if (!StorageService.checkPassword(email, password)) {
        return {'success': false, 'message': 'Incorrect password'};
      }

      await StorageService.updateUserLoginTime(email);

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

  static Future<void> logout() async {
    await StorageService.logout();
  }

  static User? getCurrentUser() {
    return StorageService.getCurrentUser();
  }

  static bool isLoggedIn() {
    return StorageService.isLoggedIn();
  }

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
