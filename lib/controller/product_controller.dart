import 'package:get/get.dart';

class ProductController extends GetxController {
  final selectedQuantity = 1.obs;

  void incrementQuantity() {
    selectedQuantity.value++;
  }

  void decrementQuantity() {
    if (selectedQuantity.value > 1) {
      selectedQuantity.value--;
    }
  }

  void resetQuantity() {
    selectedQuantity.value = 1;
  }
}
