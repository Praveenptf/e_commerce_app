import 'package:get/get.dart';
import 'package:mechine_test/models/order_models.dart';
import 'package:mechine_test/service/api_service.dart';
import 'package:mechine_test/service/storage_service.dart';

class OrderController extends GetxController {
  final orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      orders.value = StorageService.getUserOrders(user.id);
    }
  }
}
