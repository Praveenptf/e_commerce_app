import 'package:get/get.dart';
import 'package:mechine_test/models/product_models.dart';
import 'package:mechine_test/service/api_service.dart';

class CategoryController extends GetxController {
  final String category;

  CategoryController({required this.category});

  final products = <Product>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoryProducts();
  }

  Future<void> fetchCategoryProducts() async {
    try {
      isLoading.value = true;
      products.value = await ApiService.getProductsByCategory(category);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void sortByPriceLowToHigh() {
    products.sort((a, b) => a.price.compareTo(b.price));
  }

  void sortByPriceHighToLow() {
    products.sort((a, b) => b.price.compareTo(a.price));
  }

  void sortByRating() {
    products.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
  }

  void sortByPopularity() {
    products.sort((a, b) => b.rating.count.compareTo(a.rating.count));
  }
}
