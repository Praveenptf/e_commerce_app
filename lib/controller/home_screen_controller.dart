import 'dart:async';
import 'package:get/get.dart';
import 'package:mechine_test/models/product_models.dart';
import 'package:mechine_test/service/api_service.dart';
import 'package:mechine_test/widgets/banner.dart';

class HomeController extends GetxController {
  final products = <Product>[].obs;
  final categories = <String>[].obs;
  final isLoading = false.obs;

  // Banner state
  final isLoadingOffers = true.obs;
  final offerBanners = <OfferBanner>[].obs;

  // Countdown timer
  final countdownDays = 0.obs;
  final countdownHours = 0.obs;
  final countdownMinutes = 0.obs;
  final countdownSeconds = 0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
    startCountdown();
    loadOffers(); // 👈 load banners here
  }

  // ✅ LOAD ASSET BANNERS
  void loadOffers() async {
    try {
      isLoadingOffers.value = true;

      offerBanners.assignAll([
        OfferBanner(imagePath: 'assets/1.jpg'),
        OfferBanner(imagePath: 'assets/2.jpg'),
        OfferBanner(imagePath: 'assets/3.avif'),
      ]);
    } finally {
      isLoadingOffers.value = false;
    }
  }

  void startCountdown() {
    final endTime = DateTime.now().add(const Duration(hours: 24));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final difference = endTime.difference(DateTime.now());

      if (difference.isNegative) {
        timer.cancel();
        return;
      }

      countdownDays.value = difference.inDays;
      countdownHours.value = difference.inHours % 24;
      countdownMinutes.value = difference.inMinutes % 60;
      countdownSeconds.value = difference.inSeconds % 60;
    });
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    products.value = await ApiService.getProducts();
    isLoading.value = false;
  }

  Future<void> fetchCategories() async {
    categories.value = await ApiService.getCategories();
  }

  List<Product> get featuredProducts => products.take(6).toList();

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
