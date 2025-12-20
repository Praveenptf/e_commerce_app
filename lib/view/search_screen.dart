// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';
import 'package:mechine_test/models/product_models.dart';
import 'package:mechine_test/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mechine_test/app_theme/appcolor.dart';
import 'package:mechine_test/roots/approot.dart';

class SearchController extends GetxController {
  var isLoading = false.obs;
  var allProducts = <Product>[].obs;
  var searchResults = <Product>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    try {
      isLoading.value = true;
      allProducts.value = await ApiService.getProducts();
      searchResults.value = allProducts;
    } catch (e) {
      //
    } finally {
      isLoading.value = false;
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      searchResults.value = allProducts;
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    searchResults.value = allProducts.where((product) {
      return product.title.toLowerCase().contains(lowercaseQuery) ||
          product.category.toLowerCase().contains(lowercaseQuery) ||
          product.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.value = allProducts;
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchController searchController = Get.put(SearchController());
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: textController,
          focusNode: focusNode,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            border: InputBorder.none,
            suffixIcon: Obx(() {
              if (searchController.searchQuery.value.isEmpty) {
                return const SizedBox();
              }
              return IconButton(
                icon: const Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  textController.clear();
                  searchController.clearSearch();
                  focusNode.requestFocus();
                },
              );
            }),
          ),
          onChanged: (value) {
            searchController.searchProducts(value);
          },
        ),
        toolbarHeight: 90,
      ),
      body: Obx(() {
        if (searchController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (searchController.searchQuery.value.isEmpty) {
          return _buildEmptyState(
            icon: Icons.search,
            title: 'Search for Products',
            subtitle: 'Start typing to search for products',
          );
        }

        if (searchController.searchResults.isEmpty) {
          return _buildEmptyState(
            icon: Icons.search_off,
            title: 'No Results Found',
            subtitle: 'Try searching with different keywords',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: searchController.searchResults.length,
          itemBuilder: (context, index) {
            return _buildSearchResultItem(
              searchController.searchResults[index],
            );
          },
        );
      }),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.grey),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(Product product) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: product.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 100,
                  color: AppColors.background,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 100,
                  color: AppColors.background,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: AppColors.grey,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category
                          .split(' ')
                          .map(
                            (word) => word[0].toUpperCase() + word.substring(1),
                          )
                          .join(' '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating.rate}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
